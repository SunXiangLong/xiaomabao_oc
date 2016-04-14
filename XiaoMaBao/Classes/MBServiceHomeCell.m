//
//  MBServiceHomeCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceHomeCell.h"

@implementation MBServiceHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.user_image .contentMode =  UIViewContentModeScaleAspectFill;
    self.user_image .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.user_image .clipsToBounds  = YES;
    
    self.user_city .contentMode =  UIViewContentModeScaleAspectFill;
    self.user_city .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.user_city .clipsToBounds  = YES;
    
    self.user_adressImage .contentMode =  UIViewContentModeScaleAspectFill;
    self.user_adressImage .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.user_adressImage .clipsToBounds  = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
