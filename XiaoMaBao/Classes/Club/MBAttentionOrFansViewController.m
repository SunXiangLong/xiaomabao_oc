//
//  MBAttentionOrFansViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAttentionOrFansViewController.h"
#import "MBAttentionOrFansTableViewCell.h"
#import "MBPersonalCanulaCircleViewController.h"
@interface MBAttentionOrFansViewController ()<UITableViewDataSource,UITableViewDelegate,MBAttentionOrFansTableViewdelegate>
{
    NSInteger _page;
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewtop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBAttentionOrFansViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBAttentionOrFansViewController"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBAttentionOrFansViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = [NSMutableArray array];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    self.tableView.tableFooterView = [[UIView alloc] init];
    [self setUserTell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(is_attention:) name:@"attention" object:nil];
}
#pragma mark --获取数据
- (void)setUserTell{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *urlStr;
    if (self.type ==MBFansType) {
        urlStr = @"/communicate/fanlist";
    }else{
        
        urlStr = @"/communicate/attentionlist";
    }
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,urlStr];
    if (! sid) {
        return;
    }
    
    NSDictionary *parameters;
    if (self.user_id) {
        parameters = @{@"session":sessiondict,@"page":page,@"user_id": self.user_id};
    }else{
    
        parameters = @{@"session":sessiondict,@"page":page};
    }
    [self show];
    
    
    [MBNetworking POST:url parameters: parameters
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   [self dismiss];
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       
                       for (NSDictionary *dic  in [responseObject valueForKey:@"data"]) {
                           NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                           [_dataArray addObject:muDic];
                       }
                       
                       [self.tableView reloadData];
                        _page++;
                       
                       if (!(_dataArray.count > 0)) {
                           UILabel *label = [[UILabel alloc] init];
                           label.textAlignment = 1;
                           label.font = [UIFont systemFontOfSize:14];
                           label.textColor = [UIColor colorR:146 colorG:147 colorB:148];
                           if (self.type == MBAttentionType) {
                            label.text = @"暂时没有关注数据";
                           }else{
                            label.text = @"暂时没有粉丝数据";
                           }
                           [self.tableView addSubview:label];
                           [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(self.tableView.mas_centerX);
                            make.centerY.equalTo(self.tableView.mas_centerY);
                           }];
                           
                       }
                      
                       
                       
                       
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
- (void)is_attention:(NSNotification *)notificat{
    NSIndexPath *indexPath = notificat.userInfo[@"indexPath"];
    NSString *is_attention =  notificat.userInfo[@"is_attention"];
    _dataArray[indexPath.row][@"is_attention"] = is_attention;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  
}
- (NSString *)titleStr{
    if (self.type == MBAttentionType) {
        return @"关注" ;
    }
    return @"粉丝";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _dataArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       return 90;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    MBAttentionOrFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAttentionOrFansTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBAttentionOrFansTableViewCell" owner:nil options:nil]firstObject];
    }
    
    cell.nameLable.text = dic[@"username"];
    
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.user_id = dic[@"user_id"];
    cell.indexPath = indexPath;
    cell.is_attention = dic[@"is_attention"];

    cell.delegate = self;

    if (self.type == 0) {
      cell.is_attention = @"1";
    }
        if ([dic[@"is_attention"]isEqualToString:@"0"]) {
            [cell.attentionButton setBackgroundColor:[UIColor colorR:192 colorG:88 colorB:89]];
            [cell.attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
        }
    
    return cell;
}
-(void)touxiangdianji:(NSIndexPath *)indexPath{
    MBPersonalCanulaCircleViewController *VC = [[MBPersonalCanulaCircleViewController alloc] init];
    VC.user_id = _dataArray[indexPath.row][@"user_id"];
    [self pushViewController:VC Animated:YES];

}
@end
