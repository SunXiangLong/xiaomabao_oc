//
//  UIViewController+ProgressHUD.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "UIViewController+ProgressHUD.h"
#import "MBLoginViewController.h"
@implementation UIViewController (ProgressHUD)
#pragma mark -- 跳转登陆页
- (void)loginClicksss:(NSString *)type{
    //跳转到登录页
    MBLoginViewController *myView = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = type;
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}
- (BOOL)charmResponseObject:(id)responseObject{
    
    if ([responseObject[@"status"] isKindOfClass:[NSNumber class]]&&[responseObject[@"status"] integerValue] == 0) {
        [self show:@"登录超时,请重新登录!" time:.5];
        return false ;
    }
    return true;
}
-(BOOL)checkData:(id)responseObject{

    if ([responseObject[@"status"] isKindOfClass:[NSDictionary class]]) {
        return true;
    }else if ([responseObject[@"status"] integerValue] == 0){
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时,请重新登录!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];

    }
    return false;
}
- (void)loginTimeout:(id)responseObject{
    NSString *message = @"登录超时，请重新登录";
    if ([responseObject[@"status"] integerValue] == -1) {
        message = @"未登录，请先登录";
    }
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                   
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction*loginAction = [UIAlertAction actionWithTitle:@"去登陆" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        
        [self loginClicksss:@"mabao"];
    }];
    [alerVC addAction:cancelAction];
    [alerVC addAction:loginAction];
  
    [self presentViewController:alerVC animated:YES completion:nil];
    
    
}

+(UIViewController *) findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
+(UIViewController *) currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}
- (void)show{
    
    [self showMessage:nil toView:nil delay:0];
}
- (void)dismiss{
    [self hideHUDForView:nil];

}
- (void)show:(NSString *)str toView:(UIView *)view{
    
    [self showMessage:str toView:view delay:0];
}
- (void)dismisstoView:(UIView *)view{
    [self hideHUDForView:view];
    
}
- (void)show:(NSString *)str{

    [self showMessage:str toView:nil delay:0];
}
- (void)show:(NSString *)str time:(NSInteger)timer{
    [self dismiss];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    


    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    hud.label.text = str;
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, 0.f);
    
    [hud hideAnimated:YES afterDelay:1.0f];

}
-(void)show:(NSString *)str1 and:(NSString *)str2 time:(NSInteger)timer{
    
    NSString *comment_content = [NSString stringWithFormat:@"%@ %@",str1,str2];
    NSRange range = [comment_content rangeOfString:str2];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
    [att addAttributes:@{NSForegroundColorAttributeName:UIcolor(@"d66263")}  range:NSMakeRange(range.location, range.length)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(range.location, range.length )];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    UILabel *lable =    [hud valueForKeyPath:@"label"];
    
    hud.bezelView.backgroundColor = RGBCOLOR(219, 171, 171);
    hud.mode = MBProgressHUDModeText;
    hud.label.text = comment_content;
    hud.label.textColor = UIcolor(@"575c65");
    lable.attributedText = att;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(235, 70);
    [hud hideAnimated:true afterDelay:timer];
    [self dismiss];
    
}
- (void)showProgress{
   UIView *view = [UIApplication sharedApplication].keyWindow;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.progress = self.progress;
    [hud showAnimated:true];
    
}

-(void)setProgress:(double)progress{
//    self.hud.progress = progress;
    if (progress == 1) {
        [self dismiss];
    }

}
- (void)showMessage:(NSString *)message toView:(UIView *)toview  delay:(NSTimeInterval)delay{
    UIView *view  = toview;
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    
    

    if (delay > 0){
        hud.mode = MBProgressHUDModeText;
//        hud.label.textColor = [UIColor whiteColor];
        hud.offset = CGPointMake(0.f, UISCREEN_HEIGHT/2);
        [hud hideAnimated:true afterDelay:delay];
        
    }
    if (!message) {
        hud.label.text = message;
    }
    hud.removeFromSuperViewOnHide = true;

}
- (void)hideHUDForView:(UIView *)toView{
    UIView *view = toView;
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
   
    
    [MBProgressHUD hideHUDForView:view animated:true];
    
   
}

-(void)showView:(UIView *)view{
    [self showMessage:nil toView:view delay:0];

}

-(void)dismissView:(UIView *)view{
    [self hideHUDForView:view];
}
@end
