//
//  MBSMCategoryModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSMCategoryModel.h"

@implementation MBSMCategoryDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [MBSMCategoryModel class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
   [self yy_modelEncodeWithCoder:aCoder];
}
// 反归档方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
   return [self yy_modelInitWithCoder:aDecoder];
}
@end

@implementation MBSMCategoryModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"cat_lists" : [catListsModel class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}
// 反归档方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
@end


@implementation catListsModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}
// 反归档方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
@end



