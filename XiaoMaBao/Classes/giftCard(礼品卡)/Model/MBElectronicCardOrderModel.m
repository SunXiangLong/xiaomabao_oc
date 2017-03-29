//
//  MBElectronicCardOrderModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBElectronicCardOrderModel.h"

@implementation MBElectronicCardOrderModels
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    self.orderCardsListArray = [NSArray modelDictionary:dic modelKey:@"order_cards_list" modelClassName:@"MBElectronicCardModel"];
    return YES;
}
@end
@implementation virtualModel
@end

@implementation MBElectronicCardOrderInfoModels

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    self.orderCardsListArray = [NSArray modelDictionary:dic modelKey:@"card_list" modelClassName:@"MBElectronicCardModel"];
    self.virtualArray = [NSArray modelDictionary:dic modelKey:@"virtual" modelClassName:@"virtualModel"];
    ;    return YES;
}
@end
