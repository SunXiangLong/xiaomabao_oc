//
//  MBBrandDetailModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBrandDetailModel.h"

@implementation BrandDetailModel
-(NSMutableArray<GoodModel *> *)goodsList{
    if (!_goodsList) {
        _goodsList = [NSMutableArray   array];
    }
    return _goodsList;
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    [self.goodsList  addObjectsFromArray: [NSArray modelDictionary:dic modelKey:@"goods_list" modelClassName:@"GoodModel"]];
    return YES;
}
@end
@implementation BrandModel

@end
