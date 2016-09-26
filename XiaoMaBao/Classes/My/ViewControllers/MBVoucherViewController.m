//
//  MBVoucherViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBVoucherViewController.h"
#import "MBLoginViewController.h"
#import "MBVoucherTableViewCell.h"
#import "MBFireOrderViewController.h"
#import "MobClick.h"
@interface MBVoucherViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int  _i;
}
@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *couponList;
@end

@implementation MBVoucherViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor =BG_COLOR;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MBVoucherTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBVoucherTableViewCell"];
        tableView.dataSource = self,tableView.delegate = self;
        tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y);
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if(self.is_fire && [self.is_fire isEqualToString:@"yes"]){
        [self getFireCouponList:self.order_money];
    }else{
        [self getCouponList];
    }
   
    
}

-(void)getCouponList
{
   
    if(!_couponList){
        _couponList = [NSMutableArray array];
    }
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    if (sid == nil && uid == nil) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        MBLoginViewController *myViewVc = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
        myViewVc.vcType = @"shop";
        [self.navigationController pushViewController:myViewVc animated:YES];
        return;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/discount/get_user_coupon"] parameters:@{@"session":dict} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        _couponList = [responseObject valueForKeyPath:@"data"];
        
        if (_couponList.count>0) {
            if(_tableView){
                [_tableView reloadData];
            }else{
                [self tableView];
            }
        }else{
       
            self.stateStr = @"你没有可用的代金劵" ;
        
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
}

-(void)getFireCouponList:(NSString *)order_money
{
    
    if(!_couponList){
        _couponList = [NSMutableArray array];
    }
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    if (sid == nil && uid == nil) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        MBLoginViewController *myViewVc = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
        myViewVc.vcType = @"shop";
        [self.navigationController pushViewController:myViewVc animated:YES];
        return;
    }
    [self show];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/discount/get_coupon_enable"] parameters:@{@"session":dict,@"order_money":order_money} success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        [self dismiss];
        _couponList = [responseObject valueForKeyPath:@"data"];
        if (_couponList.count>0) {
            if( !_tableView){
                [self tableView];
            }
            
        }else{
            
            self.stateStr = @"你没有可用的代金劵" ;
            
        }

          [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
       [self show:@"请求失败" time:1];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_couponList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBVoucherTableViewCell";
    MBVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    NSDictionary * coupon = _couponList[indexPath.row];
    cell.coupon_name.text = [NSString stringWithFormat:@" %@",coupon[@"type_name"]];
    NSTimeInterval startDate_ = [coupon[@"use_start_date"] doubleValue];
    NSTimeInterval endDate_ = [coupon[@"use_end_date"] doubleValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDate_];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endDate_];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy.MM.dd"];
    NSString *sDate= [dateFormatter stringFromDate:startDate];
    NSString *eDate= [dateFormatter stringFromDate:endDate];
    cell.use_valide_date.text = [NSString stringWithFormat:@"有效期：%@~%@",sDate,eDate];
    cell.useRange.text = [NSString stringWithFormat:@"使用范围：满%@元可用",coupon[@"min_goods_amount"]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSString *)titleStr{
    return @"代金劵";
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSDictionary *dict = [_couponList objectAtIndex:indexPath.row];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"AddCouponNotification" object:nil userInfo:dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.myCircleViewSubject sendNext:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
