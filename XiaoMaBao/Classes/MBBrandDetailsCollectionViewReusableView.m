//
//  MBBrandDetailsCollectionViewReusableView.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBrandDetailsCollectionViewReusableView.h"

@implementation MBBrandDetailsCollectionViewReusableView
-(void)awakeFromNib{
    [super awakeFromNib];
    
    _brand_logo.contentMode =  UIViewContentModeScaleAspectFill;
    _brand_logo.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _brand_logo.clipsToBounds  = YES;
}
-(void)setDataDic:(NSDictionary *)dataDic{
    [_brand_logo sd_setImageWithURL:URL(dataDic[@"brand_logo"]) placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    _brand_name.text = dataDic[@"brand_name"];
    _brand_desc.text = dataDic[@"brand_desc"];
    
    [_brand_desc rowSpace:2];
    
}
@end
