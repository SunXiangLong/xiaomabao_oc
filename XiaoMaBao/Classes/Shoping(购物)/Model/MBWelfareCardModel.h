//
//  MBWelfareCardModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBWelfareCardModel : NSObject
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *goods_price;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSURL *goods_thumb;
@end
@interface MBElectronicCardModel : NSObject
@property (nonatomic,strong) NSString *card_id;
@property (nonatomic,strong) NSString *card_no;
@property (nonatomic,strong) NSString *card_cnt;
@property (nonatomic,strong) NSString *card_number;
@property (nonatomic,strong) NSString *card_name;
@property (nonatomic,strong) NSString *subtotal;
@property (nonatomic,strong) NSString *card_money;
@property (nonatomic,strong) NSURL *card_img;
@property (nonatomic,strong) NSString *card_max_money;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isSelection;
@property (nonatomic, assign) BOOL isCustom;
@end
@interface MBElectronicCardTotalModel : NSObject
@property (nonatomic,strong) NSString *card_amount;
@property (nonatomic,strong) NSString *shipping_fee;
@property (nonatomic,strong) NSString *mabao_card_amount;
@property (nonatomic,strong) NSString *card_numbers;
@property (nonatomic,strong) NSString *be_paid;
@end
@interface MBElectronicCardInvlModel : NSObject
@property (nonatomic,strong) NSString *inv_content;
@property (nonatomic,strong) NSString *inv_type;
@property (nonatomic,strong) NSString *inv_payee;
@end
@interface MBElectronicCardOrderModel : NSObject
@property (nonatomic,strong) MBElectronicCardInvlModel *inv;
@property (nonatomic,strong) MBElectronicCardTotalModel *total;
@property (nonatomic,strong) NSArray <MBElectronicCardModel *> *cardsArrray;
@end
