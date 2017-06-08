//
//  MBLovelyBabyModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/7.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBLovelyBabyModel.h"
@implementation MBMyToolModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"toolkit_detail" : [MBToolkitDetailModel class]};
}
@end

@implementation MBToolkitDetailModel

@end
@implementation MBLovelyBabyModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
   
    
    return @{@"recommend_goods" : [MBRecommend_goodsModel class], @"recommend_topics" : [MBRecommendTopicsModel class], @"recommend_posts" : [MBRecommendPostsModel class],@"remind" : [MBRemindModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
   
    if ([dic[@"type"] isEqualToString:@"pregnant"] ) {
        _stateBabyType = isPregnantBaby;
    }else if ([dic[@"type"] isEqualToString:@"prepare_pregnant"]){
        _stateBabyType = readyToPregnantBaby;
        
    }else if ([dic[@"type"] isEqualToString:@"born"]){
        _stateBabyType = theBabyIsBorn;
    }
    _currentDate = [dic[@"current_date"] stringConversionDate];
    _startDate = [dic[@"start_date"] stringConversionDate];
    _endDate = [dic[@"end_date"] stringConversionDate];
    
    self.day_info.stateBabyType = self.stateBabyType;
    
    return YES;
}
@end

@implementation MBDayInfoModel


@end


@implementation MBRecommendPostsModel


@end

@implementation MBRemindModel


@end
@implementation MBRecommendTopicsModel


@end


@implementation MBRecommend_goodsModel


@end

