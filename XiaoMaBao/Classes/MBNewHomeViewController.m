//
//  MBNewHomeViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewHomeViewController.h"
#import "DataSigner.h"
#import "MBGoodSSearchViewController.h"
#import "MBGoodsDetailsViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
#import "MBAffordablePlanetViewController.h"
#import "MBFreeStoreViewController.h"
#import "MBMaBaoFeaturesViewController.h"
#import "MBCheckInViewController.h"
#import "MBServiceEvaluationController.h"
@interface MBNewHomeViewController ()<UIScrollViewDelegate,UnicallDelegate>
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

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    NSDictionary *userInfo = [User_Defaults valueForKeyPath:@"userInfo"];
    if (userInfo) {
        NSString *type = userInfo[@"type"];
        if ([type isEqualToString:@"goods"]) {
            MBGoodsDetailsViewController *VC = [[MBGoodsDetailsViewController alloc] init];
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
        }else if([type isEqualToString:@"signIn"]){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            MBCheckInViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBCheckInViewController"];
            [self presentViewController:myView animated:YES completion:nil];
        }
        [User_Defaults setObject:nil forKey:@"userInfo"];
        [User_Defaults synchronize];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
     
    }
    

}
- (void)viewDidLoad {
    [super viewDidLoad];

    [[Unicall singleton] attach:self appKey:UNICALL_APPKEY tenantId:UNICALL_TENANID];
    [self setupChildVcs];
    [self setupTitlesView];
    [self setupScrollView];
}
-(void)leftTitleClick{
    
//    MBServiceEvaluationController *VC  = [[MBServiceEvaluationController alloc] init];
//    [self  pushViewController:VC Animated:YES];
//    MBNewReleaseTopicViewController *vc = [[MBNewReleaseTopicViewController alloc] init];
//    [self pushViewController:vc Animated:true];

}
- (void)setupChildVcs{
  
    
    MBAffordablePlanetViewController *VC1 =   [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBAffordablePlanetViewController"];
    VC1.title = @"实惠星球";
    [self addChildViewController:VC1];
    
    MBFreeStoreViewController *VC2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBFreeStoreViewController"];
    VC2.title = @"全球闪购";
    [self addChildViewController:VC2];
    
    MBMaBaoFeaturesViewController *VC3 =   [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBMaBaoFeaturesViewController"];
    VC3.title = @"麻包特色";
    [self addChildViewController:VC3];
    
}
- (void)setupTitlesView
{

    
    NSArray *segmentArray = @[
                             @"实惠星球",
                             @"全球闪购",
                             @"麻包特色"
                              ];
    // 初始化UISegmentedControl
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    // 设置默认选择项索引
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = [UIColor whiteColor];
    // 设置指定索引的题目
    [segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    [segmentControl setTitleTextAttributes:@{NSFontAttributeName:YC_RTWSYueRoud_FONT(15)} forState:UIControlStateNormal];
    [self.navBar addSubview:_segmentControl = segmentControl];
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(8);
        make.centerX.mas_equalTo(0);
    }];
    


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
    scrollView.backgroundColor = [UIColor whiteColor];
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
    
    MBGoodSSearchViewController *searchViewController = [[MBGoodSSearchViewController alloc] init:NO];
    searchViewController.hotSearches = @[@""];
    searchViewController.hotSearchStyle =  PYHotSearchStyleColorfulTag;
    searchViewController.searchBar.placeholder = @"请输入要搜索商品名称";
    searchViewController.hotSearchHeader.text = @"大家都在搜";
    MBNavigationViewController *nav = [[MBNavigationViewController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"mm_navGroundImage"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:nav  animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    MMLog(@"%@",@"收到内存⚠️");
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

-(void)getUnicallSignature{
    NSString *privateKey =  [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             @"MIIBPAIBAAJBAMBrqadzplyUtQUXCP+VuDFWt0p9Kl+s3yrQ8PV+P89Bbt/UqN2/",
                             @"BzVNPoNgtQ2fI7Ob652limC/jqVf6slzPEUCAwEAAQJAOL7HXnGVqxHTvHeJmM4P",
                             @"bsVy8k2tNF/nxFmv5cXgjX7sd7BU9jyELGP4os3ID3tItdCHtmMM3KM91lTHYlkk",
                             @"dQIhAOWKnz0moWISa0S8cBYJI0k0PRoYMv6Xsty5aZpC9WM/AiEA1pmqSthbMUb2",
                             @"TrmRyJsHswLAYSHotTIS0kzHu655M3sCIQDLdWXUJCuj7EOcd5K6VXsrZdxLBuwc",
                             @"coYd01LhYzxyrQIhAIsqc6i9zcWTAz/iT4wMHV4VNrTGzKZUpqgCarRnXOnpAiEA",
                             @"pbZzKKXpVGNp2MMXRlpdzdGCKFMYSeqnqXuwd76iwco="
                             ];
    NSString *tenantId = UNICALL_TENANID;
    NSString *appKey = UNICALL_APPKEY;
    NSString *time = [self getCurrentTime];
    NSString *expireTime = @"60000";
    
    NSString *stringToSign = [NSString stringWithFormat:@"%@&%@&%@&%@",appKey,expireTime,tenantId,time];
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
    NSString *signature = [signer uncallString:stringToSign];
    NSDictionary *json = @{@"appKey":appKey,@"expireTime":expireTime,@"signature":signature,@"tenantId":tenantId,@"time":time};
    
    Unicall *unicall = [Unicall singleton];
    [unicall UnicallUpdateValidation:json];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
        [unicall UnicallUpdateUserInfo:@{@"nickname":@"未注册用户"}];
    }else{
        
        [unicall UnicallUpdateUserInfo:@{@"nickname": string(@"用户的sid:", sid)}];
    }
    
}
//delegate methods
-(void)acquireValidation
{
    [self getUnicallSignature];
}
-(void)messageCountUpdated:(NSNumber*) data
{

}
-(void)messageArrived:(NSDictionary*) data
{
    NSError* error = nil;
    NSData* source = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSString* str = [NSJSONSerialization JSONObjectWithData:source options:NSJSONReadingMutableContainers error:&error];
    MMLog(@"%@%@",@"Unicall message arrived.",str);
    
    if([[data objectForKey:@"eventName"] isEqualToString:@"updateNewMessageCount"])
        MMLog(@"count%@:",data);
}
-(UIViewController*) currentViewController
{

    return self.navigationController.viewControllers.lastObject;
}
-(NSString*)getCurrentTime {
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    
    
    return dateTime;
    
}

@end
