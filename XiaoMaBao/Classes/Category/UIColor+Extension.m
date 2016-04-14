//
//  UIColor+Extension.m
//  背包客
//
//  Created by mac on 14-10-12.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (UIColor *)randomColor {
    return  [UIColor colorWithRed:arc4random_uniform(256)/(CGFloat)255.0
                            green:arc4random_uniform(256)/(CGFloat)255.0
                             blue:arc4random_uniform(256)/(CGFloat)255.0
                            alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum];
}


+ (UIColor *)colorR:(CGFloat) r colorG:(CGFloat) g colorB:(CGFloat) b {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
@end
