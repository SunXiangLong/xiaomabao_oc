//
//  MBAPService.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAPService.h"
#import "JPUSHService.h"
#import "MBGoodsDetailsViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
#import "MBTabBarViewController.h"
#import "MBNavigationViewController.h"
#import "MBCheckInViewController.h"
#import "MBLogOperation.h"
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "MBSMMessageCenterVC.h"
#import <UserNotifications/UserNotifications.h>
@implementation MBAPService

+ (void)umengTrack{
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:false];//开始调试模式
    UMAnalyticsConfig *config = [[UMAnalyticsConfig alloc] init];
    config.appKey = UMENG_APPKEY;
    config.ePolicy = (ReportPolicy) REALTIME;
    [MobClick startWithConfigure:config];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}
+ (void)registerWithUserinfo:(NSDictionary *)dic{
    
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/jpushApi/get_login_account") parameters:@{@"session":[MBSignaltonTool getCurrentUserInfo].sessiondict} success:^(id responseObject) {
//        MMLog(@"%@",responseObject);
        [self loginWith:responseObject];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
    }];
    
}
+ (void)loginWith:(NSDictionary *)dic{
    //登录
    [JMSGUser loginWithUsername:dic[@"user_name"] password:dic[@"password"] completionHandler:^(id resultObject, NSError *error){
        if (!error) {
            [MBSignaltonTool getCurrentUserInfo].isLogin = true;
        }else{
            MMLog(@"%@",error.description);
            [MBSignaltonTool getCurrentUserInfo].isLogin = false;
        }
    }];
    
    
    
    
    
}
+ (void)requiredMessage:(NSDictionary *)launchOptions{
    
    [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                  UIUserNotificationTypeSound |
                                                  UIUserNotificationTypeAlert)
                                      categories:nil];
    
    [JMessage setupJMessage:launchOptions appKey:@"f05bfa6c8239efa28520f511" channel:@"APPStore" apsForProduction:NO category:nil messageRoaming:false];
}
+ (void)required:(NSDictionary *)launchOptions{
    
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"f05bfa6c8239efa28520f511" channel:@"APPStore" apsForProduction:YES advertisingIdentifier:nil];
    
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        MMLog(@"%@",registrationID);
    }];
    
    
    
    
}
+ (void)receiveMessage{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
}
+ (void)receiveRemoteNotification:(NSDictionary *)userInfo root:(UIWindow *)windows application:(UIApplication *)application{
    MBTabBarViewController *tabBarVc = (MBTabBarViewController *)windows.rootViewController;
    MBNavigationViewController *rootVC = tabBarVc.selectedViewController;
    //    UIApplicationLaunchOptionsRemoteNotificationKey
    BOOL isJmessage = false;
    //判断是否为极光message
    if ([userInfo[@"_j_type"] isEqualToString:@"jmessage"]) {
        isJmessage = true;
    }
    switch (application.applicationState) {
        case UIApplicationStateActive:{
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:isJmessage ?@"收到一条消息":@"小麻包母婴通知" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *OK = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                [self notifJumpInterface:userInfo root:windows];
            }];
            
            [alert addAction:cancel];
            [alert addAction:OK];
            [rootVC presentViewController:alert animated:YES completion:nil];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            
            
        }break;
        case UIApplicationStateInactive:{
            
            
            [self notifJumpInterface:userInfo root:windows];
            
            
        }break;
        case UIApplicationStateBackground:{
            
            
        }break;
        default:
            break;
    }
    
}
/**
 *  推送消息
 *
 *  @param notification 消息内容
 */
+ (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    MMLog(@"%@",userInfo);
    NSString *strNum = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"new_message"]];
    NSString *uid = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"uid"]];
    [User_Defaults setObject:strNum forKey:@"messageNumber"];
    [User_Defaults synchronize];
    
    NSString *userUid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    if (userUid) {
        if ([userUid isEqualToString:uid]) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"messageBadge" object:nil userInfo:nil]];
        }
    }
    
    
}
/**
 * 根据推送通知的字断不同 跳转响应的界面 type －>goods:商品详情页 －>topic:专题界面 －>group:网页 ->group:团购界面
 *
 * UIApplicationStateActive, // 激活状态，用户正在使用App
 * UIApplicationStateInactive, // 不激活状态，用户切换到其他App、按Home键回到桌面、拉下通知中心
 * UIApplicationStateBackground // 在后台运行
 *  @param userInfo 推送信息字典
 *  @param windows  根视图
 */
+ (void)notifJumpInterface:(NSDictionary *)userInfo root:(UIWindow *)windows{
    MBTabBarViewController *tabBarVc = (MBTabBarViewController *)windows.rootViewController;
    MBNavigationViewController *rootVC = tabBarVc.selectedViewController;
    if (userInfo){
        NSString *type = userInfo[@"type"];
        if ([type isEqualToString:@"goods"]) {
            MBGoodsDetailsViewController *VC = [[MBGoodsDetailsViewController alloc] init];
            VC.GoodsId =  userInfo[@"id"];
            [rootVC pushViewController:VC animated:YES];
        }else if([type isEqualToString:@"topic"]){
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = userInfo[@"id"];
            [rootVC pushViewController:VC animated:YES];
        }else if([type isEqualToString:@"group"]){
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            [rootVC pushViewController:VC animated:YES];
        }else if([type isEqualToString:@"web"]){
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:userInfo[@"id"]];
            VC.isloging = YES;
            [rootVC pushViewController:VC animated:YES];
        }else if([type isEqualToString:@"signIn"]){
            [MBLogOperation getMBLogOperationObject].isNotification = true;
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Shopping" bundle:[NSBundle mainBundle]];
            MBCheckInViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBCheckInViewController"];
            [rootVC pushViewController:myView animated:true];
        }else if([userInfo[@"_j_type"] isEqualToString:@"jmessage"]) {
            MBSMMessageCenterVC *VC = [[UIStoryboard storyboardWithName:@"secondaryMarket" bundle:nil] instantiateViewControllerWithIdentifier:@"MBSMMessageCenterVC"];
            [rootVC pushViewController:VC animated:true];
        }
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
}

+ (void)onlineConfigCallBack:(NSNotification *)note {
    
    MMLog(@"online config has fininshed and note = %@", note.userInfo);
    
}
@end
