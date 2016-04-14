//
//  UIColor+Extension.h
//  背包客
//
//  Created by mac on 14-10-12.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
/**
 *  十六进制颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
/**
 *  随机色
 */
+ (UIColor *)randomColor;
+ (UIColor *)colorR:(CGFloat) r  colorG:(CGFloat) g colorB:(CGFloat) b;


@end
