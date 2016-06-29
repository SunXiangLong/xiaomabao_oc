//
//  MBShare.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBShare.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
#import "WXApiObject.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@implementation MBShare

+ (void)WXApi{
    
 [WXApi registerApp:@"wxfb1286f7ab6a18f3" withDescription:@"demo 2.0"];

}
+ (void)onResp:(BaseResp*)resp{
    
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
                success = @"1";
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：%@！",[CodeDict valueForKey:[NSString stringWithFormat:@"%d",resp.errCode]]];
                success = @"0";
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"wayPay" object:nil userInfo:@{@"strMsg":strMsg,@"success":success}]];
    }
}


+ (void)share{
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
                 //             case SSDKPlatformTypeRenren:
                 //                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                 //                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                 //                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                 //                                               authType:SSDKAuthTypeBoth];
                 //                 break;
                 //             case SSDKPlatformTypeGooglePlus:
                 //                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                 //                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                 //                                            redirectUri:@"http://localhost"
                 //                                               authType:SSDKAuthTypeBoth];
                 //                 break;
             default:
                 break;
         }
     }];


}
@end
