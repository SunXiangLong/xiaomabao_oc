//
//  MBAffordablePlanetTwoChildOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetTwoChildOneCell.h"

@implementation MBAffordablePlanetTwoChildOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showImageView .contentMode =  UIViewContentModeScaleAspectFill;
    self.showImageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.showImageView .clipsToBounds  = YES;}

@end
