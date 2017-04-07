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
- (void)show:(NSString *)str toView:(UIView *)view;
- (void)dismisstoView:(UIView *)view;
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

/**
 校对接口返回的数据（有可能停留莫界面长时间未操作，导致sid 失效，返回登录超时）

 @param responseObject 接口返回的数据
 */
- (BOOL)checkData:(id)responseObject;
- (BOOL)charmResponseObject:(id)responseObject;
/**
 获取当前视图上的视图控制器。

 @return VC
 */
+(UIViewController*) currentViewController;
@end
