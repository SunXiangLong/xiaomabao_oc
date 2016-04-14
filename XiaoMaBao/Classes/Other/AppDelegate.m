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
#import "MBNewFeatrueView.h"
#import "SFHFKeychainUtils.h"
#import "NSString+BQ.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "MBPaymentViewController.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <AlipaySDK/AlipaySDK.h>
//微信SDK头文件
#import "WXApi.h"
#import "WXApiObject.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//友盟sdk 头文件
#import "MobClick.h"
//极光推送
#import "APService.h"
//for  mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//for idfa
#import <AdSupport/AdSupport.h>
#import <AFNetworkActivityIndicatorManager.h>
//#import "NTalkerInstance.h"
#import "DXAlertView.h"
@interface AppDelegate ()<WXApiDelegate>
{
    NSArray* titleandIds ;
    NSMutableArray *_messageAarray;
    NSUserDefaults *_messageUserDefaults;
    
}
@property(nonatomic,strong) Reachability *reachability;
@property(nonatomic,assign)  NSInteger networkStatus;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    //友盟注册
    [self umengTrack];
    
    //第一次打开应用显示导航
    if (![self showNewFeature]) {
        [self setupLanuchView];
    }
    //share第三方登陆分享
    [self share];
    
    // 微信支付注册
     [WXApi registerApp:@"wxfb1286f7ab6a18f3" withDescription:@"demo 2.0"];
    
    //友盟移动推广效果统计
    [self AuMobilePromotion];
    
    //极光推送（通知）
    [self Required:launchOptions];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //登陆
    [self Obtain];
    //更新
    [self update];
    //网络监控
    [self configureReachability];

    //小能客服注册
    //**********H5集成才用******************//
    //【重要】  必须在初始化前首先调用  用于获得规定的设备id从而供H5页面所用。
    [XNUtilityHelper cidFromLocalStore];
    
    /**
     SDK初始化
     siteid: 企业ID，即企业的唯一标识。格式示例：kf_9979 【必填】
     SDKKey: 企业通行密钥。(从小能技术支持人员那获得) 【必填】
     */
    
    [[XNSDKCore sharedInstance] initSDKWithSiteid:@"kf_9761" andSDKKey:@"4AE38950-F352-47F3-94EA-97C189F48B0F"];
    
//    [NTalkerInstance initSDKWithSiteid:@"kf_9761" andSdkKey:@"4AE38950-F352-47F3-94EA-97C189F48B0F"];
    
    
    //极光推送（消息）
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    


    
    //提示用户评价
    [self setAppirater];
    
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)setAppirater{

    [Appirater setAppId:@"1049237132"];
    [Appirater setDaysUntilPrompt:5];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
}
#pragma mark ---友盟注册
- (void)umengTrack {

    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
   
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
    
}
#pragma mark --  极光推送（消息）
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
     NSLog(@"%@",userInfo);
    //自定义参数，key是自己定义的

//    NSString *messageNumber = [User_Defaults objectForKey:@"messageNumber"];
    NSString *strNum = [NSString stringWithFormat:@"%@",userInfo[@"extras"][@"new_message"]];
   [User_Defaults setObject:strNum forKey:@"messageNumber"];
   
    [_messageAarray addObject:userInfo];
//    NSArray *arr = [NSArray arrayWithArray:_messageAarray];
//    _messageUserDefaults = [NSUserDefaults standardUserDefaults];
//    [User_Defaults setObject:arr forKey:@"messageContent"];
    [User_Defaults synchronize];
    
    NSNotification *messageBadge =[NSNotification notificationWithName:@"messageBadge" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:messageBadge];

}
//-(void)tagsAliasCallback:(int)iResCode
//                    tags:(NSSet*)tags
//                   alias:(NSString*)alias
//{
//    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
//    
//    
//}

