//
//  MBOrderInfoTableViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBOrderInfoTableViewController.h"
#import "MBOrderInfoTableViewCell.h"

@interface MBOrderInfoTableViewController ()
{
    NSDictionary *_dataDic;
}
@end

@implementation MBOrderInfoTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView  = [[UIView alloc] init];
    
    [self getOrderInfo];
   
}


- (void)getOrderInfo{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/order/order_detail_new"];
    NSDictionary *parameters ;
    if (_order_id) {
        url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/order/order_detail"];
        parameters  = @{@"session":dict,@"order_id":self.order_id};
    } else if(_parent_order_sn){
        parameters = @{@"session":dict,@"order_sn":self.parent_order_sn};
    
    }
    

    [MBNetworking POST:url parameters:parameters  success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        [self dismiss];
        NSDictionary * status = [responseObject valueForKeyPath:@"status"];
        if([status[@"succeed"] isEqualToNumber:@1]){
           _dataDic = [responseObject valueForKeyPath:@"data"];
            MMLog(@"%@",_dataDic);
            [self.tableView reloadData];
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
        MMLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (!_dataDic) {
        return 0;
    }
    if([_dataDic[@"order_status"] isEqualToString:@"shipped"]||[_dataDic[@"order_status"] isEqualToString:@"finished"]){
    
        return 4;
    }else{
        return 3;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
    case 0:
            return 1;
    case 1:
            return 1;
    case 2:
            return [_dataDic[@"goods_list"] count];
    default:
            return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
    case 0:
            return 80;
    case 1:
            return 290;
    case 2:
            return 100;
    default:
            return 70;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0001;
    }
    return 5;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    switch (indexPath.section) {
        case 0:
        {
            MBOrderInfoTableViewOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBOrderInfoTableViewOneCell"];
            cell.dataDic = _dataDic;
            return cell;
        }
        case 1:
        {
            MBOrderInfoTableViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBOrderInfoTableViewTwoCell"];
            cell.dataDic = _dataDic;
            return cell;
        }
        case 2:
        {
            MBOrderInfoTableViewThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBOrderInfoTableViewThreeCell"];
            cell.dataDic = _dataDic[@"goods_list"][indexPath.row];
            return cell;
        }
        default:
        {
            MBOrderInfoTableViewFourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBOrderInfoTableViewFourCell"];
            cell.dataDic = _dataDic;
            cell.VC = self;
            return cell;
        }
    }
}





@end
