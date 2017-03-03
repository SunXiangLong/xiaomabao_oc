//
//  UIButton+MBIBnspectable.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "UIButton+MBIBnspectable.h"

@implementation UIButton (MBIBnspectable)
#pragma mark - hexRgbColor
- (void)setTitleHexColor:(NSString *)titleHexColor{
    NSScanner *scanner = [NSScanner scannerWithString:titleHexColor];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return;
    [self setTitleColor:[self colorWithRGBHex:hexNum] forState:UIControlStateNormal];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


- (NSString *)titleHexColor{
    return @"0xffffff";
}

// 设置按钮和图片垂直居中
-(void)setButtonContentCenter:(CGFloat )topHeighet

{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    //设置按钮内边距
    imgViewSize = self.imageView.bounds.size;
    titleSize = self.titleLabel.bounds.size;
    btnSize = self.bounds.size;
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [self setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    [self setTitleEdgeInsets:titleEdge];
}
@end
