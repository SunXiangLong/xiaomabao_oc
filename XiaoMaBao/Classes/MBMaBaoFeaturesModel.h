//
//  MBMaBaoFeaturesModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBAffordablePlanetModel.h"

@interface FeatureModel : NSObject
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSURL * img;
@end

@interface MaBaoFeaturesModel : NSObject
@property (nonatomic, strong) NSArray<FeatureModel *> *feature;
@property (nonatomic, strong) NSArray<GoodModel *> *hot_goods;
@end
