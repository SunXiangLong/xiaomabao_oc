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
#import "MBSearchViewController.h"
#import "MBShopDetailsViewController.h"
#import "MBMyCircleController.h"
@interface MBNewCanulcircleController ()<UIScrollViewDelegate>
{
    UIButton *_lastButton;
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
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBNewCanulcircleController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildVcs];
    [self setupTitlesView];
    [self setupScrollView];
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
- (void)rightTitleClick{
    MBSearchViewController *searchVc = [[MBSearchViewController alloc] init];
    [self pushViewController:searchVc Animated:YES];
}
-(NSString *)titleStr{
    return @"麻包圈";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)titleClick:(UIButton *)titleButton
{
    if (![_lastButton isEqual:titleButton]) {
        
        MBMoreCirclesController *view = self.childViewControllers[2];
        
        
        if (titleButton.tag==2) {
            
            [view.myCircleViewSubject  sendNext:@1];
        }else{
            if (view.isViewLoaded) {
                 [view.myCircleViewSubject  sendNext:@0];
            }
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
