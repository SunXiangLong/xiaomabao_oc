//
//  MBAlertView.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBAlertHUD.h"

@implementation MBAlertHUD

+ (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<MBAlertHUDDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{
    MBAlertHUD *alertView = [[MBAlertHUD alloc] init];
    alertView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    alertView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
    
    UILabel *alertTitleLabel = [[UILabel alloc] init];
    alertTitleLabel.text = title;
    [alertView addSubview:alertTitleLabel];
    
    [UIView animateWithDuration:.5 animations:^{

    } completion:^(BOOL finished) {
        
    }];
    
    return alertView;
}

@end
