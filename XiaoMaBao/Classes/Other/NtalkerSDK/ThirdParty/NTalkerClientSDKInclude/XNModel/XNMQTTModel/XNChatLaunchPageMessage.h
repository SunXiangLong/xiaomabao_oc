//
//  XNChatLaunchPageMessage.h
//  NTalkerClientSDK
//
//  Created by Ntalker on 16/1/5.
//  Copyright © 2016年 NTalker. All rights reserved.
//  咨询发起页消息

#import "XNBaseMessage.h"

@interface XNChatLaunchPageMessage :XNBaseMessage

//发起页标题
@property (strong, nonatomic) NSString *pageTitle;

//发起页URL
@property (strong, nonatomic) NSString *pageURLString;


+ (NSString *)XMLStrFromMessage:(XNChatLaunchPageMessage *)message;

@end
