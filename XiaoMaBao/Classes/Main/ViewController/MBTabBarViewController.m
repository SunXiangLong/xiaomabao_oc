//
//  BkTabBarViewController.m
//  背包客
//
//  Created by mac on 14-9-13.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#import "MBTabBarViewController.h"
#import "MBNavigationViewController.h"
#import "MBShoppingCartViewController.h"
#import "MBNewMyViewController.h"
#import "BkTabBarView.h"
#import "MBNewBabyController.h"
#import "MBServiceHomeViewController.h"
#import "MBNewHomeViewController.h"
#import "MBNewCanulcircleController.h"
#import "MBVideoPlaybackViewController.h"
@interface MBTabBarViewController () <BkTabBarViewDelegate>{
    NSArray* _TeMaiArarry;
   
}

@property (nonatomic, weak)BkTabBarView *customTabBar;

@end

@implementation MBTabBarViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 移除系统自动产生的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    
}
- (BkTabBarView *)customTabBar{
    if (!_customTabBar) {
        BkTabBarView *customTabBar = [[BkTabBarView alloc] initWithFrame:self.tabBar.bounds];
        customTabBar.delegate = self;
        [self.tabBar addSubview:customTabBar];
        self.customTabBar = customTabBar;
    }
    return _customTabBar;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HYTPopViewControllerNotification) name:@"HYTPopViewControllerNotification" object:nil];

    [self setupChilds];
    
}

-(void)HYTPopViewControllerNotification{
  
    
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }


}


- (void) setupChilds{
    MBNewBabyController *babyVC =   [[UIStoryboard storyboardWithName:@"LovelyBaby" bundle:nil] instantiateViewControllerWithIdentifier:@"MBNewBabyController"];
    [self setupChildVC:babyVC title:@"萌宝" imageName:@"lovyeBab_image" selectedImageName:@"loveBaby_image"];
    
    
     MBServiceHomeViewController *serviceVc =   [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:@"MBServiceHomeViewController"];
    [self setupChildVC:serviceVc title:@"服务" imageName:@"ser_image" selectedImageName:@"serSelect_image"];
    
     MBNewHomeViewController *view =   [[UIStoryboard storyboardWithName:@"Shopping" bundle:nil] instantiateViewControllerWithIdentifier:@"MBNewHomeViewController"];
    [self setupChildVC:view title:@"购物" imageName:@"icon_nav06" selectedImageName:@"icon_nav06_press"];
    
    
     MBNewCanulcircleController *shoppingCartVc =   [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"MBNewCanulcircleController"];
    [self setupChildVC:shoppingCartVc title:@"麻包圈" imageName:@"icon_nav03" selectedImageName:@"icon_nav03_press"];

    
     MBNewMyViewController *myVc =   [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBNewMyViewController"];
    [self setupChildVC:myVc title:@"个人中心" imageName:@"icon_nav05" selectedImageName:@"icon_nav05_press"];

      
   
}

- (void)setupChildVC:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    

    // 设置选中的图片
    childVc.tabBarItem.selectedImage = selectedImage;
      
    MBNavigationViewController *navVc = [[MBNavigationViewController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:navVc];
    
    // 3.往tabbar里面添加选项卡按钮
    [self.customTabBar addTabBarButton:childVc.tabBarItem];
    
}

#pragma mark -BkTabBarViewDelegate 点击控制器跳转
- (void)tabBar:(BkTabBarView *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to{
    
    self.selectedIndex = to;
    
}

@end
