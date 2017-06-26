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
@property(nonatomic,assign) BOOL isRefresh;
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
    _webView.allowsInlineMediaPlayback = true;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    
    [self deleteCookie];
    [self setCookie];
    
    
    [_webView loadRequest:request];

    
    @weakify(self);
    [RACObserve(self.progressView, progress) subscribeNext:^(id x) {
        @strongify(self);
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

-(void)share{
    
    //1、创建分享参数
    NSArray* imageArray = @[@"http://www.xiaomabao.com/static1/images/app_icon.png"];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.title
                                         images:imageArray
                                            url:self.url
                                          title:self.title
                                           type:3];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
    }
    
    
}

-(NSString *)rightImage{
    
    
    return    [self.title isEqualToString:@"添加工具到首页"]?@"":@"share";
}
-(void)rightTitleClick{
    if ( [self.title isEqualToString:@"添加工具到首页"]) {
        return;
    }
    [self share];
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
                    self.isRefresh= true;
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
    
    if (_isRefresh) {
        self.toolDataRefresh();
    }
    return [self.navigationController popViewControllerAnimated:animated];
}

@end
