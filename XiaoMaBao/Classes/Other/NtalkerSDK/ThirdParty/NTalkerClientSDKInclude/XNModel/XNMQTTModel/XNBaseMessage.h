//
//  XNBaseMessage.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/3.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//  消息父类:消息公共参数

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XNMsgType) {
    MSG_TYPE_UNKNOWN = 0,
    MSG_TYPE_TEXT = 1,
    MSG_TYPE_PICTURE = 2,
    MSG_TYPE_FILE = 4,
    MSG_TYPE_SYSTEM = 5,
    MSG_TYPE_VOICE = 6,
    MSG_TYPE_SYSTEM_EVALUATE,
    MSG_TYPE_SYSTEM_PRODUCTINFO,
    MSG_TYPE_SYSTEM_ERP,
    MSG_TYPE_SYSTEM_CHATLAUNCHPAGE,
};

typedef NS_ENUM(NSUInteger, XNSystemMsgType) {
    MSG_SYSTEM_EVALUATE = 3,
    MSG_SYSTEM_PRODUCTTION = 5,
};

typedef NS_ENUM(NSUInteger, XNMsgSendStatus) {
    SS_TOSEND = 0,
    SS_SENDING = 1,
    SS_SENDSUCCESS = 2,
    SS_SENDFAILED = 3,
    SS_RECEIVESUCCESS = 4
};

@interface XNBaseMessage : NSObject

@property (nonatomic, assign) NSUInteger msgType;
@property (nonatomic, assign) NSUInteger subType;
@property (nonatomic, strong) NSString *msgid;
@property (nonatomic, assign) long long msgtime;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *usericon;
@property (nonatomic, strong) NSString *usignature;
@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, strong) NSString *settingid;
@property (nonatomic, strong) NSString *settingname;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *externalname;
@property (nonatomic, strong) NSString *settingicon;
@property (nonatomic, assign) NSUInteger sendStatus;
@property (nonatomic, assign) NSUInteger sendCount;
@property (nonatomic, assign) long long lastSendTime;

- (id)messageObject;

@end
