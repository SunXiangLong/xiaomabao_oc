//
//  MBHistoryRecoderViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBHistoryRecoderViewController.h"
#import "MBHistoryRecoderTableViewCell.h"
#import "MBShopingViewController.h"
@interface MBHistoryRecoderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_array;
}
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation MBHistoryRecoderViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MBHistoryRecoderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBHistoryRecoderTableViewCell"];
        tableView.dataSource = self,tableView.delegate = self;
        tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y);
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBHistoryRecoderViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBHistoryRecoderViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self getUserInfo];
 
    
}
-(void)getUserInfo
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/user/goods_history_record"] parameters:@{@"session":sessiondict,@"count":@"20",@"page":@"1"}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   NSLog(@"UserInfo成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                   [self dismiss];
                   _array= [responseObject valueForKeyPath:@"data"];
                  
                   NSLog(@"%@",_array);
                   
                   if (_array.count>0) {
                          [self tableView];
                   }else{
                       
                   self.stateStr = @"暂无浏览记录";
                   }
             
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   NSLog(@"%@",error);
                   [self show:@"请求失败" time:1];
               }];
    
}

- (NSString *)rightStr{
   return @"清空";
}
-(void)rightTitleClick{

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/user/goods_history_record_clean"] parameters:@{@"session":sessiondict}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   NSLog(@"UserInfo成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                   [self dismiss];
                   _array = @[];
                   [_tableView reloadData];
                    self.stateStr = @"暂无浏览记录";
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   NSLog(@"%@",error);
                   [self show:@"请求失败" time:1];
               }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBHistoryRecoderTableViewCell";
    
    MBHistoryRecoderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [cell.shopImageView sd_setImageWithURL:[NSURL URLWithString:_array[indexPath.row][@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.nameLable.text = _array[indexPath.row][@"goods_name"];
    cell.timeLable.text = _array[indexPath.row][@"add_time"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBShopingViewController *VC =[[MBShopingViewController alloc] init];
    VC.GoodsId = _array[indexPath.row][@"goods_id"];
    [self pushViewController:VC Animated:YES];

}
- (NSString *)titleStr{
    return @"浏览记录";
}
- (void)registerClick{

    NSLog(@".........");

}
@end
