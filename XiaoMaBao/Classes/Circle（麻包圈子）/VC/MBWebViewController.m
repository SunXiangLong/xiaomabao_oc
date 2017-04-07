//
//  MBWebViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h> //引入头文件
#import "ObjCModel.h"
#import "MBGoodsDetailsViewController.h"
#import "MBActivityViewController.h"
#import "MBGroupShopController.h"
#import "MBShoppingCartViewController.h"
@interface MBWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
@implementation MBWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.title  isEqual: @"抽大奖"]) {
        _promptLabel.hidden = false;
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self show:@"加载中..."];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor colorR:205 colorG:222 colorB:232];
    
    [self loadWebview];
    
}
- (void)loadWebview{

    NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    if (self.isloging) {
        [self deleteCookie];
        [self setCookie];
    }
    
    [_webView loadRequest:request];
}
-(NSString *)rightImage{
  return @"share";
}
-(void)rightTitleClick{

    [self share];
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
/**
 *   删除cookie
 */
- (void)deleteCookie{
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookieAry = [cookieJar cookiesForURL: self.url];
    
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
//   NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
   [cookieProperties setObject:@"ECS_ID" forKey:NSHTTPCookieName];
    if (sid) {
           [cookieProperties setObject:sid forKey:NSHTTPCookieValue];
//           [cookieProperties setObject:@"test" forKey:NSHTTPCookieValue];
    }

    [cookieProperties setObject:@".xiaomabao.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:self.url forKey:NSHTTPCookieOriginURL];
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
    
    if (self.isloging) {
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        // 通过模型调用方法，这种方式更好些。
        ObjCModel *model  = [[ObjCModel alloc] init];
        context[@"xmbapp"] = model;
        model.jsContext = context;
        model.webView = self.webView;
        @weakify(self);
        [[model.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *dic) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic[@"type"] isEqualToString:@"showLogin"]) {
                   [self loadWebview];
                }else if ([dic[@"type"] isEqualToString:@"showGood"]){
                    MBGoodsDetailsViewController *VC = [[MBGoodsDetailsViewController alloc] init];
                    VC.GoodsId = dic[@"params"];
                    [self pushViewController:VC Animated:YES];
                }else if ([dic[@"type"] isEqualToString:@"showTopic"]){
                    MBActivityViewController *VC = [[MBActivityViewController alloc] init];
                    VC.act_id = dic[@"params"];;
                    [self pushViewController:VC Animated:YES];
                }else if ([dic[@"type"] isEqualToString:@"showGroup"]){
                    MBGroupShopController *VC = [[MBGroupShopController alloc] init];
                    [self pushViewController:VC Animated:YES];
                }else if([dic[@"type"] isEqualToString:@"showShare"]){
                
                    [self share:dic];
                }else if([dic[@"type"] isEqualToString:@"jumpCart"]){
                    MBShoppingCartViewController *VC = [[MBShoppingCartViewController alloc] init];
                    [self pushViewController:VC Animated:true];
                }
            });
        }];
        context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            MMLog(@"异常信息：%@", exceptionValue);
        };
    }
    
    [self dismiss];
  
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    MMLog(@"%@",error);
    [self show:error.userInfo[@"NSLocalizedDescription"] time:1];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return nil;
    }
    return [self.navigationController popViewControllerAnimated:animated];
}



-(void)share:(NSDictionary *)dic{
    NSString *post_content = dic[@"center"];
    
    if ( [post_content length] > 50) {
        post_content = [post_content substringToIndex:50];
    }
    //1、创建分享参数
    NSArray* imageArray = @[string(BASE_URL_root, dic[@"imageUrl"])];
    
    
    NSURL *url = [NSURL URLWithString:dic[@"sharUrl"]];
    
    
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:post_content
                                         images:imageArray
                                            url:url
                                          title:dic[@"title"]
                                           type:SSDKContentTypeAuto];
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
@end
