//
//  MBAffordablePlanetModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TodayRecommendTopModel : NSObject
@property (nonatomic, strong) NSString * act_id;
@property (nonatomic, strong) NSURL * act_img;
@property (nonatomic, strong) NSString * ad_name;
@property (nonatomic, strong) NSString * act_name;
@property (nonatomic, strong) NSString * ad_con;
@property (nonatomic, strong) NSURL * ad_img;
@property (nonatomic, strong) NSString * ad_type;
@end
@interface GoodModel : NSObject
@property (nonatomic, strong) NSString * goods_id;
@property (nonatomic, strong) NSString * goods_name;
@property (nonatomic, strong) NSString * goods_price;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSURL    * goods_thumb;

@end
@interface TodayRecommendBotModel : NSObject
@property (nonatomic, strong) NSString * act_id;
@property (nonatomic, strong) NSURL * act_img;
@property (nonatomic, strong) NSString * act_name;
@property (nonatomic, strong) NSURL * ad_img;
@property (nonatomic, strong) NSString * ad_name;
@property (nonatomic, strong) NSString * ad_type;
@property (nonatomic, strong) NSArray <GoodModel *> * goods;
@end

@interface CategoryModel : NSObject
@property (nonatomic, strong) NSString * cat_id;
@property (nonatomic, strong) NSString * cat_name;
@property (nonatomic, strong) NSURL * icon;
@end

@interface AffordablePlanetModel : NSObject
@property (nonatomic, strong) NSArray<TodayRecommendTopModel *> *today_recommend_top;

@property (nonatomic, strong) NSArray<TodayRecommendBotModel *> *today_recommend_bot;

@property (nonatomic, strong) NSArray<CategoryModel *> *category;

@end
