//
//  XNUserBasicInfo.h
//  XNChatCore
//
//  Created by Ntalker on 15/8/19.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XNGetflashserverDataModel;
@interface XNUserBasicInfo : NSObject

@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *siteid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userLevel;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appKeyValid;
@property (nonatomic, strong) NSString *trailSessionid;
@property (nonatomic, strong) NSString *device;
@property (nonatomic, strong) NSString *netType;
//初始化成功失败参数
@property (nonatomic, assign) BOOL initSuccess;
@property (nonatomic, strong) XNGetflashserverDataModel *serverData;


+ (XNUserBasicInfo *)sharedInfo;

@end
