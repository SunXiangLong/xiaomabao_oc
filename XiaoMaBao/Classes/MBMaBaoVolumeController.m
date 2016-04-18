//
//  MBMaBaoVolumeController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMaBaoVolumeController.h"
#import "MBServiceOrderTwoCell.h"
#import "MBMaBaoVolumeHeaderView.h"
@interface MBMaBaoVolumeController ()
{
    NSDictionary *_dataDic;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBMaBaoVolumeController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBMaBaoVolumeController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBMaBaoVolumeController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setheadData];
    
}
- (NSString *)titleStr{

return @"麻包券";
}
#pragma mark -- 请求数据
- (void)setheadData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_SHERVICE,@"service/view_ticket"];
    if (! sid) {
        return;
    }
    [MBNetworking POSTAPPStore:url parameters:@{@"session":sessiondict,@"order_id":self.order_id} success:^(id responseObject) {
        
        if (responseObject) {
            _dataDic = responseObject;
            self.tableView.tableHeaderView = [self setTableHeadView];
            UIView *FooterView = [[UIView alloc] init];
            FooterView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 10);
            FooterView.backgroundColor = [UIColor   colorWithHexString:@"ececec"];
            self.tableView.tableFooterView = FooterView;
            [self.tableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
    
   
     
    
}
-(UIView *)setTableHeadView{

    NSDictionary *dic = _dataDic[@"shop_info"];
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 68);
    MBMaBaoVolumeHeaderView *view = [MBMaBaoVolumeHeaderView  instanceView];
    view.store_name.text = dic[@"shop_name"];
    view.store_adress.text = dic[@"shop_address"];
    [view.store_image sd_setImageWithURL:[NSURL URLWithString:dic[@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    view.frame = sectionView.frame;
    [sectionView addSubview:view];
    return sectionView;



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *arr = _dataDic[@"ticket_info"];
    return arr.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 47;
    
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSDictionary *dic = _dataDic[@"ticket_info"][indexPath.section];
    
    MBServiceOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceOrderTwoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceOrderTwoCell" owner:self options:nil]firstObject];
    }
    cell.mabaoquan.text = dic[@"ticket_code"];
    cell.zhuangtai.text = dic[@"ticket_status"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}


@end
