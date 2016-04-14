//
//  BkTabBarButton.m
//  背包客
//
//  Created by mac on 14-9-13.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#define kRadio 0.7

#import "BkTabBarButton.h"

@interface BkTabBarButton ()

@end

@implementation BkTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{}

// 赋值
- (void)setItem:(UITabBarItem *)item{
    _item = item;
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleW = self.ml_width;
    CGFloat titleY = self.ml_height * kRadio * 0.7 + MARGIN_5;
    CGFloat titleH = self.ml_height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW =self.num==25?self.num:20;
    CGFloat imageX = (self.ml_width - imageW) * 0.5;
    CGFloat imageH =self.num==25?self.num:20;
    CGFloat imageY = (self.ml_height - imageH) * kRadio * 0.5;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
@end
