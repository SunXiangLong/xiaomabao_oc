//
//  MBLogisticsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBLogisticsViewController.h"

@interface MBLogisticsViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}


@end

@implementation MBLogisticsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBLogisticsViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBLogisticsViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self show:@"加载中..."];
    self.titleStr = @"物流查询";
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -60, UISCREEN_WIDTH, UISCREEN_HEIGHT+110)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;

    //http://m.kuaidi100.com/index_all.html?type=yuantong&postid=806113789439

    NSURL *url1 = [NSURL  URLWithString:[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.type,self.postid]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url1];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    [self.view insertSubview:_webView atIndex:0];
    [self disableDropDown];
}
#pragma mark -- 禁用uiscorrow的下拉上拉弹起功能；
- (void)disableDropDown{
    for (id subview in _webView.subviews){
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
            
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark --UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    if (navigationType ==0|navigationType == 2) {
    
        return  NO;
    }
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView*)webView {
    //当网页视图已经开始加载一个请求后，得到通知。

    //    [self show];
}
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    //当网页视图结束加载一个请求之后，得到通知。

       [self dismiss];
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    NSLog(@"%@",error);
    [self show:@"加载失败" time:1];
}

@end
