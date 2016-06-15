//
//  MBNewMyViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewMyViewController.h"
#import "MBNewMyViewCell.h"
#import "MBNewMyViewHeadView.h"
#import "MBSettingViewController.h"
#import "MBLoginViewController.h"
#import "DataSigner.h"
#import "MBOrderListViewController.h"
#import "MBShoppingCartViewController.h"
#import "MBMyCollectionViewController.h"
#import "MBVoucherViewController.h"
#import "MBHistoryRecoderViewController.h"
#import "MBShopAddresViewController.h"
#import "MBBackServiceViewController.h"
#import "MBHelpServiceViewController.h"
#import "MBVaccineViewController.h"
#import "MBRefundHomeController.h"
#import "MBHealthViewController.h"
#import "MBMyServiceController.h"
@interface MBNewMyViewController ()
{
    /**
     *  数据
     */
    NSArray *_dataArray;
    
    BOOL  _isbool;
    
    /**
     *    是否从云客服界面退出,初始为0  4为退出
     */
    NSInteger _UnicallCount;
  
}
@property (weak, nonatomic) IBOutlet UITableView *tabeleView;

@end

@implementation MBNewMyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBPersonalSettingsViewController"];
    
    if (!_isbool) {
        
        _tabeleView.tableHeaderView = ({
            
            UIView *view = [[UIView   alloc] init];
            view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 234);
            MBNewMyViewHeadView *headView = [MBNewMyViewHeadView instanceView];
            headView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 234);
            [view addSubview:headView];
            MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
            headView.user_name.text =  userInfo.nick_name;
            [headView.user_image sd_setImageWithURL:URL(userInfo.header_img) placeholderImage:[UIImage imageNamed:@"headPortrait"]];
            if (userInfo.sid) {
                headView.login_button.hidden = YES;
            }else{
                headView.login_button.hidden = NO;
            }
            @weakify(self);
            [[headView.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *x) {
                @strongify(self);
                
                switch ([x integerValue]) {
                    case 0: {
                        MBOrderListViewController *VC = [[MBOrderListViewController alloc] init];
                        [self.navigationController pushViewController:VC animated:YES];}break;
                    case 1:{
                        MBMyServiceController *VC  = [[MBMyServiceController alloc] init];
                        [self pushViewController:VC Animated:YES];
                    }break;
                    case 2: {
                        MBShoppingCartViewController *VC =[[MBShoppingCartViewController alloc] init];
                        VC.showBottomBar = @"yes";
                        [self pushViewController:VC Animated:YES];
                    }  break;
                    case 3:{
                        MBMyCollectionViewController *VC =[[MBMyCollectionViewController alloc] init]; [self pushViewController:VC Animated:YES];}  break;
                    default:[self loginClicksss];
                        
                        break;
                }

                
            }];
            
           
            
            view;
        });
}
    
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabeleView.tableFooterView = [[UIView alloc] init];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBadge:) name:@"messageBadge" object:nil];
    _dataArray = @[@{@"image":@"icon1",@"name":@"浏览记录"},
                 @{@"image":@"icon2",@"name":@"热线电话",@"photo":@"400-136-7282"},
                 @{@"image":@"icon3",@"name":@"收货地址"},
                 @{@"image":@"icon4",@"name":@"售后服务"},
                 @{@"image":@"icon5",@"name":@"联系我们"},
                 @{@"image":@"icon6",@"name":@"麻包帮助"},
                 @{@"image":@"icon7",@"name":@"退换货"},
                 @{@"image":@"icon8",@"name":@"代金券"},
                 ];

}
- (void)messageBadge:(NSNotification *)notificat{
    NSString *messageNumber = [User_Defaults objectForKey:@"messageNumber"];
    if (messageNumber&&[messageNumber intValue]>0 ) {
        [self.messageBadge autoBadgeSizeWithString:messageNumber];
        self.messageBadge.hidden = NO;
    }else{
        self.messageBadge.hidden = YES;
    }
    
    
}
-(NSString *)titleStr{
    return @"个人中心";
}
-(NSString *)rightImage{
    return @"setup_image";
    
}

