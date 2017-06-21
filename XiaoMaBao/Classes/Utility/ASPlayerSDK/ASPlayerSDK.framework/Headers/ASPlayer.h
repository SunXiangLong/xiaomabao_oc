//
//  ASPlayer.h
//  ASPlayerTest
//
//  Created by Steven on 2017/6/10.
//  Copyright © 2017年 Ablesky. All rights reserved.
//
//实现方法回调
#import <Foundation/Foundation.h>
#import "ASResponseStatus.h"
@class ASPlayer;
@interface ASPlayer : NSObject

/**
创建播放单例
 */
+ (id)sharedInstance;

/**
 初始化登陆信息
 此方法用于传送cookie信息
 
 @param userName 用户名
 @param cookie 登录成功后返回的cookie
 */
-(void)ASInitMessageOfLogin:(NSString*)userName cookie:(NSArray*)cookie;

/**
 展示课程详情页
 
 @param orgid 机构ID
 @param controller 跳转时的控制器
 */
-(void)ASShowCourseControllerWithOrgid:(NSString*)orgid
                            controller:(UIViewController*)controller;

/**
 展示个人中心页面
 */
-(void)ASShowViewControllerForMyCenter:(UIViewController*)controller;

/**
 @param url        链接
 @param identifier 请求标识符
 @param params 参数
 @param cookie 是否上传cookie 不传为NO
 @param block  回调
 */
-(void)ASRequestWithUrl:(NSString*)url
             identifier:(NSString*)identifier
                 params:(NSDictionary*)params
               isCookie:(BOOL)cookie
                  block:(PlayerRequestCompleteBlock)block;
@end
