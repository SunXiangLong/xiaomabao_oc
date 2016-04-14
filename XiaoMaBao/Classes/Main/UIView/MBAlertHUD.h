//
//  MBAlertView.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBAlertHUDDelegate <NSObject>
@optional
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface MBAlertHUD : UIView
+ (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<MBAlertHUDDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;
@end
