//
//  XNTextMessage.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/8.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//  文本消息

#import "XNBaseMessage.h"

#define kFontSize 12

@interface XNTextMessage : XNBaseMessage

@property (nonatomic, strong) NSString *textMsg;
@property (nonatomic, assign) NSUInteger fontSize;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) BOOL italic;
@property (nonatomic, assign) BOOL bold;
@property (nonatomic, assign) BOOL underLine;

+ (XNTextMessage *)textMessageWithMsgTime:(long long)msgTime
                                andUserid:(NSString *)userid
                              andUserInfo:(NSString *)userInfo
                               andMsgInfo:(NSString *)msgInfo;

+ (NSString *)XMLStrFromTextMessage:(XNTextMessage *)textMessage;

@end
