//
//  MBEmailRegisterView.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBEmailRegisterView;
@protocol MBEmailRegisterViewDelegate <NSObject>

- (void)registerEmailNextDone:(MBEmailRegisterView *)emailRegisterView;

@end

@interface MBEmailRegisterView : UIView
@property (weak,nonatomic) id delegate;
+ (instancetype)instanceXibView;
@end
