//
//  MBFreeStoreModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBAffordablePlanetModel.h"
@interface CountriesCategoryModel : NSObject
@property (nonatomic, strong) NSString * c_id;
@property (nonatomic, strong) NSString * c_name;
@property (nonatomic, strong) NSURL * c_img;
@end
@interface FreeStoreModel : NSObject
@property (nonatomic, strong) NSArray<TodayRecommendTopModel *> *today_recommend_top;
@property (nonatomic, strong) NSArray<TodayRecommendBotModel *> *today_recommend_bot;
@property (nonatomic, strong) NSArray<CountriesCategoryModel *> *category;
@property (nonatomic, strong) NSArray <GoodModel *> * recommend_goods;
@end
