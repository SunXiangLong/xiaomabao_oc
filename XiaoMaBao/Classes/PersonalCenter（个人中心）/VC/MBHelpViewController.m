//
//  MBHelpViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/4/6.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBHelpViewController.h"

@interface MBHelpViewController ()

@end

@implementation MBHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *serviceView = [[UIView alloc] init];
    serviceView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height);
    serviceView.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,TOP_Y,self.view.bounds.size.width,self.view.bounds.size.height-TOP_Y)];
    [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    [self.view addSubview:webView];
}
- (NSString *)titleStr{
    return  self.title;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
