//
//  XNImageMessage.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/8.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//  图片消息

#import "XNBaseMessage.h"

@interface XNImageMessage : XNBaseMessage

@property (nonatomic, strong) NSString *pictureName;
@property (nonatomic, strong) NSString *pictureType;
@property (nonatomic, strong) NSString *pictureThumb;
@property (nonatomic, strong) NSString *pictureSource;
@property (nonatomic, strong) NSString *pictureLocal;
@property (nonatomic, assign) BOOL isEmotion;
@property (nonatomic, strong) NSString *filesize;

+ (XNImageMessage *)imageMessageWithMsgTime:(long long)msgTime
                                  andUserid:(NSString *)userid
                                andUserInfo:(NSString *)userInfo
                                 andMsgInfo:(NSString *)msgInfo;

+ (NSString *)XMLStrFromImageMsg:(XNImageMessage *)imageMessage;

@end
