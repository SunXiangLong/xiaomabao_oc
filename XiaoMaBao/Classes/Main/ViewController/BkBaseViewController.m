//
//  BkBaseViewController.m
//  背包客
//
//  Created by mac on 14-9-10.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#import "BkBaseViewController.h"


@interface BkBaseViewController () <BkNavigationBarViewDelegate>
{
    UIWebView *webview;
    MBProgressHUD *HUD;
}
//@property (nonatomic,weak) BkNavigationBarView *navBar;

@end

@implementation BkBaseViewController

- (BkNavigationBarView *)navBar{
    if (!_navBar) {
        // 自定义导航栏
        BkNavigationBarView *navBar = [BkNavigationBarView navigationBarView];
        navBar.backgroundColor = NavBar_Color;
        navBar.delegate = self;
        navBar.title = self.titleStr;
        navBar.rightStr = self.rightStr;
        navBar.leftStr = self.leftStr;
        navBar.leftImage = self.leftImage;
        navBar.leftButtonW = self.leftButtonW;
        
        
        if([self.rightStr isEqualToString:@"消息"]){
            if(self.messageBadge == nil){
                
                self.messageBadge = [CustomBadge customBadgeWithString:@"0" withStyle:[BadgeStyle defaultStyle]];
                self.messageBadge.hidden = YES;
                self.messageBadge.frame = CGRectMake(35, 5, self.messageBadge.ml_width, self.messageBadge.ml_height);
                [navBar.rightButton addSubview:self.messageBadge];
            }
        }
        if (self.leftImage.length) {
            [navBar.leftButton setImage:[UIImage imageNamed:self.leftImage] forState:UIControlStateNormal];
           
        }
        if (self.titleImage.length) {
            [navBar.titleButton setImage:[UIImage imageNamed:self.titleImage] forState:UIControlStateNormal];
            
        }
        if (self.rightImage.length) {
            [navBar.rightButton setImage:[UIImage imageNamed:self.rightImage] forState:UIControlStateNormal];
        
            if([self.rightImage isEqualToString:@"shoppingCart"]){
                if(self.badge == nil){
                    self.badge = [CustomBadge customBadgeWithString:@"0" withStyle:[BadgeStyle defaultStyle]];
                    self.badge.hidden = YES;
                    [navBar setButtonBadge:self.badge];
                }
                
            }
        }
        [self.view insertSubview:navBar atIndex:0];
        self.navBar = navBar;
    }
    return _navBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_COLOR;
    [self.navigationController.navigationBar removeFromSuperview];
 self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 导航栏点击事件
    [self setupClickEvent];
    
    
    self.navBar.back = self.back;
    
    

    
    
}

- (void) setupClickEvent{
    // 导航栏点击事件
    [self.navBar.leftButton addTarget:self action:@selector(leftTitleClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.rightButton addTarget:self action:@selector(rightTitleClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.titleButton addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)addBottomLineView:(UIView *)addLineView{
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.tag = 1111111;
    lineView.frame = CGRectMake(0,addLineView.ml_height - PX_ONE, [UIScreen mainScreen].bounds.size.width, PX_ONE);
    lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    [addLineView addSubview:lineView];
    return lineView;
}

- (UIView *)addTopLineView:(UIView *)addLineView{
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.tag = 2222222;
    lineView.frame = CGRectMake(0, PX_ONE, [UIScreen mainScreen].bounds.size.width, PX_ONE);
    lineView.backgroundColor = [UIColor colorWithHexString:@"dfe1e9"];
    [addLineView addSubview:lineView];
    return lineView;
}

- (void)navigationBarViewPopController:(BkNavigationBarView *)navigationBarView{
    [self popViewControllerAnimated:YES];
}

- (void)setNavBarViewBackgroundColor:(UIColor *)color{
    [self.navBar setBackgroundColor:color];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    
    return [self.navigationController popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *) viewController Animated:(BOOL)animated{
   
    
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)leftTitleClick{
    
}

- (void)rightTitleClick{
    
}

- (void) titleClick{
    
}

- (NSString *)rightImage{
    return nil;
}

- (NSString *)titleImage{
    return nil;
}

- (NSString *)leftImage{
    return nil;
}

- (NSString *)rightStr{
    return nil;
}

- (NSString *)leftStr{
    return nil;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    
    self.navBar.title = titleStr;
}
- (void)setStateStr:(NSString *)stateStr{
    _stateStr =stateStr;
    UILabel *lable = [[UILabel alloc] init];
    lable.textAlignment = 1;
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = [UIColor colorR:146 colorG:147 colorB:148];
    lable.text = stateStr;
    [self.view addSubview:lable];
    
[lable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.view.mas_centerX);
    make.centerY.mas_equalTo(self.view.mas_centerY);
}];

}
- (CGFloat)leftButtonW{
    return 0;
}

- (BOOL)isLogin{
    MBUserDataSingalTon *user = [MBSignaltonTool getCurrentUserInfo];
    if (user.uid == nil || user.sid == nil) {
        return NO;
    }
    return YES;
}
- (BOOL)isSearch{
    return NO;
}
-(CGFloat)screenWidth{
    return [UIScreen mainScreen].applicationFrame.size.width ;
}
-(CGFloat)screenHeight{
    return [UIScreen mainScreen].applicationFrame.size.height ;
}
-(void)show{
	
 
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD show:YES];
}
-(void)show:(NSString *)str{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = str;
    [HUD show:YES];

}

-(void)show:(NSString *)str time:(NSInteger)timer{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:timer];
    [self dismiss];

}
- ( void)showProgress{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"上传中...";
//    hud.backgroundColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.progress = self.progress;
    [HUD = hud show:YES];
    

}
-(void)setProgress:(float)progress{
    _progress = progress;
    HUD.progress = progress;
    if (progress==1) {
        [self dismiss];
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"上传成功";
        HUD = hud;
        
       
    }

}
-(void)dismiss{
    
    [HUD  removeFromSuperview];
    HUD = nil;
}


@end
