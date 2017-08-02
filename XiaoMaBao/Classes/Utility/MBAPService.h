//
//  MBAPService.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBAPService : NSObject

/**极光message用户注册和登录 */
+ (void)registerWithUserinfo:(NSDictionary *)dic;
/**极光messageSDK初始化 */
+ (void)requiredMessage:(NSDictionary *)launchOptions;
/***  极光推送注册***/
+ (void)required:(NSDictionary *)launchOptions;
/***  监听有没有收到推送消息（不是通知） **/
+ (void)receiveMessage;
/***  接收到通知点击触发 **/
+ (void)receiveRemoteNotification:(NSDictionary *)userInfo root:(UIWindow *)windows application:(UIApplication *)application;
/***  友盟统计注册***/
+ (void)umengTrack;
@end
