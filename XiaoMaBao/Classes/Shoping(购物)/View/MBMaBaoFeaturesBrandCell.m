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
    
}
-(void)setImgUrl:(NSURL *)imgUrl{
    [_img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder_num4"]];
}
@end
