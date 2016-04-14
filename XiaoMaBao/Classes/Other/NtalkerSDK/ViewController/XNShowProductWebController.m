//
//  XNShowProductWebController.m
//  NTalkerUIKitSDK
//
//  Created by Ntalker on 15/12/14.
//  Copyright © 2015年 NTalker. All rights reserved.
//

#import "XNShowProductWebController.h"

@interface XNShowProductWebController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation XNShowProductWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBackButton];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    self.webView.delegate = self;
    
    NSURL *URL = [NSURL URLWithString:_productURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)configureBackButton
{
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_back_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backForward)];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}

- (void)backForward
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
}

@end
