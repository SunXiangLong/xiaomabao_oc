//
//  MBBackServiceViewController.m
//  XiaoMaBao
//
//  Created by 郝人 on 15/9/22.
//  Copyright (c) 2015年 HuiBei. All rights reserved.
//

#import "MBOnlineServiceViewController.h"

@interface MBOnlineServiceViewController ()
@end

@implementation MBOnlineServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    UIView *serviceView = [[UIView alloc] init];
    serviceView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height);
    serviceView.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,TOP_Y,self.view.bounds.size.width,self.view.bounds.size.height-TOP_Y)];

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"online_service" ofType:@"html" inDirectory:@"www"]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];

    [self.view addSubview:webView];
    
//     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//     btn.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
//     btn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitle:@"在线客服" forState:UIControlStateNormal];
//     btn.layer.cornerRadius = 3.0f;
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(service) forControlEvents:  UIControlEventTouchUpInside];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(webView.mas_centerX).offset(0);
//        make.bottom.mas_equalTo(-100);
//        make.size.mas_equalTo(CGSizeMake(100, 50));
//    }];
    
    
}
-(NSString*)rightImage{
 return @"service_1";

}
-(void)rightTitleClick{
   

}
- (NSString *)titleStr{
    return @"在线客服";
}

@end

