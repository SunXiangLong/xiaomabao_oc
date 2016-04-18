//
//  MBServiceDetailsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceDetailsViewController.h"
#import "MBSubmitOrdersController.h"
@interface MBServiceDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation MBServiceDetailsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBServiceDetailsViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBServiceDetailsViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
      [self show:@"加载中..."];
    self.button.hidden   = YES;
     _webView.scalesPageToFit = YES;
    NSString *url =[NSString stringWithFormat:@"%@%@%@",BASE_URL_SHERVICE,@"service/product_preview/",self.product_id];

    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    [self.view insertSubview:_webView atIndex:0];

}



- (IBAction)buy:(id)sender {
    MBSubmitOrdersController *VC = [[MBSubmitOrdersController alloc] init];
    VC.product_id = self.product_id;
    [self pushViewController:VC Animated:YES];
}

- (NSString *)titleStr{
   return @"产品详情";

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 禁用uiscorrow的下拉上拉弹起功能；
- (void)disableDropDown{
    for (id subview in _webView.subviews){
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
            
        }
        
    }
    
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
       self.button.hidden   =  NO;
    [self dismiss];
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    NSLog(@"%@",error);
    [self show:@"加载失败" time:1];
}


@end
