//
//  MBGiftCardViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBGiftCardViewController.h"
#import "MBMaoBaoCardViewController.h"
#import "MBWelfareCardViewController.h"
#import "MBBaseScrollView.h"
@interface MBGiftCardViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

/**top分类选项*/
@property(nonatomic, strong) UISegmentedControl *segmengtedControl;
/** 这个scrollView的作用：存放所有子控制器的view */
@property (weak, nonatomic) IBOutlet MBBaseScrollView *scrollView;

@end
@implementation MBGiftCardViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildVcs];
    [self setUI];
  
   
    
}
- (void)setUpChildVcs{
    MBMaoBaoCardViewController *VC1 =   [[UIStoryboard storyboardWithName:@"Shopping" bundle:nil] instantiateViewControllerWithIdentifier:@"MBMaoBaoCardViewController"];
    VC1.title = @"麻包卡&共享卡";
    [self addChildViewController:VC1];
    
    MBWelfareCardViewController *VC2 = [[UIStoryboard storyboardWithName:@"Shopping" bundle:nil] instantiateViewControllerWithIdentifier:@"MBWelfareCardViewController"];
    VC2.title = @"福利卡";
    [self addChildViewController:VC2];
}
- (void)setUI{
    self.navBar.rightButton.mj_w = 70;
    self.navBar.rightButton.mj_x = UISCREEN_WIDTH - 75;
    self.navBar.rightButton.titleLabel.font = YC_RTWSYueRoud_FONT(14);
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"麻包卡&共享卡",@"福利卡"]];
    // 设置默认选择项索引
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = [UIColor whiteColor];
    // 设置指定索引的题目
    [segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    [segmentControl setTitleTextAttributes:@{NSFontAttributeName:YC_RTWSYueRoud_FONT(15)} forState:UIControlStateNormal];
    [self.navBar addSubview:_segmengtedControl = segmentControl];
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(8);
        make.centerX.mas_equalTo(0);
        make.left.equalTo(self.navBar.leftButton.mas_right).offset(5);
        make.right.equalTo(self.navBar.rightButton.mas_left).offset(-5);
    }];
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count * UISCREEN_WIDTH, 0);
    [self scrollViewDidEndScrollingAnimation:_scrollView];

}
- (void)didClickSegmentedControlAction:(UISegmentedControl *)segmentControl
{
    NSInteger idx = segmentControl.selectedSegmentIndex;
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = UISCREEN_WIDTH*idx;
    [self.scrollView setContentOffset:offset animated:YES];
}
-(NSString *)rightStr{
  return @"帮助中心";
}
-(void)rightTitleClick{

    [self performSegueWithIdentifier:@"MBElectronicOrderHelpcenterVC" sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _segmengtedControl.selectedSegmentIndex = index;
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat contentOffsetX = scrollView.contentOffset.x;
//    if (contentOffsetX < 0) {
//        scrollView.scrollEnabled = false;
//    }else{
//        scrollView.scrollEnabled = true;
//    }
//}
@end
