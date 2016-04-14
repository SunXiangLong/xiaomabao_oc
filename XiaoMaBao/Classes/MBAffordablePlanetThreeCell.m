//
//  MBAffordablePlanetThreeCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetThreeCell.h"

@implementation MBAffordablePlanetThreeCell

- (void)awakeFromNib {
    self.showImageVIew .contentMode =  UIViewContentModeScaleAspectFill;
    self.showImageVIew .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.showImageVIew .clipsToBounds  = YES;
}

@end
