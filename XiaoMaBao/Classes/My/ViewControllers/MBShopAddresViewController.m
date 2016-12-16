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
@interface MBShopAddresViewController ()<UITableViewDelegate,UITableViewDataSource,MBShopAddressTableViewDelgate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSArray *addressListArr;
@end
@implementation MBShopAddresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [[UIView  alloc ] init];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [self getaddressListWithtag];
}
- (IBAction)newaddress:(id)sender {
    MBNewAddressViewController *VC = [[MBNewAddressViewController alloc] init];
    [self pushViewController:VC Animated:YES];
}
- (NSString *)titleStr{
    return @"收货地址";
}
-(void)getaddressListWithtag
{
    [self show];
    // 海淀区
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/address/address_list"] parameters:@{@"session":dict} success:^(NSURLSessionDataTask *operation, id responseObject) {
        MMLog(@"%@",responseObject);
        [self dismiss];
        _addressListArr = [responseObject valueForKeyPath:@"data"];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
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
    return 116;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _addressListArr[indexPath.row];
    MBShopAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBShopAddressTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBShopAddressTableViewCell" owner:nil options:nil]firstObject];
    }
    [cell uiedgeInsetsZero];
    cell.name.text = dic[@"consignee"];
    cell.photo.text = dic[@"mobile"];
    cell.address.text = [NSString stringWithFormat:@"%@-%@-%@-%@",dic[@"province_name"],dic[@"city_name"],dic[@"district_name"],dic[@"address"]];
    cell.addressDic = dic;
    MMLog(@"%@",dic);
    cell.VC =self;
    cell.delagate =self;
    if ([dic[@"is_default"] intValue] == 1) {
        cell.isDefault = YES;
        [cell.is_default setImage:[UIImage imageNamed:@"pitch_on"] forState:UIControlStateNormal];
    }

    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.PersonalCenter) {
        [self popViewControllerAnimated:YES];
        NSDictionary *dict = [_addressListArr objectAtIndex:indexPath.row];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"AddressNOtifition" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
       
    }
    
}
#pragma mark --MBShopAddressTableViewDelegate
-(void)MBShopAddressTableView{
  [self getaddressListWithtag];
}



@end
