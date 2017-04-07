//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  xiaomabao
//
//  Created by 张磊 on 15/4/28.
//  Copyright (c) 2015年 com.xiaomabao.www. All rights reserved.
//

#import "MBNavigationViewController.h"
#import "BkBaseViewController.h"
#import "BkNavigationBarView.h"
#import "MBOrderInfoTableViewController.h"
#import "MBNewMyViewController.h"
#define BG_IMAGEVIEW_X -[[UIScreen mainScreen] bounds].size.width/2


@interface MBNavigationViewController ()<UIGestureRecognizerDelegate>


@end

@implementation MBNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pan = [[UIPanGestureRecognizer alloc] init];
    //  用KVC取出target和action
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    self.pan .delegate = self;
    [self.pan  addTarget:internalTarget action:internalAction];
    self.interactivePopGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer: self.pan];
        
    
    
}


#pragma mark - UIGestureRecognizerDelegate方法
// 是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    // 根控制器下不要触发手势,让手势不起作用
    return self.childViewControllers.count > 1 ;
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    //  向左边(反方向)拖动，手势不执行。
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return YES;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [viewController.navigationController.navigationBar removeFromSuperview];
    
    if (self.viewControllers.count > 0) {
        MMLog(@"%@",self.viewControllers);
        /**
         *  pus到新的界面 隐藏底部的tabbar
         */
        
       
        viewController.hidesBottomBarWhenPushed = YES;
        if ([viewController isKindOfClass:[BkBaseViewController class] ]) {
            BkBaseViewController *vc = (BkBaseViewController *) viewController;
            vc.back = YES;

        }
    }
    [super pushViewController:viewController animated:animated];
    
}




@end
