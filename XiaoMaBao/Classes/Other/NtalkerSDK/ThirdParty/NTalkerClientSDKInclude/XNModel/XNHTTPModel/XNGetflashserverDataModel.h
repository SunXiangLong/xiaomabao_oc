//
//  XNGetflashserverDataModel.h
//  XNChatCore
//
//  Created by Ntalker on 15/8/20.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNGetflashserverDataModel : NSObject

@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *presenceserver;
@property (nonatomic, strong) NSString *presencegoserver;
@property (nonatomic, strong) NSString *history;
@property (nonatomic, strong) NSString *avserver;
@property (nonatomic, strong) NSString *fileserver;
@property (nonatomic, strong) NSString *t2dserver;
@property (nonatomic, strong) NSString *t2dstatus;
@property (nonatomic, strong) NSString *tchatserver;
@property (nonatomic, strong) NSString *tchatgourl;
@property (nonatomic, strong) NSString *trailserver;
@property (nonatomic, strong) NSString *manageserver;
@property (nonatomic, strong) NSString *crmserver;
@property (nonatomic, strong) NSString *coopurl;
@property (nonatomic, strong) NSString *updateurl;
@property (nonatomic, strong) NSString *coopserver;
@property (nonatomic, strong) NSString *promotionserver;
@property (nonatomic, strong) NSString *crmcenter;
@property (nonatomic, strong) NSString *agentserver;
@property (nonatomic, strong) NSString *t2dmqttserver;
@property (nonatomic, strong) NSString *tchatmqttserver;
@property (nonatomic, strong) NSString *immqttserver;
@property (nonatomic, strong) NSString *usecache;
//将来会用的
@property (nonatomic, strong) NSString *imserver2;

+ (XNGetflashserverDataModel *)getflashserverDataModelFromXMLStr:(NSString *)XMLStr;

@end
