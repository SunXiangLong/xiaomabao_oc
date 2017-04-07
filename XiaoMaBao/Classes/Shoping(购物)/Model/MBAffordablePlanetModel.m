//
//  MBAffordablePlanetModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetModel.h"

@implementation AffordablePlanetModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.today_recommend_top =  [NSArray modelDictionary:dic modelKey:@"today_recommend_top" modelClassName:@"TodayRecommendTopModel"];
   
    self.today_recommend_bot = [NSArray modelDictionary:dic modelKey:@"today_recommend_bot" modelClassName:@"TodayRecommendBotModel"];
    self.category = [NSArray modelDictionary:dic modelKey:@"category" modelClassName:@"CategoryModel"];
    return YES;
}
@end
@implementation TodayRecommendBotModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    self.goods = [NSArray modelDictionary:dic modelKey:@"goods" modelClassName:@"GoodModel"];
    return YES;
}

@end
@implementation TodayRecommendTopModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}

@end
@implementation GoodModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}

@end
@implementation CategoryModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}

@end
