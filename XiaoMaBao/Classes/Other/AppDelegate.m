////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑            永无BUG              永不修改         //
////////////////////////////////////////////////////////////////////

//  AppDelegate.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/4/30.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "AppDelegate.h"
//支付宝SDK头文件
#import <AlipaySDK/AlipaySDK.h>
//微信SDK头文件
#import "WXApi.h"
#import "WXApiObject.h"
//极光推送
#import "JPUSHService.h"
#import "JPFPSStatus.h"
#import "MBLogOperation.h"
#import "MBAPService.h"
#import "MBShare.h"
#import "IQKeyboardManager.h"
@interface AppDelegate ()<WXApiDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   //第三方注册
    [self registered:launchOptions];

    return YES;
}
#pragma  mark --注册
-(void)registered:(NSDictionary *)launchOptions{
    //解决键盘遮挡输入框
    [[IQKeyboardManager sharedManager] setEnable:true];
    //友盟注册
    [MBAPService umengTrack];
    //share第三方登陆分享
    [MBShare share];
    // 微信支付注册
    [MBShare WXApi];
    //极光推送（通知）
    [MBAPService required: launchOptions];
    //默认有账号就登陆
    [MBLogOperation accessKeychinaAccount];
    //提示更新APP
    [MBLogOperation promptUpdate];
    //极光推送（消息）
    [MBAPService receiveMessage];
    //app退出时收到通知点击通知启动
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [User_Defaults setObject:userInfo forKey:@"userInfo"];
        [User_Defaults synchronize];
    }
    //提示用户评价
    [self setAppirater];
    
    [self.window makeKeyAndVisible];
    //第一次打开应用显示导航
    [MBLogOperation guidePage:self.window];
    //消息数置0
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

#if defined(DEBUG)||defined(_DEBUG)

     //[[JPFPSStatus sharedInstance] open];
#endif

    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
      [MBLogOperation accessKeychinaAccount];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /***极光推送获取token*/
    [JPUSHService registerDeviceToken:deviceToken];
}
/**
 *  极光推送在后台收到通知走该方法
 *
 *  @param application       系统单例
 *  @param userInfo          通知字典
 *  @param completionHandler 回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [MBAPService  receiveRemoteNotification:userInfo root:self.window application:application];
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url{
    
    // 接受传过来的参数
    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打开啦"
                                                        message:text
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    // 当用户通过支付宝客户端进行支付时,会回调该block:standbyCallback
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"alipayPay" object:nil userInfo:resultDic]];
    }];
    
     return   [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}


-(void)onResp:(BaseResp*)resp
{
    [MBShare onResp:resp];
}

/**
 *  提醒用户评价app  安装应用1天后提醒5次   点击以后提醒 推迟两天提醒评价
 */
-(void)setAppirater{
    
    [Appirater setAppId:@"1049237132"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
}

@end
