//
//  UIViewController+ProgressHUD.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ProgressHUD)
//HUD提示
-(void)show;
-(void)showView:(UIView *)view;
-(void)showProgress;
-(void)show:(NSString *)str;
-(void)show:(NSString *)str time:(NSInteger)timer;
-(void)show:(NSString *)str1 and:(NSString *)str2 time:(NSInteger)timer;
-(void)dismiss;
-(void)dismissView:(UIView *)view;
- (void)loginClicksss:(NSString *)type;
//@property (nonatomic,assign) double progress;
- (void)loginTimeout:(id)responseObject;
@end
