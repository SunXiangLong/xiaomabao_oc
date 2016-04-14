//
//  MBVaccineViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBVaccineViewController.h"
#import "MBBabySearchViewController.h"
@interface MBVaccineViewController ()
{

}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MBVaccineViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBVaccineViewController"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBVaccineViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self show:@"加载中..."];
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor colorR:205 colorG:222 colorB:232];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        sid = @"";
    }
    if (!uid) {
        uid  = @"";
    }
    NSString *body = [NSString stringWithFormat: @"session[uid]=%@&session[sid]=%@",uid,sid];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: self.url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [_webView loadRequest:request];//加载

}
#pragma mark -- 禁用uiscorrow的下拉上拉弹起功能；
- (void)disableDropDown{
    for (id subview in _webView.subviews){
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark --UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    
    NSURL *url = request.mainDocumentURL;
    NSString *str = [NSString stringWithFormat:@"%@",url];
    NSString *str1 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *arr = [str1 componentsSeparatedByString:@"_title_"];
    NSLog(@"%@",str);
    
    if ([url isEqual:_url]) {
        return YES;
    }else{
        
        
        MBVaccineViewController *VC = [[MBVaccineViewController alloc] init];
        VC.url = url;
        VC.title = arr.lastObject?arr.lastObject:@"疫苗纪录";
        [self pushViewController:VC Animated:YES];
        return NO;
    }
    
    
    
}
-(void)webViewDidStartLoad:(UIWebView*)webView {
    //当网页视图已经开始加载一个请求后，得到通知。
    
    //    [self show];
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
-(NSString *)titleStr{

    return self.title?:@"疫苗纪录";
}

-(NSString *)rightImage{
    if (self.isSearch) {
        return @"search_image";
    }else{
        return nil;
    }

    
}
-(void)rightTitleClick{

    if (self.isSearch) {
        MBBabySearchViewController *VC = [[MBBabySearchViewController alloc] init];
        NSString *str = [NSString stringWithFormat:@"%@%@",BASE_PHP,@"/knowledge_search/ios/"];
        VC.url = [NSURL URLWithString:str];
        VC.urlstr = str;
        VC.isSearch = YES;
        
        [self pushViewController:VC   Animated:YES];
    }

}
@end