#pragma mark - 获取item菜单
-(void)getMenuItem:(NSString *)menu_type
{
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getFavourableMenu"] parameters:@{@"menu_type":menu_type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
        titleandIds = [responseObject valueForKeyPath:@"data"];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
#pragma markshare第三方登陆分享
- (void)share{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */

    [ShareSDK registerApp:@"iosv1101"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo),
                            //@(SSDKPlatformTypeMail),
                            //@(SSDKPlatformTypeSMS),
                            //@(SSDKPlatformTypeCopy),
                            //@(SSDKPlatformTypeRenren),
                            //@(SSDKPlatformTypeGooglePlus)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"327216701"
                                           appSecret:@"265a479c572d93fa9a00a0736099efc5"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxfb1286f7ab6a18f3"
                                       appSecret:@"486ae703892c7207554d0b5624382639"];
                 
                 
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104820224"
                                      appKey:@"aER7I1TUxBFJzKEv"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                            redirectUri:@"http://localhost"
                                               authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];


}
#pragma mark－－获取登陆账号信息
- (void)zhanghzhao:(NSDictionary *)params{
  
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/user/signin"] parameters:params
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   
                   if(1 == [[[responseObject valueForKey:@"status"] valueForKey:@"succeed"] intValue]){
                       NSDictionary *userData = [responseObject valueForKeyPath:@"data"];
                       
                       
                       NSDictionary *sessionDict = [userData valueForKeyPath:@"session"];
                       MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
//                    NSLog(@"%@",userData);
                       
                       userInfo.sid = [sessionDict valueForKeyPath:@"sid"];
                       userInfo.uid = [sessionDict valueForKeyPath:@"uid"];
                       userInfo.phoneNumber = [[userData valueForKeyPath:@"user"] valueForKeyPath:@"name"];
                       userInfo.mobile_phone = [[userData valueForKeyPath:@"user"] valueForKeyPath:@"mobile_phone"];
                       userInfo.rank_name = [[userData valueForKeyPath:@"user"] valueForKeyPath:@"rank_name"];
                       userInfo.nick_name = [[userData valueForKeyPath:@"user"] valueForKeyPath:@"nick_name"];
                       userInfo.header_img = [[userData valueForKeyPath:@"user"] valueForKeyPath:@"header_img"];
                       userInfo.parent_sex = [[userData valueForKeyPath:@"user"] valueForKeyPath:@"parent_sex"];
                       userInfo.identity_card = [[userData valueForKeyPath:@"user"] valueForKeyPath:@"identity_card"];
                       userInfo.collection_num = userData[@"user"][@"collection_num"];
                       userInfo.is_baby_add = [NSString stringWithFormat:@"%@", userData[@"user"][@"is_baby_add"]];
                       userInfo.user_baby_info = userData[@"user"][@"user_baby_info"];
                   }else{
                       
                       NSString *errStr =[[responseObject valueForKey:@"status"] valueForKey:@"error_desc"];
                       NSLog(@"%@",errStr);
                   }
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                  
                   NSLog(@"%@",error);
                   
               }
     ];


}
#pragma mark -- 友盟移动推广效果统计
-(void)AuMobilePromotion{
    NSString * appKey = @"561f3d13e0f55ae1c60026cf";
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * idfa = [self idfaString];
    NSString * idfv = [self idfvString];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];


}
#pragma mark - 是否需要显示新特性
-(BOOL)showNewFeature{
    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] boolValue];
   
    return flag;
   
}

#pragma mark - 启动页
-(void)setupLanuchView{
    
    CGRect frame = self.window.bounds ;
    MBNewFeatrueView* lanchView = [[MBNewFeatrueView alloc]init];
    __block typeof(lanchView)weakLanView = lanchView;
    lanchView.startNow = ^{
        [UIView animateWithDuration:1 animations:^{
            weakLanView.alpha = 0 ;
        } completion:^(BOOL finished) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstLaunch"];
            [weakLanView removeFromSuperview];
            weakLanView =nil;
            
        }];
    };
    lanchView.frame = frame ;
    lanchView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:lanchView];
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
       [self Obtain];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
    // 当用户通过支付宝客户端进行支付时,会回调该block:standbyCallback
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
    }];
    
    
     return   [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}


-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    NSDictionary *CodeDict = @{@"0":@"支付成功",@"-1":@"失败",@"-2":@"用户点击取消",@"-3":@"发送失败",@"-4":@"授权失败",@"-5":@"微信不支持"};
    
    if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString *success;
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
//                [self alert:@"提示" msg:strMsg];
                success = @"1";
                break;
                
            default:
                
                strMsg = [NSString stringWithFormat:@"支付结果：%@！",[CodeDict valueForKey:[NSString stringWithFormat:@"%d",resp.errCode]]];
