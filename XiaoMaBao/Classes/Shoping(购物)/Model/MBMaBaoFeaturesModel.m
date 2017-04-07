//
//  MBMaBaoFeaturesModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMaBaoFeaturesModel.h"

@implementation FeatureModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.ID =  dic[@"id"];
    return YES;
}
@end
@implementation MaBaoFeaturesModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.feature =  [NSArray modelDictionary:dic modelKey:@"feature" modelClassName:@"FeatureModel"];
    
    self.hot_goods = [NSArray modelDictionary:dic modelKey:@"hot_goods" modelClassName:@"GoodModel"];
    
    return YES;
}
@end
