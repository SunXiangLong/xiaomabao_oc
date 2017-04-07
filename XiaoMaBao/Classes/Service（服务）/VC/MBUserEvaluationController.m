//
//  MBUserEvaluationController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBUserEvaluationController.h"
#import "MBUserEvaluationCell.h"
@interface MBUserEvaluationController ()
{
    NSInteger _page;
    NSMutableArray *_commentsArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBUserEvaluationController


- (void)viewDidLoad {
    [super viewDidLoad];
    _commentsArray = [NSMutableArray    array];
    _page = 1;
    [self setheadData];
    
    
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
    NSString *url =[NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_root,@"/service/shop_comments/",_shop_id,page];
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        //MMLog(@"%@",responseObject);
        if (_page == 1) {
            [self setRefresh];
        }else{
        [self.tableView .mj_footer endRefreshing];
        }
        if ([[responseObject valueForKey:@"data"]count]>0) {
            
      
            [_commentsArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
            _page++;
            [self.tableView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            
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
    
    return self.title?:@"全部评价";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _commentsArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 5;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [[UIView alloc] init];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"MBUserEvaluationCell" cacheByIndexPath:indexPath configuration:^(MBUserEvaluationCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBUserEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBUserEvaluationCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [cell removeUIEdgeInsetsZero];
    return cell;
    
}
- (void)configureCell:(MBUserEvaluationCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = YES;
    cell.dataDic = _commentsArray[indexPath.section];
    cell.VC = self;
        
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
