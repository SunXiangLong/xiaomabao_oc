//
//  MBServiceSubtypeViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBServiceSubtypeViewController.h"
#import "MBServiceSubtypeCell.h"
#import "MBServiceModel.h"
#import "MBServiceDetailsViewController.h"
@interface MBServiceSubtypeViewController (){
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSMutableArray <ServiceProductsModel *> *productModelArray;
@end

@implementation MBServiceSubtypeViewController
-(NSMutableArray<ServiceProductsModel *> *)productModelArray{
    if (!_productModelArray) {
        _productModelArray = [NSMutableArray array];
    }
    return _productModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    _page = 1;
    [self requestData];
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.tableView.mj_footer  = footer;
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer.hidden = true;
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = UIcolor(@"666666");
    
}
- (void)requestData{
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/service/product_list") parameters:@{@"page":s_Integer(_page),@"pid":self.cat_id} success:^(id responseObject) {
        [self dismiss];
        [self.tableView.mj_footer endRefreshing];
        MMLog(@"%@",responseObject);
        if (responseObject) {
            if (_page == 1) {
                self.tableView.mj_footer.hidden = false;
            }
            
            if (responseObject) {
                [self.productModelArray addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"ServiceProductsModel"]];
                
            }
            
            if ([responseObject[@"data"] count] == 0){
                [self.tableView.mj_footer  endRefreshingWithNoMoreData];
                return ;
            }
            
            _page++;
            [self.tableView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:.8];
    }];



}
-(NSString *)titleStr{
    return  self.cat_name?:@"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.productModelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBServiceSubtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceSubtypeCell" forIndexPath:indexPath];
    cell.model = _productModelArray[indexPath.row];
    [cell removeUIEdgeInsetsZero];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBServiceDetailsViewController *VC  = [[MBServiceDetailsViewController alloc] init];
    VC.product_id = _productModelArray[indexPath.row].product_id;;
    [self pushViewController:VC Animated:true];
//    [self performSegueWithIdentifier:@"MBServiceShopsViewController" sender:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSIndexPath *indexPath = (NSIndexPath *)sender;
//    if([segue.identifier isEqualToString:@"MBServiceShopsViewController"]){
//        MBServiceShopsViewController *VC = (MBServiceShopsViewController *)segue.destinationViewController;
//        VC.shop_id = _productModelArray[indexPath.row].product_id;
//        VC.title = _productModelArray[indexPath.row].product_name;
//        
//    }
//}


@end