//                [self alert:@"提示" msg:strMsg];
                  success = @"0";
                
                break;
                
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"wayPay" object:nil userInfo:@{@"strMsg":strMsg,@"success":success}]];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
}

- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}
#pragma mark --  获取keychina中存放的用户名和密码
- (void)Obtain{
    
    NSString * UserName = [SFHFKeychainUtils getPasswordForUsername:@"zhanghu" andServiceName:@"com.xiaomabao.user" error:nil];
    
    NSString * Password = [SFHFKeychainUtils getPasswordForUsername:@"Password" andServiceName:@"com.xiaomabao.Password" error:nil];
    
    NSString *sign_type = [SFHFKeychainUtils getPasswordForUsername:@"sign_type" andServiceName:@"com.xiaomabao.sign_type" error:nil];
    
    NSString *name = [SFHFKeychainUtils getPasswordForUsername:@"name" andServiceName:@"com.xiaomabao.name" error:nil];
    
    NSString *header_img = [SFHFKeychainUtils getPasswordForUsername:@"header_img" andServiceName:@"com.xiaomabao.header_img" error:nil];
    
    NSString *nick_name = [SFHFKeychainUtils getPasswordForUsername:@"nick_name" andServiceName:@"com.xiaomabao.nick_nick_name" error:nil];
    
    
    if(UserName&&Password){
        
        NSDictionary  *params = @{ @"name":UserName, @"password":[Password md5]};
        [self zhanghzhao:params];



    }else if(sign_type&&name&&header_img&&nick_name){
        
        
    NSDictionary   *params = @{@"sign_type":sign_type, @"name":name,@"header_img":header_img,@"nick_name":nick_name};
                [self zhanghzhao:params];
      
    }
    
}
- (void)update{
    AFHTTPRequestOperationManager *mmmm = [AFHTTPRequestOperationManager manager];
    [mmmm POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/common/check_update"] parameters:@{@"device":@"ios"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
   
        NSDictionary *dic =responseObject;
        
        
        
        if ([dic[@"can_update"]isEqualToNumber:@1]) {
            NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
            if ([version floatValue] <[dic[@"lastest_version"] floatValue]) {
              [self promptUpdate:dic];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(void)promptUpdate:(NSDictionary *)dic{


    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示更新" contentText:dic[@"version_description"] leftButtonTitle:@"下次" rightButtonTitle:@"现在更新"];
    [alert show];
    alert.leftBlock = ^() {
        NSLog(@"left button clicked");
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-ma-bao/id1049237132?mt=8"]];
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };



}
#pragma mark -- 极光推送
- (void)Required:(NSDictionary *)launchOptions{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
//    [APService setBadge:0];
    // Required
    [APService setupWithOption:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
     NSLog(@"%@",userInfo);
     NSString *str = userInfo[@"aps"][@"badge"];
     NSInteger num = [str integerValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"%@",userInfo);
    NSString *str = userInfo[@"aps"][@"badge"];
    NSInteger num = [str integerValue];
    num--;
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:num];
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
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

-(NSString*)uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
#pragma mark - 网络监测

- (void)configureReachability {
    
//    AFHTTPRequestOperationManager *mmmm = [AFHTTPRequestOperationManager manager];
////      mmmm.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [mmmm POST:[NSString stringWithFormat:@"%@",@"http://sunas.cn/mobile/?act=shop_login&op=login"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        
//        
//        
//        NSLog(@"%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        NSLog(@"%@",operation);
//        
//    }];
//
    /*
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    
    self.reachability = Reachability.reachabilityForInternetConnection;
    self.networkStatus = self.reachability.currentReachabilityStatus;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.reachability startNotifier];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged)
                                                 name:kReachabilityChangedNotification
                                               object:nil];*/
}

//- (void)reachabilityChanged {
//    
//    self.networkStatus = self.reachability.currentReachabilityStatus;
//    if (self.networkStatus == ReachableViaWiFi) {
//        [self Obtain];
//      
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在使用WIFI"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        //[alerView show];
//    } else if (self.networkStatus == ReachableViaWWAN) {
//        [self Obtain];
//
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在使用蜂窝移动网络"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//       // [alerView show];
//       
//    } else if (self.networkStatus == NotReachable) {
//        
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络连接，请检查网络设置"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alerView show];
// 
//    }
//    
//   
//}
@end
