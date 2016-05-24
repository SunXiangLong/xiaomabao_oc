//
//  MBRefundScheduleViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/5.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBRefundScheduleViewController.h"
#import "MBRefundScheduleTableViewCell.h"
#import "MobClick.h"

@class MBRefundHomeController;
@interface MBRefundScheduleViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSArray *_refundScheduleArray;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top1;


@property (weak, nonatomic) IBOutlet UILabel *order_id;
@property (weak, nonatomic) IBOutlet UILabel *refund_type;
@property (weak, nonatomic) IBOutlet UILabel *refund_reason;
@property (weak, nonatomic) IBOutlet UILabel *refund_money;
@property (weak, nonatomic) IBOutlet UILabel *refund_moneys;

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MBRefundScheduleViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBRefundScheduleViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBRefundScheduleViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self getRefundSchedule];
    _order_id.text    = _order_sn;
    _top.constant = TOP_Y;
}
- (void)setUI{
    self.titleStr = @"进度查询";
 
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
   
   
    _table.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRefundSchedule];
        [_table.mj_header endRefreshing];
    }];
  
   
}

#pragma mark --  请求申请进度的数据
- (void)getRefundSchedule{

  
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"refund/process"] parameters:@{@"session":sessiondict,@"order_id":_orderid}success:^(NSURLSessionDataTask *operation, id responseObject) {
         [self dismiss];
      //NSLog(@"退款进度查询成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);

        NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
        if (![dic[@"refund_type"] isEqualToString:@"退货"]) {
            _top1.constant = 10;
            [_refund_money removeFromSuperview];
            [_refund_moneys removeFromSuperview];
        }
        _refund_type.text =   dic[@"refund_type"];
        _refund_money.text =  dic[@"refund_money"];
        _refund_reason.text = dic[@"refund_reason"];
        
        _refundScheduleArray = dic[@"process"];
        
        
        [_table reloadData];
       
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
       [self show:@"请求失败！" time:1];
        NSLog(@"%@",error);
        
    }
     ];




}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_refundScheduleArray) {
        return _refundScheduleArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBRefundScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBRefundScheduleTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBRefundScheduleTableViewCell" owner:self options:nil]firstObject];
    }
    if (_refundScheduleArray) {
        cell.log_content.text = _refundScheduleArray[indexPath.row][@"log_content"];
        NSString *str = _refundScheduleArray[indexPath.row][@"log_time"];
        NSArray *arr = [str componentsSeparatedByString:@" "];
        cell.log_time1.text = arr[0];
        cell.log_time2.text = arr[1];
    }
    if (indexPath.row%2==0) {
        
        
        cell.backgroundColor = [UIColor colorWithHexString:@"faffd9"];
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:@"d2faf4"];
    }
     cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    NSArray *VCArray = self.navigationController.viewControllers;
  
    NSLog(@"%@",VCArray);
    
    
    
    if ([_type isEqualToString:@"1"]) {
                
        [self.navigationController popToViewController:VCArray[VCArray.count-3] animated:animated];  
        return nil;

        
    }else{
    
        return [self.navigationController popViewControllerAnimated:animated];

    }
    
}
@end
