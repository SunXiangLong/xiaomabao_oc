//
//  MBMBAffordablePlanetOneChildeOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMBAffordablePlanetOneChildeOneCell.h"

@implementation MBMBAffordablePlanetOneChildeOneCell
@dynamic currentIndexPath;

- (NSIndexPath *)currentIndexPath {
    NSIndexPath *indexPath = objc_getAssociatedObject(self, @selector(currentIndexPath));
    return indexPath;
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    objc_setAssociatedObject(self, @selector(currentIndexPath), currentIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.showImageView .contentMode =  UIViewContentModeScaleAspectFill;
    self.showImageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.showImageView .clipsToBounds  = YES;
}

@end
