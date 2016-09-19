//
//  MBLogOperation.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBLogOperation.h"
#import "SFHFKeychainUtils.h"
#import "DXAlertView.h"
#import "MBGuidePage.h"
#import "MJExtension.h"
@implementation MBLogOperation

+ (void)loginAuthentication:(NSDictionary *)params success:(void (^)())success
                    failure:(void (^)(NSString *error_desc,NSError *error))failure{
    
    if (params) {
        
        [self userVerifPassword:params isPassword:YES success:success failure:failure];
   
    }else{
        
       [self userVerifPassword:[self accountInformation] isPassword:YES success:success failure:failure];
    }
   
}

+ (void)guidePage:(UIWindow *)window{

    // 初始化引导页控制器
    MBGuidePage *guidePageView = [[MBGuidePage alloc]init];
    guidePageView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT);
    // 设置引导页图片
    guidePageView.dataArray = [NSArray arrayWithObjects:@"lanch0",@"lanch1",@"lanch2",@"lanch3", nil];

    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] boolValue];
    
    if (!flag) {
        
        [window addSubview:guidePageView];
    }
}
+ (void)promptUpdate{

    [MBNetworking POSTOrigin:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/common/check_update"] parameters:@{@"device":@"ios"} success:^(id responseObject) {
        NSDictionary *dic =responseObject;
        
        if ([dic[@"can_update"]isEqualToNumber:@1]) {
            NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            
            if ([version floatValue] < [dic[@"lastest_version"] floatValue]) {
                [self promptUpdate:dic];
            }
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
    }];
}
/**
 *  获取用户登陆信息
 *
 *  @return 登陆验证信息
 */
+(NSDictionary *)accountInformation{
    NSDictionary *params;
    if ([self accountPasswordLogin]) {
        
        params = [self accountPasswordLogin];
        
    }else if([self theThirdPartyLogin]){
        
        params = [self accountPasswordLogin];
        
    }
    return params;
}
#pragma mark -- 获取keychina中存放帐户信息（用户名，密码）进行登陆验证
+ (void)accessKeychinaAccount{

   
    NSDictionary *params;
    if ([self accountPasswordLogin]) {
        
        params = [self accountPasswordLogin];
        
    }else if([self theThirdPartyLogin]){
        
        params = [self accountPasswordLogin];
        
    }
    
    /**
     *  存在帐户信息才走登陆接口
     */
    if (params) {
        
        [self userVerifPassword:params isPassword:NO success:nil failure:nil];
    }
    
    
    
  

}
/**
 *  用户名和密码登陆
 */
+ (NSDictionary * )accountPasswordLogin{
    NSString * UserName = [SFHFKeychainUtils getPasswordForUsername:@"user_name" andServiceName:@"com.xiaomabao.user" error:nil];
    
    NSString * Password = [SFHFKeychainUtils getPasswordForUsername:@"Password" andServiceName:@"com.xiaomabao.Password" error:nil];
    
    if(UserName&&Password){
        
        NSDictionary  *params = @{ @"name":UserName, @"password":Password};
        return params;
       
    }
    return nil;
}
/**
 *   第三方登陆（QQ， 微信，微博）
 */
+ (NSDictionary *)theThirdPartyLogin{

    NSString *sign_type = [SFHFKeychainUtils getPasswordForUsername:@"sign_type" andServiceName:@"com.xiaomabao.sign_type" error:nil];
    
    NSString *name = [SFHFKeychainUtils getPasswordForUsername:@"name" andServiceName:@"com.xiaomabao.name" error:nil];
    
    NSString *header_img = [SFHFKeychainUtils getPasswordForUsername:@"header_img" andServiceName:@"com.xiaomabao.header_img" error:nil];
    
    NSString *nick_name = [SFHFKeychainUtils getPasswordForUsername:@"nick_name" andServiceName:@"com.xiaomabao.nick_nick_name" error:nil];
    
    if(sign_type&&name&&header_img&&nick_name){
        
        NSDictionary   *params = @{@"sign_type":sign_type, @"name":name,@"header_img":header_img,@"nick_name":nick_name};
        
        return params;
        
    }
    return nil;
}

/**
 *  默认记住密码后台登陆
 *
 *  @return 账号信息
 */
#pragma mark－－获取登陆账号信息
+ (void)userVerifPassword:(NSDictionary *)params isPassword:(BOOL)isPassword
                  success:(void (^)( id responseObject))success
                  failure:(void (^)(NSString *error_desc,NSError *error))failure{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    if (!isPassword) {
        
        [self deleteCookie];
    }

    if (dic[@"password"]) {
            dic[@"password"] = [dic[@"password"] md5];
        }
    
    
  
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/login"] parameters:dic
               success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                   //成功，就把用户信息保存到单列MBUserDataSingalTon中
                   if(1 == [[[responseObject valueForKey:@"status"] valueForKey:@"succeed"] intValue]){
                       NSDictionary *userData = [responseObject valueForKeyPath:@"data"];
                       NSDictionary *sessionDict = [userData valueForKeyPath:@"session"];
//                       MMLog(@"%@",userData);
                       MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
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
                       [MobClick profileSignInWithPUID:userInfo.uid];
                     
                       if (isPassword) {
                           
                           [self savelogInformation:params];
                            success(responseObject);
                           
                       }
                   }else{
                      
                       NSString *errStr =[[responseObject valueForKey:@"status"] valueForKey:@"error_desc"];
                       if (isPassword) {
                           failure(errStr,nil);
                       }
                   }
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   MMLog(@"-----%@",error);
                                      
               }
     ];
    
    
}
/**
 * 删除设置的cookie
 */
