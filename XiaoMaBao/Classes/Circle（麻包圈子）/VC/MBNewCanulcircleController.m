//
//  MBNewHomeViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewCanulcircleController.h"
#import "MBTopPostsController.h"
#import "MBMoreCirclesController.h"
#import "MBSearchPostViewController.h"
#import "MBMyCircleController.h"
#import "MBNewsCircleController.h"
#import "JPUSHService.h"
@interface MBNewCanulcircleController ()<UIScrollViewDelegate>
{
    UISegmentedControl *_segmentControl;
}
@property (nonatomic,strong) UIView *titlesView;
/** 这个scrollView的作用：存放所有子控制器的view */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;
@end

@implementation MBNewCanulcircleController
#pragma mark - lazy
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *messageNumber = [User_Defaults objectForKey:@"messageNumber"];
    if (messageNumber&&[messageNumber intValue]>0 ) {
        [self.messageBadge autoBadgeSizeWithString:messageNumber];
        self.messageBadge.hidden = NO;
    }else{
        self.messageBadge.hidden = YES;
    }
}
- (void)viewDidLoad {
    
    self.back = YES;
    
    [super viewDidLoad];
    [self setUnreadMessages];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildVcs];
    [self setupTitlesView];
    [self setupScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBadge:) name:@"messageBadge" object:nil];
    
}

- (void)messageBadge:(NSNotification *)notificat{
    NSString *badgeValue =  [User_Defaults objectForKey:@"messageNumber"];
    
    if (badgeValue&&[badgeValue integerValue]>0) {
        [ self.messageBadge autoBadgeSizeWithString:badgeValue];
        self.messageBadge.hidden = NO;
    }else{
        self.messageBadge.hidden = YES;
    }
}

#pragma mark --获取未读消息数
- (void)setUnreadMessages{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/get_message_number"];
    if (! sid) {
        return;
    }
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        
        NSSet *sets = [NSSet setWithObject:uid];
        [ JPUSHService setTags:sets alias:@"sunxianglong" callbackSelector:nil object:self];
        
    });
    
    [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict} success:^(id responseObject) {
        if ([[responseObject valueForKeyPath:@"number"] integerValue]>0) {
            [self.messageBadge autoBadgeSizeWithString:s_str([responseObject valueForKeyPath:@"number"])];
            self.messageBadge.hidden = NO;
        }else{
            self.messageBadge.hidden = YES;
        }
        
        
        
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        MMLog(@"%@",error);
    }];
    
    
    
}
- (void)setupChildVcs{
    MBMyCircleController *VC3 =   [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"MBMyCircleController"];
    
    VC3.title = @"我的圈";
    [self addChildViewController:VC3];
    
    MBTopPostsController *VC1 =  [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"MBTopPostsController"];
    VC1.title = @"热帖";
    [self addChildViewController:VC1];
    
    MBMoreCirclesController *VC2 = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"MBMoreCirclesController"];
    VC2.title = @"更多圈";
    [self addChildViewController:VC2];
    
}
- (void)setupTitlesView
{
    
    
    NSArray *segmentArray = @[
                              @"我的圈",
                              @"热帖",
                              @"更多圈"
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
    MBMoreCirclesController *moreCirclesView = self.childViewControllers[2];
    
    
    if (idx==2) {
        if (moreCirclesView.block) {
            moreCirclesView.block(1);
        }
        
        
    }else{
        if (moreCirclesView.isViewLoaded) {
            moreCirclesView.block(0);
            
        }
    }
    
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = UISCREEN_WIDTH*idx;
    [self.scrollView setContentOffset:offset animated:YES];
}
- (void)setupScrollView
{
    // 不要自动调整scrollView的contentInset
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0,TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y-49);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * UISCREEN_WIDTH, 0);
    [self.view addSubview:scrollView];
    self.scrollView            = scrollView;
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
- (NSString *)rightImage{
    
    return @"search_image";
}
- (NSString *)leftImage{
    
    return @"newsCircle_image";
    
}

- (void)rightTitleClick{
    [MobClick event:@"MaBaoCircle4"];

    MBSearchPostViewController *searchViewController = [[MBSearchPostViewController alloc] init:PYSearchResultShowModePost];
    searchViewController.hotSearches = @[@""];
    searchViewController.hotSearchStyle =  PYHotSearchStyleColorfulTag;
    searchViewController.searchBar.placeholder = @"请输入要搜索帖子";
    searchViewController.hotSearchHeader.text = @"大家都在搜";
    MBNavigationViewController *nav = [[MBNavigationViewController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"mm_navGroundImage"] forBarMetrics:UIBarMetricsDefault];
    
    
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:nav  animated:NO completion:nil];
    
}
-(void)leftTitleClick{
    [MobClick event:@"MaBaoCircle0"];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (! sid) {
        
        [self  loginClicksss:@"mabao"];
        return;
    }
    
    [User_Defaults setObject:nil forKey:@"messageNumber"];
    [User_Defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"messageBadge" object:nil userInfo:nil]];
    MBNewsCircleController *searchVc = [[MBNewsCircleController alloc] init];
    [self pushViewController:searchVc Animated:YES];
    
}


-(NSString *)leftStr{
    
    return @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    if (index ==2) {
        MBMoreCirclesController *view = (MBMoreCirclesController *)willShowChildVc;
        view.MinView = self.view;
    }
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
    [self didClickSegmentedControlAction:_segmentControl];
}


@end
