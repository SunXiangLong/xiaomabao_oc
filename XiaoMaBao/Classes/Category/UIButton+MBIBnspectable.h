//
//  UIButton+MBIBnspectable.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface UIButton (MBIBnspectable)
// set text hex color
@property (assign,nonatomic) IBInspectable NSString *titleHexColor;

/**
 设置按钮和图片垂直居中

 @param topHeighet 图片距离top的距离
 */
-(void)setButtonContentCenter:(CGFloat )topHeighet;
@end
