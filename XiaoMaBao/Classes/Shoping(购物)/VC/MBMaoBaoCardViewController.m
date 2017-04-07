//
//  MBMaoBaoCardViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBMaoBaoCardViewController.h"
#import "MBMaoBaoEntityCardViewController.h"
#import "MBMaoBaoElectronicCardViewController.h"
@interface MBMaoBaoCardViewController ()
{
    UIView *_lineView;
    UIButton *_lastButton;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *entityButton;
@property (weak, nonatomic) IBOutlet UIButton *electronicButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation MBMaoBaoCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    self.navBar = nil;
    self.view.backgroundColor = UIcolor(@"f3f3f3");
    [self setUpChildVcs];
    [self setUI];
}
- (void)setUpChildVcs{
    MBMaoBaoEntityCardViewController *VC1 =   [[UIStoryboard storyboardWithName:@"Shopping" bundle:nil] instantiateViewControllerWithIdentifier:@"MBMaoBaoEntityCardViewController"];
    [self addChildViewController:VC1];
    
    MBMaoBaoElectronicCardViewController *VC2 = [[UIStoryboard storyboardWithName:@"Shopping" bundle:nil] instantiateViewControllerWithIdentifier:@"MBMaoBaoElectronicCardViewController"];
    [self addChildViewController:VC2];
}
- (void)setUI{
    _lastButton = self.entityButton;
    [self.topView layoutIfNeeded];
    CGRect frame = self.entityButton.titleLabel.frame;
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, 40-1.5, frame.size.width, 1.5)];
    _lineView.backgroundColor = UIcolor(@"e8465e");
    [self.topView addSubview:_lineView];
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count * UISCREEN_WIDTH, 0);
    [self scrollViewDidEndScrollingAnimation:_scrollView];
    
}
- (IBAction)didClick:(UIButton *)sender {
    if ([_lastButton isEqual:sender]) {
        return;
    }
    
    [_lastButton setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
    [sender setTitleColor:UIcolor(@"e8465e") forState:UIControlStateNormal];
    _lastButton = sender;
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = UISCREEN_WIDTH*sender.tag;
    [self.scrollView setContentOffset:offset animated:YES];
    
    switch (sender.tag) {
        case 0:
        {
            CGRect frame = self.entityButton.titleLabel.frame;
            _lineView.mj_x = frame.origin.x;
        }
            break;
            
        default:
        {
            CGRect frame = self.electronicButton.titleLabel.frame;
            _lineView.mj_x = frame.origin.x + UISCREEN_WIDTH/2;
        }
            break;
    }
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
    switch (index) {
        case 0:
        {
            [self.electronicButton setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
            [self.entityButton setTitleColor:UIcolor(@"e8465e") forState:UIControlStateNormal];
            _lastButton = self.entityButton;
            CGRect frame = self.entityButton.titleLabel.frame;
            _lineView.mj_x = frame.origin.x;
        }
            break;
            
        default:
        {
            [self.entityButton setTitleColor:UIcolor(@"555555") forState:UIControlStateNormal];
            [self.electronicButton  setTitleColor:UIcolor(@"e8465e") forState:UIControlStateNormal];
            _lastButton = self.electronicButton;
            CGRect frame = self.electronicButton.titleLabel.frame;
            _lineView.mj_x = frame.origin.x + UISCREEN_WIDTH/2;
        }
            break;
    }
    
}

@end
