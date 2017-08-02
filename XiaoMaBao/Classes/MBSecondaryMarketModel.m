//
//  MBSecondaryMarketModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSecondaryMarketModel.h"

@implementation MBSecondaryMarketModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"today_recommend_top" : [todayRecommendTopModel class], @"goods_list" : [secondaryMarketGoodsListModel class]};
}


@end

@implementation todayRecommendTopModel


@end


@implementation secondaryMarketGoodsListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"gallery" : [galleryModel class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation uinfoModel


@end


@implementation galleryModel


@end
