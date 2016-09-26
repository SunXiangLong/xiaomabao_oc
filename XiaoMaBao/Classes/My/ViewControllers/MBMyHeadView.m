//
//  MBMyHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyHeadView.h"

@implementation MBMyHeadView

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBMyHeadView" owner:nil options:nil] lastObject];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.back_image .contentMode =  UIViewContentModeScaleAspectFill;
    self.back_image .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.back_image .clipsToBounds  = YES;
}

@end