- (void)rightTitleClick{
    
//    NSNotification *messageBadge =[NSNotification notificationWithName:@"messageBadge" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:messageBadge];
    _isbool = NO;
    if (self.isLogin) {
        MBSettingViewController *settingVc = [[MBSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVc animated:YES];
    }else{
        
        [self loginClicksss];
        return;
        
    }
    
    
    
}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    _isbool  = NO;
    //跳转到登录页
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)service{
    [[Unicall singleton] attach:self appKey:UNICALL_APPKEY tenantId:UNICALL_TENANID];
    NSDictionary *itemInfo = @{
                               @"title" :@"",
                               @"desc" :@"",
                               @"iconUrl" :@"",
                               @"url" :@""
                               };
    [[Unicall singleton] UnicallShowView:itemInfo];
    
    
}
-(void)getUnicallSignature{
    NSString *privateKey =  [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             @"MIIBPAIBAAJBAMBrqadzplyUtQUXCP+VuDFWt0p9Kl+s3yrQ8PV+P89Bbt/UqN2/",
                             @"BzVNPoNgtQ2fI7Ob652limC/jqVf6slzPEUCAwEAAQJAOL7HXnGVqxHTvHeJmM4P",
                             @"bsVy8k2tNF/nxFmv5cXgjX7sd7BU9jyELGP4os3ID3tItdCHtmMM3KM91lTHYlkk",
                             @"dQIhAOWKnz0moWISa0S8cBYJI0k0PRoYMv6Xsty5aZpC9WM/AiEA1pmqSthbMUb2",
                             @"TrmRyJsHswLAYSHotTIS0kzHu655M3sCIQDLdWXUJCuj7EOcd5K6VXsrZdxLBuwc",
                             @"coYd01LhYzxyrQIhAIsqc6i9zcWTAz/iT4wMHV4VNrTGzKZUpqgCarRnXOnpAiEA",
                             @"pbZzKKXpVGNp2MMXRlpdzdGCKFMYSeqnqXuwd76iwco="
                             ];
    NSString *tenantId = UNICALL_TENANID;
    NSString *appKey = UNICALL_APPKEY;
    NSString *time = [self getCurrentTime];
    NSString *expireTime = @"60000";
    
    NSString *stringToSign = [NSString stringWithFormat:@"%@&%@&%@&%@",appKey,expireTime,tenantId,time];
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
    NSString *signature = [signer uncallString:stringToSign];
    NSDictionary *json = @{@"appKey":appKey,@"expireTime":expireTime,@"signature":signature,@"tenantId":tenantId,@"time":time};
    
    Unicall *unicall = [Unicall singleton];
    [unicall UnicallUpdateValidation:json];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
        [unicall UnicallUpdateUserInfo:@{@"nickname":@"未注册用户"}];
    }else{
        
        [unicall UnicallUpdateUserInfo:@{@"nickname": string(@"用户的sid:", sid)}];
    }
}
//delegate methods
-(void)acquireValidation
{
    [self getUnicallSignature];
}
-(void)messageCountUpdated:(NSNumber*) data
{
    NSLog(@"count%@:",data);
    
}
-(void)messageArrived:(NSDictionary*) data
{
    NSError* error = nil;
    NSData* source = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSString* str = [NSJSONSerialization JSONObjectWithData:source options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@%@",@"Unicall message arrived.",str);
    
    if([[data objectForKey:@"eventName"] isEqualToString:@"updateNewMessageCount"])
        NSLog(@"count%@:",data);
}
-(UIViewController*) currentViewController
{
    if (_UnicallCount ==0) {
        self.tabBarController.tabBar.hidden = YES;
    }
    _UnicallCount++;
    if (_UnicallCount ==4) {
        self.tabBarController.tabBar.hidden = NO;
        _UnicallCount =0;
    }
    return self;
}
-(NSString*)getCurrentTime {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    MBNewMyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewMyViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewMyViewCell"owner:nil options:nil]firstObject];
    }
    cell.user_image.image = [UIImage imageNamed:dic[@"image"]];
    cell.user_tiele.text = dic[@"name"];
    cell.user_photo.text = dic[@"photo"];

    
    [self setUIEdgeInsetsZero:cell];
    
    return cell;
    
}
/**
 *  让cell地下的边线挨着左边界
 */
- (void)setUIEdgeInsetsZero:(UITableViewCell *)cell{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins   = false;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    switch (indexPath.row) {
        case 0:{
            if (!sid) {
                [self loginClicksss];
                
                return;
            }
            MBHistoryRecoderViewController *VC = [[MBHistoryRecoderViewController alloc] init];
            [self pushViewController:VC Animated:YES];
        }break;
        case 1: {//拨打电话号码
            NSString * telStr = [NSString stringWithFormat:@"telprompt://%@",@"400-136-728"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        }break;
        case 2:{
            if (!sid) {
                [self loginClicksss];
                return;
            }
            MBShopAddresViewController *VC = [[MBShopAddresViewController alloc] init];
            VC.PersonalCenter = @"yes";
            [self pushViewController:VC Animated:YES];}break;
        case 3:{
            
            MBBackServiceViewController *VC = [[MBBackServiceViewController alloc] init];
            [self pushViewController:VC Animated:YES];}break;
        case 4: [self service]; break;
        case 5: {MBHelpServiceViewController *VC = [[MBHelpServiceViewController alloc] init];
            [self pushViewController:VC Animated:YES];}break;
        case 6: {
            if (!sid) {
                [self loginClicksss];
                
                return;
            }
            
            MBRefundHomeController *VC = [[MBRefundHomeController alloc] init];
            [self pushViewController:VC Animated:YES];}break;
        default:{
            if (!sid) {
                [self loginClicksss];
                
                return;
            }
            MBVoucherViewController *VC =[[MBVoucherViewController alloc] init]; [self pushViewController:VC Animated:YES];}
            break;
    }
}


@end
