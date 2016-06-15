//
//  MBWebViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyWebController.h"
#import <JavaScriptCore/JavaScriptCore.h> //引入头文件
#import "ObjCModel.h"
#import "MBShopingViewController.h"
#import "MBActivityViewController.h"
#import "MBGroupShopController.h"
#import "MBLoginViewController.h"
@interface MBBabyWebController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    
}
@end

@implementation MBBabyWebController
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y)];
    [self.view addSubview:_webView];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self show:@"加载中..."];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor colorR:205 colorG:222 colorB:232];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
  
        [self deleteCookie];
        [self setCookie];
    
    
    [_webView loadRequest:request];
    
}
/**
 *   删除cookie
 */
- (void)deleteCookie{
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookieAry = [cookieJar cookiesForURL:self.url];
    
    for (cookie in cookieAry) {
        
        [cookieJar deleteCookie: cookie];
        
    }
}
/**
 *   注册cookie
 */
- (void)setCookie{
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    [cookieProperties setObject:@"ECS_ID" forKey:NSHTTPCookieName];
    if (sid) {
        [cookieProperties setObject:sid forKey:NSHTTPCookieValue];
    }
    
    [cookieProperties setObject:@".xiaomabao.com" forKey:NSHTTPCookieDomain];
//    [cookieProperties setObject:self.url forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24*360] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}
-(NSString *)titleStr{
    
    return self.title?:@"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    //当网页视图结束加载一个请求之后，得到通知。
    
 
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        // 通过模型调用方法，这种方式更好些。
        ObjCModel *model  = [[ObjCModel alloc] init];
        context[@"xmbapp"] = model;
        model.jsContext = context;
        model.webView = _webView;
        @weakify(self);
        [[model.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *dic) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic[@"type"] isEqualToString:@"refreshTool"]) {
                    [self.myCircleViewSubject sendNext:@1];
                }else if ([dic[@"type"] isEqualToString:@"showWebView"]){
                    MBBabyWebController *VC = [[MBBabyWebController alloc] init];
                    VC.url = URL(dic[@"params"]);
                    VC.title = dic[@"topId"];
                    [self pushViewController:VC Animated:YES];
                }
                
            });
            
            
        }];
        context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"异常信息：%@", exceptionValue);
        };
    
    
    [self dismiss];
    
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    NSLog(@"%@",error);
    [self show:error.userInfo[@"NSLocalizedDescription"] time:1];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (_webView.canGoBack) {
        [_webView goBack];
        return nil;
    }
    return [self.navigationController popViewControllerAnimated:animated];
}

- (void)loginClicksss{
    //跳转到登录页
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}
@end
