//
//  XNUtilityHelper.h
//  XNChatCore
//
//  Created by Ntalker on 15/8/20.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XN_UUID  @"XNGetUUID"

@interface XNUtilityHelper : NSObject

//获取cid
+ (NSString *)cidFromLocalStore;

//1970据当前的时间(精确到毫秒)
+ (NSString *)getNowTimeInterval;

//get请求时拼接完整的URL
+ (NSString *)URLStringByURLBody:(NSString *)businessName andParam:(NSMutableDictionary *)paramDic;

//模型转换成容器
+ (id)dictOrArrayWithModel:(id)dataModel;

//判断某个id下是否需要开启未读消息通知
+ (BOOL)needOpenUnreadmsgByUserid:(NSString *)uid;

//判断对应的siteID是否需要getflashserver请求
+ (BOOL)needGetflashserverBySited:(NSString *)sited;

//获取设备类型
+ (NSString *)deviceModel;

//长id变短id
+ (NSString *)shortUidFromUid:(NSString *)uid;

//
+ (NSString *)siteidFromUid:(NSString *)uid;

//
+ (NSString *)siteidfromSettingid:(NSString *)settingid;

+ (NSString *)md5:(NSString *)originStr;

+ (NSString *)stringFromGBData:(NSData *)data;

+ (NSString *)randomString;

+ (NSString *)gzipInflate:(NSData *)compressStr;

+ (BOOL)isKefuUserid:(NSString *)uid;

+ (BOOL)isVisitUserid:(NSString *)uid;

+ (NSString *) getFormatTimeString:(NSString *)timeStr;

+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect ;

+ (NSString *)getConfigFile:(NSString *)fileName;

@end
