//
//  XNSDKCore.h
//  XNChatCore
//  XNVersion @"2.0"
//  Created by Ntalker on 15/8/19.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//


#import <Foundation/Foundation.h>

extern NSString * const NOTIFINAME_XN_UNREADMESSAGE;



@class UIViewController,XNBaseMessage,XNChatBasicUserModel,XNProductionMessage;
@protocol XNNotifyInterfaceDelegate <NSObject>

- (void)connectStatus:(NSInteger)status;
- (void)message:(XNBaseMessage *)message;
- (void)requestEvaluate:(NSString *)userName;
- (void)sceneChanged:(BOOL)couldEvaluate //是否可以评价
         andEvaluted:(BOOL)evaluated;    //是否评价过
- (void)userList:(XNChatBasicUserModel *)user;

//排队
- (void)currentWaitingNum:(NSInteger)num;

@end

@interface XNSDKCore : NSObject

@property (nonatomic, weak) id<XNNotifyInterfaceDelegate> delegate;

+ (XNSDKCore *)sharedInstance;

/*
程序开启,注册连接
 */
- (NSInteger)initSDKWithSiteid:(NSString *)siteid andSDKKey:(NSString *)SDKKey;

/*
for h5
*/
- (NSInteger)initSDKWithSiteid:(NSString *)siteId
                     andSDKKey:(NSString *)SDKKey
             andFlashServerUrl:(NSString *)serverURLString
                       andPcid:(NSString *)pcId;

/*
 程序关闭,断开连接
 */
- (void)destroy;

/*
用户登录
 */
- (NSInteger)loginWithUserid:(NSString *)userid
            andUsername:(NSString *)username
           andUserLevel:(NSString *)userLevel;

/*
 用户退出
 */
- (void)logout;

/*
 轨迹调用
 */
- (NSInteger)startActionWithTitle:(NSString *)title          //页面标题,必填
                      andSellerId:(NSString *)sellerid
                       andOrderid:(NSString *)orderid
                    andOrderprice:(NSString *)orderprice
                           andRef:(NSString *)ref
                  andNtalkerparam:(NSString *)ntalkerparam
                         andIsVip:(NSString *)isVip
                     andURLString:(NSString *)URLString;

#pragma mark =======================chat api========================

- (void)closeChatViewSessionid:(NSString *)sessionid;

- (void)startChatWithSessionid:(NSString *)sessionid kefuId:(NSString *)kefuId isSingle:(NSString *)isSingle;

- (void)sendMessage:(XNBaseMessage *)message resend:(BOOL)resend;

- (void)chatIntoBackGround:(NSString *)settingId;

- (NSMutableArray *)messageFromDBByNum:(NSInteger)num andOffset:(NSInteger)offset;

@end
