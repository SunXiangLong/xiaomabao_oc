//
//  MBReceiptAddressViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/11.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBReceiptAddressViewController.h"
#import "MBReceiptAddressTableViewCell.h"
#import "MBAddAddressViewController.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
#import "MobClick.h"
@interface MBReceiptAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *addressListArr;
//@property (strong,nonatomic)NSMutableArray *UndefaultArray;
@property (strong,nonatomic)NSDictionary *defaultDict;
@end

@implementation MBReceiptAddressViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - 45) style:UITableViewStyleGrouped];
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        tableView.contentInset = UIEdgeInsetsMake(MARGIN_8, 0, 0, 0);
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self,tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"MBReceiptAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBReceiptAddressTableViewCell"];
//        tableView.tableFooterView = [self footerView];
        [self.view addSubview:_tableView = tableView];
        [self.view addSubview:[self footerView]];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBReceiptAddressViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBReceiptAddressViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getaddressListWithtag:0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReloadData:) name:@"deleteAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReloadData:) name:@"AddOrUpdateAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateReloadData:) name:@"updateDefaultAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editAddress:) name:@"editAddress" object:nil];
}

//删除更新
-(void)deleteReloadData:(NSNotification*)notif
{
    NSLog(@"%@",[notif userInfo]);
    [self getaddressListWithtag:1];
   
}

-(void)UpdateReloadData:(NSNotification*)notif
{
    NSLog(@"%@",[notif userInfo]);
    [self getaddressListWithtag:1];

}

-(void)editAddress:(NSNotification*)notif
{

    NSDictionary *myaddressinfo = [notif userInfo];
    
    MBAddAddressViewController *addressVc = [[MBAddAddressViewController alloc] init];
    addressVc.TheTitle = @"编辑收货地址";
   
    
    
    NSMutableArray *infoarray  = [NSMutableArray array];
    NSString *consignee =[myaddressinfo valueForKeyPath:@"consignee"] ;
   
    NSString *mobile;
    if ([[myaddressinfo valueForKeyPath:@"mobile"] isKindOfClass:[NSArray class]]) {
        mobile =[[myaddressinfo valueForKeyPath:@"mobile"] objectAtIndex:0];
    }else
    {
        mobile =[myaddressinfo valueForKeyPath:@"mobile"];
    }
    
    
     NSString *province_name =[myaddressinfo valueForKeyPath:@"province_name"];
     NSString *city_name = [myaddressinfo valueForKeyPath:@"city_name"];
     NSString *district_name =[myaddressinfo valueForKeyPath:@"district_name"];
     NSString *address =[myaddressinfo valueForKeyPath:@"address"];
    if ([[myaddressinfo valueForKeyPath:@"consignee"] isKindOfClass:[NSNull class]]) {
        province_name = @"";
        
    }
    if ([[myaddressinfo valueForKeyPath:@"province_name"] isKindOfClass:[NSNull class]]) {
        province_name = @"";
    }
    if ([[myaddressinfo valueForKeyPath:@"city_name"] isKindOfClass:[NSNull class]]) {
        city_name = @"";
    }
    if ([[myaddressinfo valueForKeyPath:@"district_name"] isKindOfClass:[NSNull class]]) {
        district_name = @"";
    }
    if ([[myaddressinfo valueForKeyPath:@"address"] isKindOfClass:[NSNull class]]) {
        address = @"";
    }
    
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",province_name,city_name,district_name];
    [infoarray addObject:consignee];
    [infoarray addObject:mobile];
    [infoarray addObject:str];
    [infoarray addObject:address];
    addressVc.infoArray = infoarray;
    addressVc.address_id  = myaddressinfo[@"ID"];
    
    [self.navigationController pushViewController:addressVc animated:YES];
//    [self goAddressVc];
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
      
        NSLog(@"%@",_addressListArr);
        for (NSDictionary *dict in _addressListArr) {
            if ([[dict valueForKeyPath:@"default_address"] intValue] == 1) {
                _defaultDict = dict;
                break;
            }
        }
        if (_tableView) {
            [_tableView reloadData];
        }else{
            [self tableView];
        }
        
//        if (_addressListArr.count) {
//            if (tag == 0) {
//                [self tableView];
//            }else if (tag == 1)
//            {
//                [_tableView reloadData];
//            }
//        }else{
//            _tableView =  [self tableView];
//
//        }
//    _tableView =  [self tableView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];

}
- (UIView *)footerView{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.frame = CGRectMake(0, self.view.ml_height - 45, self.view.ml_width, 45);
    
    UIImage *Image = [UIImage imageNamed:@"address_add"] ;
    UIImageView *imageview = [[UIImageView alloc ]init];
    imageview.image = Image;
    imageview.frame = CGRectMake(10, 12, 20, 20);
    [footerView addSubview:imageview];

    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.frame = CGRectMake(self.view.ml_width - 100 - MARGIN_8, 0, 100, footerView.ml_height);
    [addAddressBtn setTitleColor:[UIColor colorWithHexString:@"2ba390"] forState:UIControlStateNormal];
    addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addAddressBtn setTitle:@"添加新收货地址" forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(goAddressVc) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addAddressBtn];
    
    [self addTopLineView:footerView];
    return footerView;
}

- (void)goAddressVc{
    MBAddAddressViewController *addressVc = [[MBAddAddressViewController alloc] init];
    addressVc.TheTitle = @"添加新收货地址";
    [self.navigationController pushViewController:addressVc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _addressListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1?: 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, self.view.ml_width, 0);
    return sectionView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBReceiptAddressTableViewCell";
    MBReceiptAddressTableViewCell *cell = (MBReceiptAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < _addressListArr.count) {
        cell.consigneeName.text = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"consignee"];
        NSString *province_name = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"province_name"];
        NSString *city_name = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"city_name"];

        NSString *district_name = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"district_name"];
        NSString *address = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"address"];
        cell.address.text = [NSString stringWithFormat:@"%@%@%@",province_name,district_name,address];
        cell.mobile.text = [NSString stringWithFormat:@"电话:%@",[[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"mobile"]];
         cell.address_id = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"id"];
        cell.province_name = province_name;
        cell.myaddress = address;
        cell.city_name = city_name;
        cell.mymobile = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"mobile"];
        cell.district_name = district_name;
        cell.consignee = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"consignee"];
        cell.isDefault = YES;
        cell.cellIndex = (NSInteger)indexPath.row;
        NSString *default_address = [[_addressListArr objectAtIndex:indexPath.row] valueForKeyPath:@"default_address"];
        if ([default_address intValue] == 1) {
            cell.isDefault = YES;
            [cell.DefaultButton setImage:[UIImage imageNamed:@"pitch_on"] forState:UIControlStateNormal];
        }else{
            [cell.DefaultButton setImage:[UIImage imageNamed:@"pitch_no"] forState:UIControlStateNormal];
        }
        
        if (!cell.cellIndex) {
            cell.cellIndex = 0;
        }

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (NSString *)titleStr{
    return @"收货地址";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_addressListArr objectAtIndex:indexPath.row];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"AddressNOtifition" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
