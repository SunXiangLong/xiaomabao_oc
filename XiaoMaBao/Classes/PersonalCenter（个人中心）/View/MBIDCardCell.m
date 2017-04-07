//
//  MBIDCardCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBIDCardCell.h"

@implementation MBIDCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cardImage .contentMode =  UIViewContentModeScaleAspectFill;
    self.cardImage .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.cardImage .clipsToBounds  = YES;
}

@end
