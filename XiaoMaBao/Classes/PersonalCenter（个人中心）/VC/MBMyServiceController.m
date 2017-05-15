//
//  MBMyServiceController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyServiceController.h"
#import "MBMyServiceChilderViewController.h"
@interface MBMyServiceController (){

    UIButton *_lastButton;
    NSArray *_titleButtons;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *Topayment;
@property (weak, nonatomic) IBOutlet UIButton *Toused;
@property (weak, nonatomic) IBOutlet UIButton *Toevaluate;
@property (weak, nonatomic) IBOutlet UIButton *ToafterSales;

@end

@implementation MBMyServiceController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildVcs];
    _lastButton = _Topayment;
    _lastButton.selected = YES;
    [_lastButton setTitleColor:[UIColor colorWithHexString:@"729481"]forState:UIControlStateNormal];
  
    _titleButtons = @[_Topayment,_Toused,_Toevaluate,_ToafterSales];
}
- (void)setupChildVcs{
    
    for (NSInteger i=0; i<4; i++) {
        
        MBMyServiceChilderViewController *VC = [[UIStoryboard  storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBMyServiceChilderViewController"];
      
        
        switch (i) {
            case 0:   VC.type = Topayment;     VC.strType = @"await_pay";  break;
            case 1:   VC.type = Toused;        VC.strType = @"await_use"; break;
            case 2:   VC.type = Toevaluate;    VC.strType = @"await_comment"; break;
            default:  VC.type = ToafterSales;  VC.strType = @"after_sales"; break;
        }
        [self addChildViewController:VC];
        
    }
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.childViewControllers.count * UISCREEN_WIDTH, 0);
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = UISCREEN_WIDTH *_page;
    [_scrollView setContentOffset:offset animated:false];
    [self scrollViewDidEndScrollingAnimation:_scrollView];
}
- (IBAction)clickButton:(UIButton *)sender {
//    MMLog(@"%ld",sender.tag);
    if (![sender isEqual:_lastButton]) {
       sender.selected = _lastButton.selected;
        [_lastButton setTitleColor:[UIColor colorWithHexString:@"606060"]forState:UIControlStateNormal];
        _lastButton.selected = NO;
        _lastButton = sender;
        [_lastButton setTitleColor:[UIColor colorWithHexString:@"729481"]forState:UIControlStateNormal];
        // 让scrollView滚动到对应的位置
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = UISCREEN_WIDTH * [_titleButtons indexOfObject:sender];
        [self.scrollView setContentOffset:offset animated:YES];
    }
    
}

-(NSString *)titleStr{
return @"我的服务";
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
    int index = scrollView.contentOffset.x / UISCREEN_WIDTH;
    switch (index) {
        case 0:[MobClick event:@"ServiceOrder0"]; break;
        case 1:[MobClick event:@"ServiceOrder1"]; break;
        case 2:[MobClick event:@"ServiceOrder2"]; break;
        case 3:[MobClick event:@"ServiceOrder3"]; break;
        default:break;
    }
    MBMyServiceChilderViewController *willShowChildVc = self.childViewControllers[index];
    
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
    int index = scrollView.contentOffset.x /UISCREEN_WIDTH;
    [self clickButton:_titleButtons[index]];
}


@end
