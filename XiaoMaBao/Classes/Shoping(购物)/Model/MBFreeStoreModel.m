//
//  MBFreeStoreModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBFreeStoreModel.h"

@implementation FreeStoreModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.today_recommend_top =  [NSArray modelDictionary:dic modelKey:@"today_recommend_top" modelClassName:@"TodayRecommendTopModel"];
    
    self.today_recommend_bot = [NSArray modelDictionary:dic modelKey:@"today_recommend_bot" modelClassName:@"TodayRecommendBotModel"];
    self.category = [NSArray modelDictionary:dic modelKey:@"category" modelClassName:@"CountriesCategoryModel"];
    self.recommend_goods = [NSArray modelDictionary:dic modelKey:@"recommend_goods" modelClassName:@"GoodModel"];
    return YES;
}
@end


@implementation CountriesCategoryModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{

    
    return YES;

}
@end
