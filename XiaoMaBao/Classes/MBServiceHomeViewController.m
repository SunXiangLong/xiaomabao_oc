//
//  MBServiceHomeViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceHomeViewController.h"
#import "MBServiceHomeCell.h"
#import "MBServiceShopsViewController.h"
@interface MBServiceHomeViewController ()
{
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *storeData;
@end

@implementation MBServiceHomeViewController

-(NSMutableArray *)storeData{
    if (!_storeData) {
        _storeData  = [NSMutableArray array];
    }
    return _storeData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    _page = 1;
    [self setheadData];
    [self setRefresh];
    
}
- (void)setRefresh{
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
    
}
#pragma mark -- 上拉加载数据
- (void)setheadData{
    
    [self show];
    
    
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@%@",BASE_URL_root,@"/service/shop_list/",page];
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        NSArray *arr = [responseObject valueForKeyPath:@"data"];
//        MMLog(@"%@",arr);
        if ([arr count]>0) {
            
            [self.storeData addObjectsFromArray:arr];
            _page++;
            [self.tableView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView .mj_footer endRefreshing];

           
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    MBServiceShopsViewController *VC = (MBServiceShopsViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    NSDictionary *dic = self.storeData[indexPath.row];
    VC.shop_id = dic[@"shop_id"];
    VC.title = dic[@"shop_name"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.storeData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return [tableView fd_heightForCellWithIdentifier:@"MBServiceHomeCell" cacheByIndexPath:indexPath configuration:^(MBServiceHomeCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBServiceHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceHomeCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [cell uiedgeInsetsZero];
    return cell;
    
    
    
}
- (void)configureCell:(MBServiceHomeCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    cell.dataDic = self.storeData[indexPath.row];
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"MBServiceShopsViewController" sender:indexPath];
}


@end
