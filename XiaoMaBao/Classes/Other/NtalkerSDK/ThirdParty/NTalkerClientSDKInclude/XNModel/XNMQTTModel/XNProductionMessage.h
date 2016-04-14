//
//  XNProductionMessage.h
//  XNChatCore
//
//  Created by Ntalker on 15/10/30.
//  Copyright © 2015年 Kevin. All rights reserved.
//  商品消息

#import "XNBaseMessage.h"

@interface XNProductionMessage :XNBaseMessage

@property (strong, nonatomic) NSString *goodsId;
@property (strong, nonatomic) NSString *productInfoURL;
@property (strong, nonatomic) NSString *itemparam;

+ (NSString *)XMLStrFromMessage:(XNProductionMessage *)message;

+ (XNProductionMessage *)productMessageWithMsgTime:(long long)msgTime
                                        andUserid:(NSString *)userid
                                      andUserInfo:(NSString *)userInfo
                                       andMsgInfo:(NSString *)msgInfo;

@end
