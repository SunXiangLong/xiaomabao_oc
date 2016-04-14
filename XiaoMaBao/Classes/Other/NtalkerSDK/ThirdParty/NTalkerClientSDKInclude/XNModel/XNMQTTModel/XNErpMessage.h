//
//  XNErpMessage.h
//  NTalkerClientSDK
//
//  Created by Ntalker on 15/12/16.
//  Copyright © 2015年 NTalker. All rights reserved.
//  ERP消息

#import "XNBaseMessage.h"

@interface XNErpMessage : XNBaseMessage

@property (strong, nonatomic) NSString *erpParam;

+ (NSString *)XMLStrFromMessage:(XNErpMessage *)message;

@end
