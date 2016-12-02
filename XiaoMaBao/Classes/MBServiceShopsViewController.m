//
//  MBServiceShopsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceShopsViewController.h"
#import "MBServiceShopsHeadView.h"
#import "MBServiceShopsOneCell.h"
#import "MBServiceHomeCell.h"
#import "MBServiceShopsTableFootView.h"
#import "MBServiceShopsTableHeadView.h"
#import "MBUserEvaluationCell.h"
#import "MBServiceDetailsViewController.h"
#import "MBUserEvaluationController.h"
@interface MBServiceShopsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _iSmoreService;
    NSDictionary *_dataDic;
    NSArray *_dataArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBServiceShopsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self setheadData];
    
    
}
- (UIView *)setTableHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 183)];
    MBServiceShopsHeadView *tableHead = [MBServiceShopsHeadView instanceView];
    [tableHead.showImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"shop_info"][@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    tableHead.store_name.text = _dataDic[@"shop_info"][@"shop_name"];
    tableHead.adress.text = [NSString stringWithFormat:@"地址：%@",_dataDic[@"shop_info"][@"shop_nearby_subway"]];
    tableHead.photo.text = _dataDic[@"shop_info"][@"shop_phone"];
    tableHead.adress_detailed.text = _dataDic[@"shop_info"][@"shop_address"];
    tableHead.frame = view.bounds;
    
    [tableHead.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)]];
    
    [view addSubview:tableHead];
    return view;
    
}
- (void)callPhone:(id)sender {

    if (_dataDic) {
    
        NSString *str = _dataDic[@"shop_info"][@"shop_phone"];
        NSString *str1 = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
       
        NSString * telStr = [NSString stringWithFormat:@"telprompt://%@",str1];
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        
    }
    
}
- (void)setheadData{
    
    [self show];
    NSString *url =[NSString stringWithFormat:@"%@%@%@",BASE_URL_root,@"/service/shop_detail_info/",self.shop_id];
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        if ([responseObject count]>0) {
            
//            MMLog(@"%@",responseObject);
            _dataDic = responseObject;
            self.tableView.tableHeaderView = [self setTableHeadView];
            _dataArr = @[_dataDic[@"products"],_dataDic[@"comment"],_dataDic[@"other_shop"]];
            [self.tableView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView .mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
- (NSString *)titleStr{
    
    return self.title?:@"";
}
#pragma mark -- 更多服务
- (void)moreService{
    _iSmoreService = !_iSmoreService;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -- 其它评价
- (void)otherEvaluation{
    
    [self performSegueWithIdentifier:@"MBUserEvaluationController" sender:_dataDic[@"comment"][0][@"shop_id"]];
    
//    MBUserEvaluationController *VC = [[MBUserEvaluationController alloc] init];
//    VC.shop_id = _dataDic[@"comment"][0][@"shop_id"];
//    [self pushViewController:VC Animated:YES];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MBUserEvaluationController"]) {
        MBUserEvaluationController *controller = segue.destinationViewController;
        controller.shop_id = (NSString *)sender;
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _dataDic[@"products"];
    NSArray *arr2 = _dataDic[@"other_shop"];
    NSArray *arr3 = _dataDic[@"comment"];
    switch (section) {
        case 0:
        {
            if (arr.count>2) {
                return _iSmoreService?arr.count:2;
            }else if(arr.count==0){
                return 0;
            }
            return arr.count;
        }
        case 1: return arr3.count;
        default: return arr2.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:  {
            return [tableView fd_heightForCellWithIdentifier:@"MBServiceShopsOneCell" cacheByIndexPath:indexPath configuration:^(MBServiceShopsOneCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
            
        }];
        }
        case 1:{
           return [tableView fd_heightForCellWithIdentifier:@"MBUserEvaluationCell" cacheByIndexPath:indexPath configuration:^(MBUserEvaluationCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];

            }];
        }
        default:{
            return [tableView fd_heightForCellWithIdentifier:@"MBServiceHomeCell" cacheByIndexPath:indexPath configuration:^(MBServiceHomeCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
                
            }];

        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        MBServiceShopsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceShopsOneCell" forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        [cell removeUIEdgeInsetsZero];
        return cell;
    }else if(indexPath.section==1){
        
        MBUserEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBUserEvaluationCell" forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        [cell uiedgeInsetsZero];
        return cell;
        
    }
    
    MBServiceHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceHomeCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [cell uiedgeInsetsZero];
    return cell;
    
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    if (indexPath.section == 0) {
        MBServiceShopsOneCell *cells = (MBServiceShopsOneCell *)cell;
        cells.dataDic = _dataDic[@"products"][indexPath.row];
    }else if(indexPath.section == 1){
        MBUserEvaluationCell *cells = (MBUserEvaluationCell *)cell;
        cells.dataDic = _dataDic[@"comment"][indexPath.row];
        cells.VC = self;

    }else{
        MBServiceHomeCell *cells = (MBServiceHomeCell *)cell;
        cells.dataDic = _dataDic[@"other_shop"][indexPath.row];
    
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        
        NSArray *arr = _dataArr[section];
        NSInteger num = arr.count - 2;
        MBServiceShopsTableFootView *footView = [MBServiceShopsTableFootView instanceView];
        footView.frame = view.bounds;
        [view addSubview:footView];
        if (num>0) {
            
            if (_iSmoreService) {
                num = 0;
                footView.name.text = [NSString stringWithFormat:@"查看其它%ld个服务",num];
                footView.image.image = [UIImage imageNamed:@"dupward_image"];
            }else{
                footView.name.text = [NSString stringWithFormat:@"查看其它%ld个服务",num];
                footView.image.image = [UIImage imageNamed:@"down_image"];
            }
            [footView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreService)]];
            
            
        }else{
            footView.name.text = @"暂无更多服务";
            
        }
        
        return view;
        
    }else  if  (section == 1){
        MBServiceShopsTableFootView *footView = [MBServiceShopsTableFootView instanceView];
        footView.frame = view.bounds;
        [view addSubview:footView];
        if ([_dataArr[section] count]>0) {
            footView.name.text = @"查看其它评价";
            footView.image.hidden = YES;
            [footView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherEvaluation)]];
            return view;
        }
        footView.name.text = @"暂无评价数据";
        
    }
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    MBServiceShopsTableHeadView *headView = [MBServiceShopsTableHeadView instanceView];
    headView.frame = view.bounds;
    [view addSubview:headView];
    
    switch (section) {
        case 0: {
            NSArray *arr = _dataDic[@"products"];
            headView.number.text =  [NSString stringWithFormat:@"服务%lu",(unsigned long)arr.count];
            headView.name.text = @"特色服务";} break;
        case 1:{headView.number.text = @"";
            headView.name.text = @"用户评价";}  break;
        default:{headView.number.text = @"";
            headView.name.text = @"更多商家";} break;
    }
    [self addBottomLineView:view];
    
    return view;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            MBServiceDetailsViewController *VC = [[MBServiceDetailsViewController alloc] init];
            VC.product_id = _dataDic[@"products"][indexPath.row][@"product_id"];
          
            
            [self pushViewController:VC Animated:YES];
        }break;
        case 1:{
            [self performSegueWithIdentifier:@"MBUserEvaluationController" sender:_dataDic[@"comment"][indexPath.row][@"shop_id"]];

            
        }break;
        default:{
            NSDictionary    *dic = _dataDic[@"other_shop"][indexPath.row];
            MBServiceShopsViewController *VC =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBServiceShopsViewController"];
            VC.shop_id = dic[@"shop_id"];
            VC.title = dic[@"shop_name"];
            [self pushViewController:VC Animated:YES];
            
        }break;
    }
}


@end
