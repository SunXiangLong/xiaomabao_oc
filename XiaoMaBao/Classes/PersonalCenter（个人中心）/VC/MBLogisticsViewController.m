//
//  MBLogisticsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBLogisticsViewController.h"
#import "MBLogOperation.h"
#import <WebKit/WebKit.h>
@interface MBLogisticsViewController ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) UIProgressView *progressView;
@end

@implementation MBLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI{
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
    _progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
//    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:_progressView];
    
    self.titleStr = @"物流查询";
    [MBLogOperation deleteCookie];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -60, UISCREEN_WIDTH, UISCREEN_HEIGHT+110)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    //http://m.kuaidi100.com/index_all.html?type=yuantong&postid=806113789439
    NSURL *url1 = [NSURL  URLWithString:[[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.type,self.postid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url1] ;//创建NSURLRequest
    [_webView loadRequest:request];//加载
    [self.view insertSubview:_webView atIndex:0];

    
    @weakify(self);
    [RACObserve(self.webView, estimatedProgress) subscribeNext:^(id x) {
        @strongify(self)
         self.progressView.progress = self.webView.estimatedProgress;
      
        if (self.progressView.progress == 1) {
            
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
               self.progressView.hidden = YES;
                
            }];
        }
        
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSString *)leftStr{
  return @"";
}
- (NSString *)leftImage
{
return @"nav_back";
}
-(void)leftTitleClick{
    if (self.isOrderDetails) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
    
        [self popViewControllerAnimated:YES];
    }
}
@end
