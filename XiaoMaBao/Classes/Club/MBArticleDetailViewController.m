//
//  MBArticleDetailViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBArticleDetailViewController.h"
#import <WebKit/WebKit.h>
@interface MBArticleDetailViewController ()<WKNavigationDelegate,WKUIDelegate>
{
   WKWebView *_webView;
}
@end

@implementation MBArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self show:@"加载中..."];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    [self.view addSubview:_webView];
}
-(NSString *)titleStr{
    return self.title;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"%@",error);
    [self show:@"加载失败" time:1];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self dismiss];
}
-(NSString *)leftStr{
    return @"";
}
-(NSString *)leftImage{
return @"nav_back";
}
-(void)leftTitleClick{
    if (_webView.canGoBack) {
        [_webView goBack];
        
    }else{
        
        [self popViewControllerAnimated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
