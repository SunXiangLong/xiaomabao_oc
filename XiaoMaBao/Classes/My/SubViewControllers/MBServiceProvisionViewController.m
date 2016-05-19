//
//  MBBackServiceViewController.m
//  XiaoMaBao
//
//  Created by 郝人 on 15/9/22.
//  Copyright (c) 2015年 HuiBei. All rights reserved.
//

#import "MBServiceProvisionViewController.h"


@interface MBServiceProvisionViewController ()
@end

@implementation MBServiceProvisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    UIView *serviceView = [[UIView alloc] init];
    serviceView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height);
    serviceView.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,TOP_Y,self.view.bounds.size.width,self.view.bounds.size.height-TOP_Y)];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"service_provision" ofType:@"html" inDirectory:@"www"]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];

    [self.view addSubview:webView];
}

- (NSString *)titleStr{
    return @"服务条款";
}

@end

