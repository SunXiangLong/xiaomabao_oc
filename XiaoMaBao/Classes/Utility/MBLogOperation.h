//
//  MBLogOperation.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBLogOperation : NSObject

+(MBLogOperation * )getMBLogOperationObject;

@property(nonatomic,assign) BOOL isNotification;

@property (nonatomic, strong) RACSubject *bloc;
/**
 查看本地是否存在登录信息存在就走登录接口
 */
+ (void)defaultLogin;
/**
 *  提示更新APP
 */
+ (void)promptUpdate;
/***  引导页*/
+ (void)guidePage:(UIWindow *)window;
/***  登陆验证  成功保存用户信息 失败 给用户提示
 *
 *  @param params  登陆信息
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
+ (void)loginAuthentication:(NSDictionary *)params success:(void (^)())success
                    failure:(void (^)(NSString *error_desc, NSError *error))failure;
/***  删除Cookie信息*/
+ (void)deleteCookie;

@end