+ (void)deleteCookie{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieAry = [cookieJar cookiesForURL: [NSURL URLWithString:@"http://www.xiaomabao.com"]];
    for (cookie in cookieAry) {
        [cookieJar deleteCookie: cookie];
    }
}

/**
 *  提醒更新弹出视图
 *
 *  @param dic 更新内容
 */
+ (void)promptUpdate:(NSDictionary *)dic{
    
    
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示更新" contentText:dic[@"version_description"] leftButtonTitle:@"下次" rightButtonTitle:@"现在更新"];
    [alert show];
    alert.leftBlock = ^() {
        MMLog(@"left button clicked");
    };
    alert.rightBlock = ^() {
        MMLog(@"right button clicked");
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-ma-bao/id1049237132?mt=8"]];
    };
    alert.dismissBlock = ^() {
        MMLog(@"Do something interesting after dismiss block");
    };
    
}

#pragma mark --   保存密码账号到本地
+ (void )savelogInformation:(NSDictionary *)params{
    if (params[@"sign_type"]) {
        
    BOOL  sign_type = [SFHFKeychainUtils storeUsername:@"sign_type" andPassword:params[@"sign_type"]
                          forServiceName:@"com.xiaomabao.sign_type" updateExisting:YES error:nil];
    BOOL name =       [SFHFKeychainUtils storeUsername:@"name" andPassword:params[@"name"]
                          forServiceName:@"com.xiaomabao.name" updateExisting:YES error:nil];
    BOOL header_img = [SFHFKeychainUtils storeUsername:@"header_img" andPassword:params[@"header_img"]
                          forServiceName:@"com.xiaomabao.header_img" updateExisting:YES error:nil];
    BOOL nick_name = [SFHFKeychainUtils storeUsername:@"nick_name" andPassword:params[@"nick_name"]
                          forServiceName:@"com.xiaomabao.nick_nick_name" updateExisting:YES error:nil];
        if (sign_type&&name&&header_img&&nick_name) {
              MMLog(@"✅Keychain保存密码成功");
        }else{
            MMLog(@"❌Keychain保存密码时出错");
        }
    }else{
        NSError *error;
        NSError *errors;
        BOOL saved = [SFHFKeychainUtils storeUsername:@"user_name" andPassword:params[@"name"]
                                    forServiceName:@"com.xiaomabao.user" updateExisting:YES error:&error];
        BOOL pass = [SFHFKeychainUtils storeUsername:@"Password" andPassword:params[@"password"]forServiceName:@"com.xiaomabao.Password" updateExisting:YES error:&errors];
        
        if (!saved&&!pass) {
            MMLog(@"❌Keychain保存密码时出错：%@ %@", error,errors);
        }else{
            MMLog(@"✅Keychain保存密码成功！");
        }
    
    }
    
}

#pragma mark --退出登录时，删除存在keychain里面的登录信息
+ (void)deletePasswordAndUserName{
    
        BOOL UserNameDeleted;
        BOOL Password;
        BOOL sign_type;
        BOOL name;
        BOOL header_img;
        BOOL nick_name;
        UserNameDeleted = [SFHFKeychainUtils deleteItemForUsername:@"user_name" andServiceName:@"com.xiaomabao.user" error:nil];
        Password        = [SFHFKeychainUtils   deleteItemForUsername:@"Password" andServiceName:@"com.xiaomabo.Password" error:nil];
        
        sign_type =    [SFHFKeychainUtils deleteItemForUsername:@"sign_type" andServiceName:@"com.xiaomabao.sign_type" error:nil];
        name =    [SFHFKeychainUtils deleteItemForUsername:@"name" andServiceName:@"com.xiaomabao.name" error:nil];
        header_img =    [SFHFKeychainUtils deleteItemForUsername:@"header_img" andServiceName:@"com.xiaomabao.header_img" error:nil];
        nick_name =    [SFHFKeychainUtils deleteItemForUsername:@"nick_name" andServiceName:@"com.xiaomabao.nick_nick_name" error:nil];
        if (!UserNameDeleted&&!Password) {
            MMLog(@"删除成功");
        }else if (!sign_type&&!name&&!header_img&&!nick_name) {
            MMLog(@"删除成功");
        }
   
}
@end
