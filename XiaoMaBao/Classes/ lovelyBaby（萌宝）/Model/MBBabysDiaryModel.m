//
//  MBBabysDiaryModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/8.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBBabysDiaryModel.h"

@implementation MBBabysDiaryModel


@end

@implementation Data

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"result" : [Result class]};
}


@end


@implementation Result



- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    _ID = dic[@"id"];

    return true;
}
@end



