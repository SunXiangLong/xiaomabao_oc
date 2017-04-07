//
//  MBTopPostsController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBTopPostsController.h"
#import "MBTopPostCell.h"
#import "MBPostDetailsViewController.h"
@interface MBTopPostsController ()
{
    NSInteger _page;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *dataArray;
@end

@implementation MBTopPostsController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"MaBaoCircle2"];
    [self.navBar removeFromSuperview];
    self.tableView.tableFooterView = [[UIView alloc] init];
    _page = 1;
    [self setData];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    
    
}
#pragma mark -- 热帖数据数据
- (void)setData{
    [self show];
    NSString *page = s_Integer(_page);
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BASE_URL_root,@"/circle/get_circle_hot/",page];
    
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        if (_page == 1) {
            MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
            footer.refreshingTitleHidden = YES;
            self.tableView.mj_footer = footer;
        }else{
        [self.tableView .mj_footer endRefreshing];
        }
        //      MMLog(@"%@",responseObject);
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                
                [self.dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
                
                //                [[_tableView fd_indexPathHeightCache] invalidateAllHeightCache];
                
                [_tableView reloadData];
                
                
                _page++;
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
        }else{
            [self show:@"没有相关数据" time:1];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)configureCell:(MBTopPostCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    cell.dataDic = self.dataArray[indexPath.row];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:@"MBTopPostCell" cacheByIndexPath:indexPath configuration:^(MBTopPostCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MBTopPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBTopPostCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [cell uiedgeInsetsZero];
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick   event:@"TopPost0"];
    NSDictionary *dic = _dataArray[indexPath.row];
    MBPostDetailsViewController *VC = [[MBPostDetailsViewController   alloc] init];
    VC.post_id = dic[@"post_id"];
    [self pushViewController:VC Animated:YES];
}


@end
