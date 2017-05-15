//
//  MBMedicalReporTQueryResultsViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/5/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBMedicalReporTQueryResultsViewController.h"

@interface MBMedicalReporTQueryResultsViewController ()
{
    BOOL _isHideNavBar;

}
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation MBMedicalReporTQueryResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:self.navBar];
    
    if (_url) {
        [self show];
        NSURLRequest *request = [NSURLRequest requestWithURL:_url ];
        //设置缩放
        [self.webview setScalesPageToFit:YES];
        [self.webview loadRequest:request];
    }else{
        _webview.hidden = true;
        self.view.userInteractionEnabled  = false;
    }

   
}
- (IBAction)hide:(UIGestureRecognizer *)sender {
    
    [UIView animateWithDuration:.5 animations:^{
        if (_isHideNavBar) {
           self.navBar.mj_y = 0;
        }else{
            self.navBar.mj_y = -64;
        }
        
    } completion:^(BOOL finished) {
        _isHideNavBar = !_isHideNavBar;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}-(NSString *)titleStr{
    return @"查询结果";
}
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    //当网页视图结束加载一个请求之后，得到通知。
    [self dismiss];
    
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    //当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类
    MMLog(@"%@",error);
    [self show:error.userInfo[@"NSLocalizedDescription"] time:1];
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
