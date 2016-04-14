//
//  MBShopAddresViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBShopAddresViewController.h"
#import "MBShopAddressTableViewCell.h"
#import "MBNewAddressViewController.h"
@interface MBShopAddresViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *addressListArr;
@property (strong,nonatomic)NSDictionary *defaultDict;

@end

@implementation MBShopAddresViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBShopAddresViewController"];
    [self getaddressListWithtag:0];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBShopAddresViewController"];
    
}

    
    
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateReloadData:) name:@"updateDefaultAddress" object:nil];
   
}
-(void)UpdateReloadData:(NSNotification*)notif
{

    [self getaddressListWithtag:0];
    
}
- (IBAction)newaddress:(id)sender {
    MBNewAddressViewController *VC = [[MBNewAddressViewController alloc] init];
    [self pushViewController:VC Animated:YES];
}
- (NSString *)titleStr{
return @"收货地址";
}
-(void)getaddressListWithtag:(int) tag
{
    // 海淀区
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"address/list"] parameters:@{@"session":dict} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _addressListArr = [responseObject valueForKeyPath:@"data"];
        _defaultDict = [NSDictionary dictionary];
        
        for (NSDictionary *dict in _addressListArr) {
            if ([[dict valueForKeyPath:@"default_address"] intValue] == 1) {
                _defaultDict = dict;
                break;
            }
        }
      
        [_tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _addressListArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _addressListArr[indexPath.row];
    MBShopAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBShopAddressTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBShopAddressTableViewCell" owner:nil options:nil]firstObject];
    }
    cell.name.text = dic[@"consignee"];
    cell.photo.text = dic[@"mobile"];
    cell.address.text = [NSString stringWithFormat:@"%@-%@-%@-%@",dic[@"province_name"],dic[@"city_name"],dic[@"district_name"],dic[@"address"]];
    cell.addressDic = dic;
    cell.VC =self;
    if ([dic[@"default_address"] intValue] == 1) {
        cell.isDefault = YES;
        [cell.is_default setImage:[UIImage imageNamed:@"pitch_on"] forState:UIControlStateNormal];
    }

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (!self.PersonalCenter) {
        NSDictionary *dict = [_addressListArr objectAtIndex:indexPath.row];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"AddressNOtifition" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self popViewControllerAnimated:YES];
    }
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDefaultAddress" object:nil];
}


@end
