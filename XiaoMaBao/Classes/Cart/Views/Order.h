//
//  Order.h
//  AlixPayDemo
//
//  Created by 方彬 on 11/2/13.
//
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;
@property(nonatomic, copy) NSString * terminal_type;

@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选
@property(nonatomic, readonly) NSMutableDictionary * extraParams;

 //境外支付
@property(nonatomic, copy) NSString * forex_biz;//境外业务（可选值:FP和PRE_AUTH “FP” : 即使到账模式, 也是最常用的集成方式  ）
/*
 split_fund_info=[{"transIn":"2088101126708402","amount":"0.10",”currency ”:”USD”,"desc":" 分 账 测 试 1"},{"transIn":"2088101126707869","amount":"0.10",”currency”:”USD”,"des c":"分账测试 2"}]
 */
@property(nonatomic, copy) NSString *split_fund_info;//分账信息
@property(nonatomic, copy)NSString * currency;//境外产品码
@property(nonatomic, copy)NSString * product_code;//币种

@property(nonatomic, copy)NSString * rmb_fee;//币种

@end
