//
//  MBWebViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBWebViewController.h"

@interface MBWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MBWebViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBWebViewController"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBWebViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self show:@"加载中..."];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor colorR:205 colorG:222 colorB:232];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: self.url];
    [_webView loadRequest:request];
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
    
    [self dismiss];
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    NSLog(@"%@",error);
    [self show:@"加载失败" time:1];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return nil;
    }
    return [self.navigationController popViewControllerAnimated:animated];
}
@end
