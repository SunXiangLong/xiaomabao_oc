//
//  MBBrandDetailModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBAffordablePlanetModel.h"

@interface BrandModel : NSObject
@property (nonatomic, strong) NSString * brand_name;
@property (nonatomic, strong) NSString * brand_desc;
@property (nonatomic, strong) NSURL * brand_logo;
@end
@interface BrandDetailModel : NSObject
@property (nonatomic, strong) BrandModel *brand;
@property (nonatomic, strong) NSMutableArray<GoodModel *> *goodsList;

@end
