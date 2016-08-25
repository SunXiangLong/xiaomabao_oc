//
//  MBPhoneticDetailViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPhoneticDetailViewController.h"
#import "MBPhoneticDetailTableViewController.h"
@interface MBPhoneticDetailViewController ()
{
    NSDictionary  *_dataDic;
}
@end

@implementation MBPhoneticDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
   
}

- (void)loadData{
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/index.php/voice/voice_detail") parameters:@{@"id":_ID} success:^(id responseObject) {
        [self dismiss];
        NSLog(@"%@",responseObject);
        MBPhoneticDetailTableViewController  *VC =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBPhoneticDetailTableViewController"];
        VC.dataDic = responseObject;
        _dataDic = responseObject;
        [self addChildViewController:VC];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT - TOP_Y)];
        [view addSubview:VC.view];
        [self.view addSubview:view];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
    }];
    
}
-(NSString *)titleStr{
  return @"语音详情";
}
- (NSString *)rightImage
{
return @"mm_share";
}
-(void)rightTitleClick{

    [self share];
}

-(void)share{
   
    //1、创建分享参数
    NSArray* imageArray = @[_dataDic[@"head_img"]];
    
    
    NSURL *url = URL(_dataDic[@"share_url"]);
    
    
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:string(string(_dataDic[@"author"], @"   "), _dataDic[@"author_title"])
                                         images:imageArray
                                            url:url
                                          title:_dataDic[@"abstract_text"]
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
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
