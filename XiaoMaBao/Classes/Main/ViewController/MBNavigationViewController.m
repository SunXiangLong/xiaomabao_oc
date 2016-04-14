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
#define BG_IMAGEVIEW_X -[[UIScreen mainScreen] bounds].size.width/2


@interface MBNavigationViewController ()<UIGestureRecognizerDelegate>


@end

@implementation MBNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (iOS_7) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        //  用KVC取出target和action
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        pan.delegate = self;
        [pan addTarget:internalTarget action:internalAction];
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.view addGestureRecognizer:pan];

    }
    
}
#pragma mark - UIGestureRecognizerDelegate方法
// 是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 根控制器下不要触发手势,让手势不起作用
    return self.childViewControllers.count > 1 ;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [viewController.navigationController.navigationBar removeFromSuperview];
    [super pushViewController:viewController animated:animated];
    [self setupRightBackAction:viewController];
    self.tabBarController.tabBar.hidden = [[self childViewControllers] indexOfObject:viewController];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    [self setupRightBackAction:viewControllerToPresent];
}

#pragma mark 初始化这边返回方法
- (void) setupRightBackAction:(UIViewController *)viewControllerToPresent{
    BkBaseViewController *vc = (BkBaseViewController *) viewControllerToPresent;
    NSUInteger index = [[self childViewControllers] indexOfObject:vc];
    if ([viewControllerToPresent isKindOfClass:[BkBaseViewController class]] && index >= 1) {
        vc.back = YES;
        viewControllerToPresent = vc;
    }
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
      self.tabBarController.tabBar.hidden = [[self childViewControllers] indexOfObject:vc];
    if(vc){
        if ([[self.view.subviews lastObject] isKindOfClass:[BkNavigationBarView class]]) {
            [[self.view.subviews lastObject] removeFromSuperview];
        }
       self.tabBarController.tabBar.hidden = [[self childViewControllers] count] > 1;

    }
   
    
    return vc;
}
-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
     NSArray *arr =   [super popToViewController:viewController animated:animated];
    if(viewController){
        if ([[self.view.subviews lastObject] isKindOfClass:[BkNavigationBarView class]]) {
            [[self.view.subviews lastObject] removeFromSuperview];
        }
    }
    self.tabBarController.tabBar.hidden = [[self childViewControllers] count] > 1;
    return arr;

}
@end
