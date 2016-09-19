//
//  MBArticleDetailViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBArticleDetailViewController.h"
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <JavaScriptCore/JavaScriptCore.h> //引入头文件
#import "ObjCModel.h"
#import "MBBabyWebController.h"
@interface MBArticleDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    BOOL _isArticle;
}
@end

@implementation MBArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self show:@"加载中..."];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor colorR:205 colorG:222 colorB:232];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}
-(NSString *)titleStr{
    return self.title;
}
- (NSString *)rightImage
{
    return @"mm_share";
}
-(void)rightTitleClick{
    
    [self share];
}
-(NSString *)leftStr{
    return @"";
}
-(NSString *)leftImage{
    return @"nav_back";
}

-(void)leftTitleClick{
    if (_webView.canGoBack) {
        [_webView goBack];
        
    }else{
        
        [self popViewControllerAnimated:YES];
    }
}
-(void)share{
    
    //1、创建分享参数
    NSArray* imageArray = _dataDic[@"imgs"];
    if (imageArray.count == 0) {
        imageArray = @[[UIImage imageNamed:@"headPortrait"]];
    }
    
    
    NSURL *url = self.url;
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.title
                                         images:imageArray
                                            url:url
                                          title:_dataDic[@"atype"]
                                           type:SSDKContentTypeAuto];
        UIImage *icon = [UIImage imageNamed:@"mm_noCollection"];
        if (_isArticle) {
            icon = [UIImage imageNamed:@"mm_collection"];
        }
        SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:icon
                                                                                      label:@"我的收藏"
                                                                                    onClick:^{
                                                                                        [self collection];

                                                                                                                                                                            }];
        NSArray * platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone),item];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil
                                 items:platforms
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
    }
    
    
}
- (void)loadData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/article/check_collect/") parameters:@{@"session":sessiondict,@"article_id":_dataDic[@"id"]} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 1) {
            _isArticle  = YES;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
    }];
    
}
- (void)collection{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/article/collect/") parameters:@{@"session":sessiondict,@"article_id":_dataDic[@"id"]} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        [self show:responseObject[@"info"] time:1];
        _isArticle  = !_isArticle;
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    
    
    
    //当网页视图结束加载一个请求之后，得到通知。
    
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 通过模型调用方法，这种方式更好些。
    ObjCModel *model  = [[ObjCModel alloc] init];
    context[@"xmbapp"] = model;
    model.jsContext = context;
    model.webView = _webView;
    @weakify(self);
    [[model.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
   
            MBBabyWebController *VC = [[MBBabyWebController alloc] init];
            NSString *params =  dic[@"params"];
            VC.url = URL([params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            VC.title = dic[@"topId"];
            [self pushViewController:VC Animated:YES];
           
            
        });
        
        
    }];
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        MMLog(@"异常信息：%@", exceptionValue);
    };
    
    
    [self dismiss];
    MMLog(@"11112233");
    [self loadData];
}



@end
