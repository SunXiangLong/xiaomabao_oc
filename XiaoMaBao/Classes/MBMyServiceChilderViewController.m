//
//  MBMyServiceChilderViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyServiceChilderViewController.h"
#import "MBMBMyServiceChilderCell.h"
#import "WNXRefresgHeader.h"
#import "MBServiceOrderController.h"
@interface MBMyServiceChilderViewController ()
{
    NSInteger _page;
    NSMutableArray *_dataArray;
    UILabel *_promptLable;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBMyServiceChilderViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHeadRefresh];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor    colorWithHexString:@"ecedf1"];
    [self.navBar removeFromSuperview];
   
    _dataArray = [NSMutableArray array];
    _promptLable = [[UILabel alloc] init];
    _promptLable.textAlignment = 1;
    _promptLable.font = [UIFont systemFontOfSize:14];
    _promptLable.textColor = [UIColor colorR:146 colorG:147 colorB:148];
    [self.tableView addSubview:_promptLable];
    [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.centerY.equalTo(self.tableView.mas_centerY);
    }];
    
}
#pragma mark --上拉加载
- (void)setFootRefres{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    footer.refreshingTitleHidden = YES;
    
    // 设置footer
    self.tableView.mj_footer = footer;
    
    
    
}

#pragma mark --下拉刷新
- (void)setHeadRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    WNXRefresgHeader *header = [WNXRefresgHeader headerWithRefreshingTarget:self refreshingAction:@selector(setRefreshData)];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.tableView.mj_header = header;
}
#pragma mark -- 上拉加载
- (void)setheadData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/my_product"];
    if (! sid) {
        return;
    }
    
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"type":self.strType,@"page":page}
               success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                   
                   ;
                   //   MMLog(@"%@",responseObject.data);
                  
                   [self.tableView.mj_header endRefreshing];
                   
                   
                   if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                       [_dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
                       [self.tableView reloadData];
                       _page++;
                   }else{
                       [self.tableView.mj_footer endRefreshingWithNoMoreData];
                       return ;
                       
                   }
                   
                   
                   
                   
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   MMLog(@"%@",error);
                   [self.tableView.mj_header endRefreshing];
                   
               }
     ];
    
    
}
#pragma mark --刷新数据
- (void)setRefreshData{

    _page = 1;
    [_dataArray removeAllObjects];
    [self.tableView.mj_footer resetNoMoreData];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/my_product"];
    if (! sid) {
        return;
    }
    [MBNetworking POSTOrigin:url parameters:@{@"session":sessiondict,@"type":self.strType,@"page":page} success:^(id responseObject) {
        
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]&&[responseObject[@"data"] count] >0) {
            _promptLable.hidden = YES;
            [_dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
            _page++;
        }else{
            NSString *str;
            switch (self.type) {
                case 0:  str = @"待付款";break;
                case 1:  str = @"待使用";break;
                case 2:  str = @"待评价";break;
                default: str = @"售后";break;
            }
            _promptLable.hidden  = NO;
            _promptLable.text = [NSString stringWithFormat:@"没有%@的服务订单",str];
            
        }
        
        [self.tableView reloadData];
        [self.tableView .mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        MMLog(@"%@",error);
        [self.tableView .mj_header endRefreshing];
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.type == 3) {
        return 166;
    }
      return 213;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    MBMBMyServiceChilderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMBMyServiceChilderCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBMBMyServiceChilderCell" owner:nil options:nil]firstObject];
    }
     cell.vc  = self;
    [cell.store_image sd_setImageWithURL:[NSURL URLWithString:dic[@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    [cell.service_image   sd_setImageWithURL:[NSURL URLWithString:dic[@"product_img"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.service_num.text = [NSString stringWithFormat:@"数量：%@",dic[@"product_number"]];
    cell.service_price.text = dic[@"order_amount"];
    cell.store_name.text = dic[@"product_name"];
    cell.store_state.text = dic[@"order_status"];
    
    cell.dataDic = dic;
    switch (self.type) {
        case 0: { [cell.button setTitle:@"付款" forState:UIControlStateNormal];
            
            break;}
        case 1:  {[cell.button setTitle:@"查看卷码" forState:UIControlStateNormal];
            
        }break;
        case 2:  {[cell.button setTitle:@"评价" forState:UIControlStateNormal];
            
        }break;
        default: {[cell.button setTitle:@"申请退款" forState:UIControlStateNormal];
            
            
        }  break;
    }
    cell .contentMode =  UIViewContentModeScaleAspectFill;
    cell .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell .clipsToBounds  = YES;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type != 0) {
        [MobClick event:@"ServiceOrder8"];
        NSDictionary *dic = _dataArray[indexPath.row];
        MBServiceOrderController *VC = [[MBServiceOrderController alloc] init];
        VC.type = self.type;
        VC.order_id = dic[@"order_id"];
        [self pushViewController:VC Animated:YES];
    }
    switch (self.type) {
        case 0: {
            
            break;}
        case 1:  {
        }break;
        case 2:  {
            
        }break;
        default: {
            
            
        }  break;
    }
    
}



@end
