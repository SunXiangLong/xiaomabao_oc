//
//  MBElectronicCardOrderModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBWelfareCardModel.h"
@interface MBElectronicCardOrderModels : NSObject
@property (nonatomic,strong) NSString *order_sn;
@property (nonatomic,strong) NSString *add_time;
@property (nonatomic,strong) NSString *order_amount;
@property (nonatomic,strong) NSString *order_status_code;
@property (nonatomic,strong) NSArray<MBElectronicCardModel *> *orderCardsListArray;
@end

@interface virtualModel : NSObject
@property (nonatomic,strong) NSString *card_name;
@property (nonatomic,strong) NSString *card_no;
@property (nonatomic,strong) NSString *card_pass;
@end

@interface MBElectronicCardOrderInfoModels : MBElectronicCardOrderModels
@property (nonatomic,strong) NSString *shipping_fee;
@property (nonatomic,strong) NSString *mabao_card_amount;
@property (nonatomic,strong) NSString *card_amount;
@property (nonatomic,strong) NSArray<virtualModel *> *virtualArray;
@end
