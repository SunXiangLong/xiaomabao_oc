//
//  XNVoiceMessage.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/8.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//  语音消息

#import "XNBaseMessage.h"

@interface XNVoiceMessage : XNBaseMessage

@property (nonatomic, strong) NSString *voiceName;
@property (nonatomic, strong) NSString *voiceType;
@property (nonatomic, strong) NSString *sourceURL;
@property (nonatomic, strong) NSString *mp3URL;
@property (nonatomic, strong) NSString *voiceLocal;
@property (nonatomic, assign) NSInteger voiceLength;
@property (nonatomic, strong) NSString *fileSize;

+ (XNVoiceMessage *)voiceMessageWithMsgTime:(long long)msgTime
                                  andUserid:(NSString *)userid
                                andUserInfo:(NSString *)userInfo
                                 andMsgInfo:(NSString *)msgInfo;

+ (NSString *)XMLStrFromVoiceMessage:(XNVoiceMessage *)voiceMessage;

@end
