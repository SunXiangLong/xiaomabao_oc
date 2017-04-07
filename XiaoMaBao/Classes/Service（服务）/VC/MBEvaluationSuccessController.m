//
//  MBEvaluationSuccessController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBEvaluationSuccessController.h"
#import "MBServiceEvaluationController.h"
#import "MBServiceHomeCell.h"
#import "MBServiceShopsViewController.h"
#import "MBEvaluationSuccessCell.h"
#import "MBMyServiceChilderViewController.h"
@interface MBEvaluationSuccessController (){

    NSInteger _page;
    NSMutableArray *_storeData;
}
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@end

@implementation MBEvaluationSuccessController
- (void)viewDidLoad {
    [super viewDidLoad];
    _storeData = [NSMutableArray array];
    self.tabelView.tableFooterView = [[UIView alloc] init];
    _page = 1;
    [self setheadData];
    [self setRefresh];
    //覆盖侧滑手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.navigationController.view  addGestureRecognizer:pan];
    
}
-(void)back{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRefresh{
    
    
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    footer.refreshingTitleHidden = YES;
    self.tabelView.mj_footer = footer;
    
    
}
#pragma mark -- 上拉加载数据
- (void)setheadData{
    
    [self show];
    
    
    //    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/shop_list"];
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        NSArray *arr = [responseObject valueForKeyPath:@"data"];
        if ([arr count]>0) {
            
            [_storeData addObjectsFromArray:arr];
            _page++;
            [self.tabelView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tabelView .mj_footer endRefreshing];
            [self.tabelView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tabelView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
-(NSString *)titleStr{
    return @"麻包服务";
}
- (NSString *)rightStr{
     return @"完成";
}
- (void)rightTitleClick{
  

    NSArray *arr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:arr[arr.count-3] animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_storeData.count >0 ) {
        return 2;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0 ) {
        return 1;
    }
    return _storeData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"MBEvaluationSuccessCell" cacheByIndexPath:indexPath configuration:^(MBEvaluationSuccessCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
            
        }];
    }
    return [tableView fd_heightForCellWithIdentifier:@"MBServiceHomeCell" cacheByIndexPath:indexPath configuration:^(MBServiceHomeCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    if (indexPath.section != 0) {
        MBServiceHomeCell *newcell = (MBServiceHomeCell *)cell;
        newcell.dataDic = _storeData[indexPath.row];

    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MBEvaluationSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBEvaluationSuccessCell" forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    MBServiceHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceHomeCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [cell uiedgeInsetsZero];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary    *dic = _storeData[indexPath.row];
    MBServiceShopsViewController *VC = [[MBServiceShopsViewController alloc] init];
    VC.shop_id = dic[@"shop_id"];
    [self pushViewController:VC Animated:YES];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    NSArray *arr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:arr[arr.count-3] animated:YES];
    NSNotification *notification =[NSNotification notificationWithName:@"HYTPopViewControllerNotification" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return    nil;
    
}

@end
