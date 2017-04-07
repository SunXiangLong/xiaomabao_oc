//
//  MBLogOperation.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBLogOperation.h"
#import "MBUpdateView.h"
#import "DHGuidePageHUD.h"
@implementation MBLogOperation

+ (void)loginAuthentication:(NSDictionary *)params success:(void (^)())success
                    failure:(void (^)(NSString *error_desc,NSError *error))failure{
    
    if (params) {
        
        [self userVerifPassword:params isPassword:YES success:success failure:failure];
        
    }else{
        
        if ( [User_Defaults valueForKeyPath:@"userInfo"]) {
            
            [self userVerifPassword:[User_Defaults valueForKeyPath:@"userInfo"] isPassword:NO success:nil failure:nil];
        }
        
    }
    
}

+ (void)guidePage:(UIWindow *)window{
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        // 静态引导页
        
        NSArray *imageNameArray = @[@"lanch0",@"lanch1",@"lanch2",@"lanch3"];
        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) imageNameArray:imageNameArray buttonIsHidden:YES];
        guidePage.slideInto = YES;
        [window addSubview:guidePage];

    }


}

+ (void)promptUpdate{
    MBUpdateView *view = [MBUpdateView instanceView];
    view.frame = CGRectMake(0, -UISCREEN_HEIGHT, UISCREEN_WIDTH, UISCREEN_HEIGHT);
    
    
    [MBNetworking POSTOrigin:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/common/update"] parameters:@{@"device":@"ios"} success:^(id responseObject) {
        NSDictionary *dic =responseObject;
        
        MMLog(@"%@",responseObject);
        
        if (dic) {
            
            if ([dic[@"latest_version"] compare:VERSION_1 options:NSNumericSearch] == NSOrderedDescending) {
                view.dataDic = dic;
                [[UIApplication sharedApplication].keyWindow addSubview:view];
                
                [UIView animateWithDuration:.3  animations:^{
                    
                    view.ml_y = 0;
                    
                }];
                
            }
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
    }];
}
#pragma mark 查看本地是否存在登录信息存在就走登录接口
+ (void)defaultLogin{
    
    
    
    /**
     *  存在帐户信息才走登陆接口
     */
    if ( [User_Defaults valueForKeyPath:@"userInfo"]) {
        
        [self userVerifPassword:[User_Defaults valueForKeyPath:@"userInfo"] isPassword:NO success:nil failure:nil];
    }
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSTimer scheduledTimerWithTimeInterval:30*60 target:self selector:@selector(isLoginDate) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop] run];
        
    });
  
    
}
///**
// *  用户名和密码登陆
// */
//+ (NSDictionary * )accountPasswordLogin{
//    NSString * UserName = [SFHFKeychainUtils getPasswordForUsername:@"user_name" andServiceName:@"com.xiaomabao.user" error:nil];
//    
//    NSString * Password = [SFHFKeychainUtils getPasswordForUsername:@"Password" andServiceName:@"com.xiaomabao.Password" error:nil];
//    
//    if(UserName&&Password){
//        
//        NSDictionary  *params = @{ @"name":UserName, @"password":Password};
//        return params;
//        
//    }
//    return nil;
//}
/**
 *   第三方登陆（QQ， 微信，微博）
 */
//+ (NSDictionary *)theThirdPartyLogin{
//    
//    NSString *sign_type = [SFHFKeychainUtils getPasswordForUsername:@"sign_type" andServiceName:@"com.xiaomabao.sign_type" error:nil];
//    
//    NSString *name = [SFHFKeychainUtils getPasswordForUsername:@"name" andServiceName:@"com.xiaomabao.name" error:nil];
//    
//    NSString *header_img = [SFHFKeychainUtils getPasswordForUsername:@"header_img" andServiceName:@"com.xiaomabao.header_img" error:nil];
//    
//    NSString *nick_name = [SFHFKeychainUtils getPasswordForUsername:@"nick_name" andServiceName:@"com.xiaomabao.nick_nick_name" error:nil];
//    
//    if(sign_type&&name&&header_img&&nick_name){
//        
//        NSDictionary   *params = @{@"sign_type":sign_type, @"name":name,@"header_img":header_img,@"nick_name":nick_name};
//        
//        return params;
//        
//    }
//    return nil;
//}
+ (void)isLoginDate{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        return;
    }
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking    POSTOrigin:string(BASE_URL_root, @"/users/refresh_token") parameters:@{@"session":session}  success:^(id responseObject) {
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"][@"succeed"] integerValue]== 1) {
            return ;
        }
        if ( [User_Defaults valueForKeyPath:@"userInfo"]) {
            
            [self userVerifPassword:[User_Defaults valueForKeyPath:@"userInfo"] isPassword:NO success:nil failure:nil];
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
    }];
    
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
    
    if ([User_Defaults valueForKeyPath:@"userInfo"]) {
        NSString *uid = [User_Defaults valueForKeyPath:@"userInfo"][@"uid"];
        NSString *sid = [User_Defaults valueForKeyPath:@"userInfo"][@"sid"];
        if (uid&&sid) {
            [dic addEntriesFromDictionary:@{@"session":@{@"uis":uid,@"sid":sid}}];

        }
        
    }
   
    
  
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/users/login") parameters:dic success:^(id responseObject) {
        if(1 == [responseObject[@"status"][@"succeed"] integerValue]){
        
            MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo:responseObject[@"data"][@"user"]];
            userInfo.sid = responseObject[@"data"][@"session"][@"sid"];
            userInfo.uid = responseObject[@"data"][@"session"][@"uid"];
            [MobClick profileSignInWithPUID:userInfo.uid];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"circleState" object:nil];
            if (isPassword) {
                
                NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:params];
                [mDic addEntriesFromDictionary:responseObject[@"data"][@"session"]];
                [User_Defaults setObject:mDic forKey:@"userInfo"];
                [User_Defaults synchronize];
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
         [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:true];
    }];
    

    
    
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

@end
