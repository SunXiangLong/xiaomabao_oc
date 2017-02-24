//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  UIView+Extension.m
//
//  Created by 张磊 on 14-11-14.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "UIView+MLExtension.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (Extension)

- (void)setMl_x:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)ml_x{
    return self.frame.origin.x;
}
- (void)setMl_y:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)ml_y{
    return self.frame.origin.y;
}
- (void)setMl_centerX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)ml_centerX{
    return self.center.x;
}

- (void)setMl_centerY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)ml_centerY{
    return self.center.y;
}

- (void)setMl_width:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)ml_width{
    return self.frame.size.width;
}

- (void)setMl_height:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)ml_height{
    return self.frame.size.height;
}


- (void)setMl_size:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)ml_size{
    return self.frame.size;
}
-(void)removeAllSubviews{
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}
- (void)bezierPathWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGFloat )cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds      byRoundingCorners:corners    cornerRadii:CGSizeMake(corners, corners)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
