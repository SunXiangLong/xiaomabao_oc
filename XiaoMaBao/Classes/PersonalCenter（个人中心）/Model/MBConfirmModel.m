//
//  MBConfirmModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBConfirmModel.h"

@implementation MBConfirmModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    
    NSArray *keyArray = [dic[@"s_goods_list"] allKeys];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in keyArray) {
        
        [arr addObject: [MBOrderShopModel yy_modelWithDictionary:dic[@"s_goods_list"][key]]];
    }
    self.goods_list = [arr copy];
    return YES;
}
@end
@implementation MBConsigneeModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}
@end
@implementation MBOrderShopModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.goods_list = [NSArray modelDictionary:dic modelKey:@"goods_list" modelClassName:@"MBGood_ListModel"];
    return YES;
}
@end
@implementation MBIdcardModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}
@end
