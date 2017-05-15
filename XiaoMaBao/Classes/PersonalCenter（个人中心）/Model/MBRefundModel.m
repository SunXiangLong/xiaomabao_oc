//
//  MBRefundModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/27.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBRefundModel.h"

@implementation MBRefundModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.goodsDetail  = [NSArray modelDictionary:dic modelKey:@"goods_detail" modelClassName:@"MBRefundGoodsModel"];
    return YES;
}
@end


@implementation MBRefundGoodsModel : NSObject
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}
@end
