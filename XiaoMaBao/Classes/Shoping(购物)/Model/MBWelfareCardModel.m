//
//  MBWelfareCardModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBWelfareCardModel.h"

@implementation MBWelfareCardModel
@end
@implementation MBElectronicCardModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    self.count = 0;
    return YES;
}
@end
@implementation MBElectronicCardTotalModel
@end
@implementation MBElectronicCardInvlModel
@end
@implementation MBElectronicCardOrderModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    self.cardsArrray = [NSArray modelDictionary:dic modelKey:@"cards" modelClassName:@"MBElectronicCardModel"];
    return YES;
}
@end
