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
#import "MBGoodsDetailsViewController.h"
#import "MBActivityViewController.h"
#import "MBGroupShopController.h"
@interface MBBabyWebController ()<UIWebViewDelegate>
{
  
    
}
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) UIProgressView *progressView;
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
    
    [self setUI];
}

- (void)setUI{
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, TOP_Y, [[UIScreen mainScreen] bounds].size.width, 2)];
    _progressView.progressTintColor = [UIColor purpleColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    //    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y)];
    [self.view addSubview:_webView];
    [self.view addSubview:_progressView];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    
    [self deleteCookie];
    [self setCookie];
    
    
    [_webView loadRequest:request];


    [RACObserve(self.progressView, progress) subscribeNext:^(id x) {
    
        if (self.progressView.progress == 1) {
            
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                self.progressView.hidden = YES;
                
            }];
        }
      
        
    }];
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
- (void)webViewDidStartLoad:(UIWebView *)webView{

    self.progressView.progress = 0.75;
}
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    //当网页视图结束加载一个请求之后，得到通知。
    self.progressView.progress = 1;
 
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
                    NSString *params =  dic[@"params"];
                    VC.url = URL([params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                    VC.title = dic[@"topId"];
                    [self pushViewController:VC Animated:YES];
                }
                
            });
            
            
        }];
        context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            MMLog(@"异常信息：%@", exceptionValue);
        };
    
    

    
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    MMLog(@"%@",error);
    self.progressView.progress = 0;
    [self show:error.userInfo[@"NSLocalizedDescription"] time:1];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (_webView.canGoBack) {
        [_webView goBack];
        return nil;
    }
    return [self.navigationController popViewControllerAnimated:animated];
}

@end
