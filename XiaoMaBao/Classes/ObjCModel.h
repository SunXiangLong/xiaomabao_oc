//
//  ObjCModel.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BkBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h> //引入头文件
#import <WebKit/WebKit.h>
@protocol JavaScriptObjectiveCDelegate <JSExport>
/**
 *  返回计算预产日期的界面
 */
- (void)finishView;
/**
 *  JS调用此方法来调用APP的登录界面
 */
- (void)showLogin;
/**
 *  萌宝界面 添加工具到首页
 */
- (void)refreshToolkit;
/**
 *  JS调用此方法来调用APP的相关界面
 *
 *  @param params js传过来的参数
 */
- (void)showGood:(NSString  *)params;
- (void)showTopic:(NSString *)params;
- (void)showGroup:(NSString *)params;
- (void)showWebView:(NSString *)params :(NSString *)topId;
- (void)showShare:(NSString *)imageUrl :(NSString *)title :(NSString *)center :(NSString *)sharUrl;
@end
@interface ObjCModel : NSObject <JavaScriptObjectiveCDelegate>
@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) RACSubject *myCircleViewSubject;

@end
