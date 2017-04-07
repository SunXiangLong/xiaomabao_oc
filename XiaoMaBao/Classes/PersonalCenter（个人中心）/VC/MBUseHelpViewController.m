//
//  MBUseHelpViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBUseHelpViewController.h"

@interface MBUseHelpViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation MBUseHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self show];
    NSURL *url = [NSURL URLWithString:string(@"http://api.xiaomabao.com", @"/agreement/bean")];
    
    if (_URL) {
        url = self.URL;
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}
-(NSString *)titleStr{
    return self.title? self.title:@"麻豆使用帮助";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismiss];
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
