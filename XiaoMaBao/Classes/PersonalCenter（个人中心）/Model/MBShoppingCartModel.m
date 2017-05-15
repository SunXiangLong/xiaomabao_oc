//
//  MBShoppingCartModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBShoppingCartModel.h"

@implementation MBShoppingCartModel


-(NSMutableArray<MBGood_ListModel *> *)goods_list{
    if (!_goods_list) {
        _goods_list = [NSMutableArray array];
    }
    return _goods_list;
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    self.goods_list =  [[NSArray modelDictionary:dic modelKey:@"goods_list" modelClassName:@"MBGood_ListModel"] mutableCopy];
    WS(weakSelf)
    [self.goods_list enumerateObjectsUsingBlock:^(MBGood_ListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.flow_order integerValue] == 1) {
            weakSelf.isSettlement = YES;
        }
    }];
    return YES;
}


@end
@implementation MBGood_ListModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
   
    return YES;
}
@end
@implementation MBTotalModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
   
    return YES;
}
@end
