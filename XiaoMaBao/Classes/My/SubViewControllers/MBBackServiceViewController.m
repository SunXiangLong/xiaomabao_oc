//
//  MBBackServiceViewController.m
//  XiaoMaBao
//
//  Created by 郝人 on 15/9/22.
//  Copyright (c) 2015年 HuiBei. All rights reserved.
//

#import "MBBackServiceViewController.h"


@interface MBBackServiceViewController ()
@end

@implementation MBBackServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    UIView *serviceView = [[UIView alloc] init];
    serviceView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height);
    serviceView.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,TOP_Y,self.view.bounds.size.width,self.view.bounds.size.height-TOP_Y)];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"after_sale_service" ofType:@"html" inDirectory:@"www"]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];

    [self.view addSubview:webView];
}

- (NSString *)titleStr{
    return @"售后服务";
}

@end

