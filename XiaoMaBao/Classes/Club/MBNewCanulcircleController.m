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
#import "MBSearchPostController.h"
#import "MBShopDetailsViewController.h"
#import "MBMyCircleController.h"
#import "MBNewsCircleController.h"
#import "APService.h"
#import "MBLoginViewController.h"
@interface MBNewCanulcircleController ()<UIScrollViewDelegate>
{
    UIButton *_lastButton;
    BOOL     _isDismiss;
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBNewCanulcircleController"];
    _isDismiss = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBNewCanulcircleController"];
    
    NSString *messageNumber = [User_Defaults objectForKey:@"messageNumber"];
    
    
    if (messageNumber&&[messageNumber intValue]>0 ) {
        [self.messageBadge autoBadgeSizeWithString:messageNumber];
        self.messageBadge.hidden = NO;
    }else{
        self.messageBadge.hidden = YES;
    }
    if (_isDismiss) {
        
          MBMyCircleController    *myCircleView = self.childViewControllers[0];
        myCircleView.isDimiss = YES;
        _isDismiss = !_isDismiss;
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
        [APService setTags:sets alias:@"sunxianglong" callbackSelector:nil object:self];
        
    });
    
    [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self dismiss];
        if ([[responseObject valueForKeyPath:@"number"] integerValue]>0) {
            [self.messageBadge autoBadgeSizeWithString:s_str([responseObject valueForKeyPath:@"number"])];
            self.messageBadge.hidden = NO;
        }else{
        self.messageBadge.hidden = YES;
        }
        
            
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];

    
    
}
- (void)setupChildVcs{
    
    MBMyCircleController *VC3 = [[MBMyCircleController alloc] init];
    VC3.title = @"我的圈";
    [self addChildViewController:VC3];
    
    MBTopPostsController *VC1 = [[MBTopPostsController alloc] init];
    VC1.title = @"热帖";
    [self addChildViewController:VC1];
    
    MBMoreCirclesController *VC2 = [[MBMoreCirclesController alloc] init];
    VC2.title = @"更多圈";
    [self addChildViewController:VC2];
    
}
- (void)setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, 31);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonH = 30;
    CGFloat titleButtonW = (UISCREEN_WIDTH-1) / count;
    for (int  i = 0; i<count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.backgroundColor = NavBar_Color;
        NSString *title = [self.childViewControllers[i] title];
        [titleButton setTitle:title forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(i*(titleButtonW+1),1, titleButtonW, titleButtonH);
        [self.titleButtons addObject:titleButton];
        if (i==0) {
            _lastButton = titleButton;
            _lastButton.backgroundColor = [UIColor colorWithHexString:@"dd9682"];
        }
        [_titlesView addSubview:titleButton];
    }
    
}

- (void)setupScrollView
{
    // 不要自动调整scrollView的contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 31+TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-31-TOP_Y -49);
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
- (NSString *)leftImage{
    
    return @"newsCircle_image";
    
}

- (void)rightTitleClick{
    
   
    MBSearchPostController *searchVc = [[MBSearchPostController alloc] init];
    [self pushViewController:searchVc Animated:YES];
    
}
-(void)leftTitleClick{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (! sid) {
        
        [self loginClicksss];
    }
    
  [User_Defaults setObject:nil forKey:@"messageNumber"];
    [User_Defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"messageBadge" object:nil userInfo:nil]];
    MBNewsCircleController *searchVc = [[MBNewsCircleController alloc] init];
    [self pushViewController:searchVc Animated:YES];
    
}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    //跳转到登录页
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}
-(NSString *)titleStr{
    
    return @"麻包圈";
}
-(NSString *)leftStr{
    
    return @"";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)titleClick:(UIButton *)titleButton
{
    if (![_lastButton isEqual:titleButton]) {
        
        MBMoreCirclesController *moreCirclesView = self.childViewControllers[2];
        MBMyCircleController    *myCircleView = self.childViewControllers[0];
        
        if (titleButton.tag==2) {
            
            [moreCirclesView.myCircleViewSubject  sendNext:@1];
        }else{
            if (moreCirclesView.isViewLoaded) {
                [moreCirclesView.myCircleViewSubject  sendNext:@0];
            }
        }
        
        if (titleButton.tag == 0) {
            [myCircleView.myCircleViewSubject  sendNext:@1];
        }
        
        // 让scrollView滚动到对应的位置
        _lastButton.backgroundColor = NavBar_Color;
        _lastButton = titleButton;
        _lastButton.backgroundColor = [UIColor colorWithHexString:@"dd9682"];
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = UISCREEN_WIDTH* [self.titleButtons indexOfObject:titleButton];
        [self.scrollView setContentOffset:offset animated:YES];
    }
    
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
    [self titleClick:self.titleButtons[index]];
}


@end
