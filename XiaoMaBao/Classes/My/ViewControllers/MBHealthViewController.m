//
//  MBHealthViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBHealthViewController.h"

@interface MBHealthViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation MBHealthViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBHealthViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBHealthViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self show:@"加载中..."];
    
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor colorR:205 colorG:222 colorB:232];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        sid = @"";
    }
    if (!uid) {
        uid  = @"";
    }
    NSString *body = [NSString stringWithFormat: @"session[uid]=%@&session[sid]=%@",uid,sid];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: self.url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [_webView loadRequest:request];//加载
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(NSString *)titleStr{
    
    return self.title?:@"";
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return nil;
    }
 return [self.navigationController popViewControllerAnimated:animated];
}
@end
