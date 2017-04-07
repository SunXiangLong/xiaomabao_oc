//
//  MBServiceModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBServiceModel.h"

@implementation MBServiceModel
-(NSMutableArray<ServiceShopModel *> *)shopsArray{
    if (!_shopsArray) {
        _shopsArray = [NSMutableArray array];
    }
    return _shopsArray;
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    [self.shopsArray  addObjectsFromArray:[NSArray modelDictionary:dic modelKey:@"shops" modelClassName:@"ServiceShopModel"]];
    self.categoryArray = [NSArray modelDictionary:dic modelKey:@"category" modelClassName:@"ServiceCategoryModel"];
    return YES;
}
@end
@implementation ServiceProductsModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}
@end
@implementation ServiceCategoryModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}
@end
@implementation ServiceShopModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.productArray = [NSArray modelDictionary:dic modelKey:@"products" modelClassName:@"ServiceProductsModel"];
    self.isMoreService = false;
    return YES;
}
@end
