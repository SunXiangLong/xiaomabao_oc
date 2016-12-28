//
//  MBOrderModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBOrderModel.h"
@implementation MBGoodListModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}
@end
@implementation MBChildOrderModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.goodsList = [NSArray modelDictionary:dic modelKey:@"goods_list" modelClassName:@"MBGoodListModel"];
    return YES;
}
@end
@implementation MBOrderModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    self.goodsList = [NSArray modelDictionary:dic modelKey:@"goods_list" modelClassName:@"MBGoodListModel"];
    self.childOrders = [NSArray modelDictionary:dic modelKey:@"child_orders" modelClassName:@"MBChildOrderModel"];
    return YES;
}
@end
