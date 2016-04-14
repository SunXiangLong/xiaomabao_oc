//
//  MBServiceShopsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceShopsOneCell.h"

@implementation MBServiceShopsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showImageViw .contentMode =  UIViewContentModeScaleAspectFill;
    self.showImageViw .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.showImageViw .clipsToBounds  = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
