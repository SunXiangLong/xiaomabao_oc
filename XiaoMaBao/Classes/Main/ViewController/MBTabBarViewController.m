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
#import "MBBabyViewController.h"
#import "MBServiceHomeViewController.h"
#import "MBNewHomeViewController.h"
#import "MBNewCanulcircleController.h"
@interface MBTabBarViewController () <BkTabBarViewDelegate>{
    NSArray* _TeMaiArarry;
    NSMutableArray* menuIds ;
}

@property (nonatomic, weak)BkTabBarView *customTabBar;

@end

@implementation MBTabBarViewController

- (BkTabBarView *)customTabBar{
    if (!_customTabBar) {
        BkTabBarView *customTabBar = [[BkTabBarView alloc] initWithFrame:self.tabBar.bounds];
        customTabBar.delegate = self;
        [self.tabBar addSubview:customTabBar];
        self.customTabBar = customTabBar;
    }
    return _customTabBar;
}

#pragma mark - 获取item菜单
-(void)getMenuItem:(NSString *)menu_type
{
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getFavourableMenu"] parameters:@{@"menu_type":menu_type} success:^(NSURLSessionDataTask *operation, id responseObject) {
        _TeMaiArarry = [responseObject valueForKeyPath:@"data"];
        
      
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HYTPopViewControllerNotification) name:@"HYTPopViewControllerNotification" object:nil];

          [self setupChilds];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 移除系统自动产生的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    
}
-(void)HYTPopViewControllerNotification{
  
    
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }



}


- (void) setupChilds{
    
    MBBabyViewController *babyVC = [[MBBabyViewController alloc] init];
    [self setupChildVC:babyVC title:@"萌宝" imageName:@"lovyeBab_image" selectedImageName:@"loveBaby_image"];

   
   
    
    
    
    menuIds =[NSMutableArray arrayWithCapacity:_TeMaiArarry.count];
    
    for (NSDictionary* dic in _TeMaiArarry) {
        [menuIds addObject:dic[@"menu_id"]];
    }
   

  
    
    MBServiceHomeViewController *serviceVc = [[MBServiceHomeViewController alloc] init];
    [self setupChildVC:serviceVc title:@"服务" imageName:@"ser_image" selectedImageName:@"serSelect_image"];
    
    
    MBNewHomeViewController *view = [[MBNewHomeViewController alloc] init];
    [self setupChildVC:view title:@"购物" imageName:@"icon_nav06" selectedImageName:@"icon_nav06_press"];

    MBNewCanulcircleController *shoppingCartVc = [[MBNewCanulcircleController alloc] init];
    [self setupChildVC:shoppingCartVc title:@"麻包圈" imageName:@"icon_nav03" selectedImageName:@"icon_nav03_press"];


    MBNewMyViewController *myVc = [[MBNewMyViewController alloc] init];
    [self setupChildVC:myVc title:@"个人中心" imageName:@"icon_nav05" selectedImageName:@"icon_nav05_press"];

      
   
}

- (void)setupChildVC:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS_7) { // 如果是iOS7, 不需要渲染图片
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    // 设置选中的图片
    childVc.tabBarItem.selectedImage = selectedImage;
      
    MBNavigationViewController *navVc = [[MBNavigationViewController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:navVc];
    
    // 3.往tabbar里面添加选项卡按钮
    [self.customTabBar addTabBarButton:childVc.tabBarItem];
    
}

#pragma mark -BkTabBarViewDelegate 点击控制器跳转
- (void)tabBar:(BkTabBarView *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to{
   
    
    if (to == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postMenuIds" object:menuIds];
    }
    self.selectedIndex = to;
    
}

@end
