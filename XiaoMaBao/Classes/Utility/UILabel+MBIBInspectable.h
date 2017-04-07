//
//  UILabel+MBIBInspectable.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MBIBInspectable)
/**
 *  给storyboard里lable扩展字符串设置颜色（16进制数）
 */
@property (assign,nonatomic) IBInspectable NSString *textHexColor;
/**
 *  给storyboard里lable扩展字间距
 */
@property (nonatomic, assign)IBInspectable CGFloat columnSpace;
/**
 *  给storyboard里lable扩展行距
 */
@property (nonatomic, assign)IBInspectable CGFloat rowspace;

/**
 *  设置字间距
 */
- (void)columnSpace:(CGFloat)columnSpace;
/**
 *  设置行距
 */
- (void)rowSpace:(CGFloat)rowSpace;

@end
