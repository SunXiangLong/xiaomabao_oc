//
//  MBWebViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h> //引入头文件
#import "ObjCModel.h"
#import "MBActivityViewController.h"
#import "MBGroupShopController.h"
@interface MBNewWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    
}
@end

@implementation MBNewWebViewController
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
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"duedate" ofType:@"html" ]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    
    [_webView loadRequest:request];
    
}

-(NSString *)titleStr{
    
    return self.title?:@"如何计算预产期";
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
            if ([dic[@"type"] isEqualToString:@"finishView"]) {
                
                [self popViewControllerAnimated:YES];
            }
            
        });
        
        
    }];
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        MMLog(@"异常信息：%@", exceptionValue);
    };
    
    
    [self dismiss];
    
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    MMLog(@"%@",error);
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
