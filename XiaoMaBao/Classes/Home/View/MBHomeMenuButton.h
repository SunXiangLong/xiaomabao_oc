//
//  MBHomeMenuButton.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/17.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBHomeMenuButton : UIButton

/**
 *  当前选中这个按钮, 默认false
 */
@property (assign,nonatomic,getter=isCurrentSelectedStatus) BOOL currentSelectedStatus;
@property (weak,nonatomic) UIView *lineView;

@end
