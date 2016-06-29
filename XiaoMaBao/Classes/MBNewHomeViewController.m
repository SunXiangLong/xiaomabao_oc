//
//  MBNewHomeViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewHomeViewController.h"
#import "MBAffordablePlanetViewController.h"
#import "MBFreeStoreViewController.h"
#import "MBSearchViewController.h"
#import "MBShopDetailsViewController.h"
#import "MBTopCargoController.h"
#import "MBShopingViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
#import "MBNewFreeStoreViewController.h"
#import "MBNewAffordablePlanetViewController.h"

@interface MBNewHomeViewController ()<UIScrollViewDelegate>
{
    
    UISegmentedControl *_segmentControl;
}
@property (nonatomic,strong) UIView *titlesView;
/** 这个scrollView的作用：存放所有子控制器的view */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;
@end

@implementation MBNewHomeViewController
#pragma mark - lazy
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBNewHomeViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBNewHomeViewController"];
    
    NSDictionary *userInfo = [User_Defaults valueForKeyPath:@"userInfo"];
    if (userInfo) {
        NSString *type = userInfo[@"type"];
        if ([type isEqualToString:@"goods"]) {
            MBShopingViewController *VC = [[MBShopingViewController alloc] init];
            VC.GoodsId =  userInfo[@"id"];
            [self pushViewController:VC Animated:YES];
        }else if([type isEqualToString:@"topic"]){
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = userInfo[@"id"];
            [self pushViewController:VC Animated:YES];
        }else if([type isEqualToString:@"group"]){
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            [self pushViewController:VC Animated:YES];
        }else if([type isEqualToString:@"web"]){
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:userInfo[@"id"]];
            VC.isloging = YES;
            [self pushViewController:VC Animated:YES];
        }
        [User_Defaults setObject:nil forKey:@"userInfo"];
        [User_Defaults synchronize];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
     
    }
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildVcs];
    [self setupTitlesView];
    [self setupScrollView];
}
- (void)setupChildVcs{
  
    
    MBNewAffordablePlanetViewController *VC1 = [[MBNewAffordablePlanetViewController alloc] init];
    VC1.title = @"实惠星球";
    [self addChildViewController:VC1];
    
    MBNewFreeStoreViewController *VC3 = [[MBNewFreeStoreViewController alloc] init];
    VC3.title = @"全球闪购";
    [self addChildViewController:VC3];
}
- (void)setupTitlesView
{

    
    NSArray *segmentArray = @[
                             @"实惠星球",
                             @"全球闪购"
                              ];
    // 初始化UISegmentedControl
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    segmentControl.frame = CGRectMake((UISCREEN_WIDTH-200)/2, 27, 200, 25);
    // 设置默认选择项索引
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = [UIColor whiteColor];

    // 设置指定索引的题目
    [segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    [segmentControl setTitleTextAttributes:@{NSFontAttributeName:YC_RTWSYueRoud_FONT(15)} forState:UIControlStateNormal];
    [self.navBar addSubview:_segmentControl = segmentControl];


}
- (void)didClickSegmentedControlAction:(UISegmentedControl *)segmentControl
{
 
    NSInteger idx = segmentControl.selectedSegmentIndex;
  
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = UISCREEN_WIDTH*idx;
    [self.scrollView setContentOffset:offset animated:YES];

   
}
- (void)setupScrollView
{
    // 不要自动调整scrollView的contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y -49);
    scrollView.backgroundColor = [UIColor colorWithHexString:@"ececef"];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * UISCREEN_WIDTH, 0);
    [self.view addSubview:scrollView];
    self.scrollView                   = scrollView;

    [self scrollViewDidEndScrollingAnimation:scrollView];
}
- (NSString *)rightImage{
return @"search_image";
}

- (void)rightTitleClick{
    MBSearchViewController *searchVc = [[MBSearchViewController alloc] init];
    [self pushViewController:searchVc Animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@",@"收到内存⚠️");
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 当滚动动画完毕的时候调用（通过代码setContentOffset:animated:让scrollView滚动完毕后，就会调用这个方法）
 * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 取出对应的子控制器
    int index = scrollView.contentOffset.x / scrollView.ml_width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    // 如果控制器的view已经被创建过，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    
    // 添加子控制器的view到scrollView身上
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    int index = scrollView.contentOffset.x / scrollView.ml_width;
    _segmentControl.selectedSegmentIndex = index;
}


@end
