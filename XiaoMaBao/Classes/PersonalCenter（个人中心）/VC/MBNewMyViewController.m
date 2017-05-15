//
//  MBNewMyViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewMyViewController.h"
#import "MBNewMyViewCell.h"
#import "MBOrderListViewController.h"
#import "MBShoppingCartViewController.h"
#import "MBMyCollectionViewController.h"
#import "MBVoucherViewController.h"
#import "MBHistoryRecoderViewController.h"
#import "MBShopAddresViewController.h"
#import "MBHelpViewController.h"
#import "MBHelpViewController.h"
#import "MBVaccineViewController.h"
#import "MBRefundHomeController.h"
#import "MBHealthViewController.h"
#import "MBMyServiceController.h"
#import "MBElectronicCardOrderVC.h"
#import "MBSettingViewController.h"
#import "MBBabyCardController.h"

#import "MBCheckInViewController.h"
@interface MBNewMyViewController ()<UIScrollViewDelegate>
{
    /**
     *  数据
     */
    NSArray *_dataArray;
    
    /**
     *    是否从云客服界面退出,初始为0  4为退出
     */
    NSInteger _UnicallCount;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tabeleView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation MBNewMyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBPersonalSettingsViewController"];
  
  
        MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
        [_userImage sd_setImageWithURL:URL(userInfo.header_img) placeholderImage:[UIImage imageNamed:@"headPortrait"]];
        if (userInfo.sid) {
            _loginButton.hidden = YES;
            _userName.text = userInfo.nick_name;
        }else{
            _loginButton.hidden = NO;
            _userName.text = @"";
        }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tabeleView.tableFooterView = [[UIView alloc] init];
    _dataArray = @[
                   @{@"image":@"aMedicalQuery",@"name":@"体检报告查询"},
                   @{@"image":@"mabaoCard",@"name":@"我的麻包卡"},
                   @{@"image":@"InviteFriends",@"name":@"邀请好友",@"photo":@"立赚5元"},
                   @{@"image":@"star",@"name":@"我的收藏"},
                   @{@"image":@"icon2",@"name":@"热线电话",@"photo":@"010-85170751"},
                   @{@"image":@"icon3",@"name":@"收货地址"},
                   @{@"image":@"icon7",@"name":@"退换货"},
                   @{@"image":@"icon8",@"name":@"代金券"},
                   @{@"image":@"hempBeans",@"name":@"我的麻豆"},
                   @{@"image":@"icon5",@"name":@"联系我们"},
                   @{@"image":@"icon4",@"name":@"售后服务"},
                   @{@"image":@"icon6",@"name":@"麻包帮助"}
                   ];
    
}
- (IBAction)headViewBtn:(UIButton *)sender {
     NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
        [self  loginClicksss:@"mabao"];
        return;
    }
    switch (sender.tag) {
        case 0:{
            MBOrderListViewController *VC  = [[MBOrderListViewController alloc] init];
            [self pushViewController:VC Animated:true];
        }break;
        case 1:{
            [self performSegueWithIdentifier:@"MBMyServiceController" sender:nil];
        }break;
        case 2:{
            MBShoppingCartViewController *VC  = [[MBShoppingCartViewController alloc] init];
            [self pushViewController:VC Animated:true];
        }break;
        case 3:{
            [self performSegueWithIdentifier:@"MBElectronicCardOrderVC" sender:nil];
        }break;
        default:break;
    }
    
}

-(NSString *)titleStr{
    return @"个人中心";
}
-(NSString *)rightImage{
    return @"setup_image";
    
}
- (void)rightTitleClick{
    
    [MobClick event:@"PersonalCenter0"];
    if (self.isLogin) {
        MBSettingViewController *settingVc = [[MBSettingViewController alloc] init];
        
        
        [self pushViewController:settingVc Animated:true];
    }else{
        
        [self  loginClicksss:@"mabao"];
        return;
    }
}
- (IBAction)logIn:(id)sender {
     [self  loginClicksss:@"mabao"];
}

- (void)service{
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

-(NSString*)getCurrentTime {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"MBBabyCardController"]) {
        MBBabyCardController *VC = (MBBabyCardController *)segue.destinationViewController;
        VC.isJustLookAt = true;
    }


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
    
    
    [cell uiedgeInsetsZero];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    if (indexPath.row != 3||indexPath.row != 6||indexPath.row != 7||indexPath.row != 8) {
        if (!sid) {
            [self  loginClicksss:@"mabao"];
            
            return;
        }
    }
    
    switch (indexPath.row) {
        case 0:{
            
            [self performSegueWithIdentifier:@"MBMedicalReportQueryViewController" sender:nil];
        }break;
        case 1:{
            [self performSegueWithIdentifier:@"MBBabyCardController" sender:nil];
        }break;
        case 2:{
            [self performSegueWithIdentifier:@"MBInviteFriendsViewController" sender:nil];

        }break;
        case 3: {
            
            [MobClick event:@"PersonalCenter4"];
            MBMyCollectionViewController *VC =[[MBMyCollectionViewController alloc] init];
            [self pushViewController:VC Animated:YES];

        }break;
        case 4:{
            [MobClick event:@"PersonalCenter8"];
            NSString * telStr = [NSString stringWithFormat:@"telprompt://%@",@"010-85170751"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];

        }break;
        case 5:{
            [MobClick event:@"PersonalCenter9"];
            MBShopAddresViewController *VC = [[MBShopAddresViewController alloc] init];
            VC.isPersonalCenter = true;
            [self pushViewController:VC Animated:YES];
        }break;
        case 6:{
            
            [MobClick event:@"PersonalCenter5"];
            MBRefundHomeController *VC = [[MBRefundHomeController alloc] init];
            [self pushViewController:VC Animated:YES];
            [MobClick event:@"PersonalCenter11"];
          
        } break;
        case 7: {
            [MobClick event:@"PersonalCenter6"];
            MBVoucherViewController *VC =[[MBVoucherViewController alloc] init];
            [self pushViewController:VC Animated:YES];
        }break;
        case 8:{
            [MobClick event:@"PersonalCenter7"];
            [self performSegueWithIdentifier:@"MBMyMaBeanViewController" sender:nil];
        }break;
        case 9:{
            [self service];
        }break;
        case 10:{
            [MobClick event:@"PersonalCenter12"];
            MBHelpViewController *helpVC = [[MBHelpViewController alloc] init];
            helpVC.title = @"售后服务";
            helpVC.url =  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"after_sale_service" ofType:@"html" ]];
            [self pushViewController:helpVC Animated:YES];
            
        }break;
        case 11:{
            [MobClick event:@"PersonalCenter13"];
            MBHelpViewController *helpVC = [[MBHelpViewController alloc] init];
            helpVC.title = @"麻包帮助";
            helpVC.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"]];
            [self pushViewController:helpVC Animated:YES];
        }break;
        default:break;
    
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.mj_offsetY < 0) {
        scrollView.mj_offsetY = 0;
    }

}
@end
