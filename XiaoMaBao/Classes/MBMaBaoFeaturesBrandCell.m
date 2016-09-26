//
//  MBMaBaoFeaturesBrandCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMaBaoFeaturesBrandCell.h"

@implementation MBMaBaoFeaturesBrandCell
-(void)awakeFromNib{
    [super awakeFromNib];
    _img.contentMode =  UIViewContentModeScaleAspectFill;
    _img.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _img.clipsToBounds  = YES;
}
-(void)setImgUrl:(NSString *)imgUrl{
    [_img sd_setImageWithURL:URL(imgUrl) placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
}
@end
