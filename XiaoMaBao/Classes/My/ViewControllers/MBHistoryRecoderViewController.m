//
//  MBHistoryRecoderViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBHistoryRecoderViewController.h"
#import "MBHistoryRecoderTableViewCell.h"
#import "MBGoodsDetailsViewController.h"
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
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/history"] parameters:@{@"session":sessiondict,@"count":@"20",@"page":@"1"}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
//                   MMLog(@"UserInfo成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                   [self dismiss];
                   _array= [responseObject valueForKeyPath:@"data"];
                  
                 
                   
                   if (_array.count>0) {
                          [self tableView];
                   }else{
                       
                   self.stateStr = @"暂无浏览记录";
                   }
             
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   MMLog(@"%@",error);
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
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/users/chistory"] parameters:@{@"session":sessiondict}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
//                   MMLog(@"UserInfo成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                   [self dismiss];
                   _array = @[];
                   [_tableView reloadData];
                    self.stateStr = @"暂无浏览记录";
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   MMLog(@"%@",error);
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
    MBGoodsDetailsViewController *VC =[[MBGoodsDetailsViewController alloc] init];
    VC.GoodsId = _array[indexPath.row][@"goods_id"];
    [self pushViewController:VC Animated:YES];

}
- (NSString *)titleStr{
    return @"浏览记录";
}

@end
