//
//  MBVoiceViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBArticleCollectViewController.h"
#import "MBVoiceViewCell.h"
#import "MBSearchArticleViewController.h"
#import "MBArticleDetailViewController.h"
@interface MBArticleCollectViewController ()
{
    NSInteger _page ;
   
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (nonatomic,copy) NSMutableArray *dataArr;
@end

@implementation MBArticleCollectViewController
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page   = 1;
    
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MBVoiceViewCell" bundle:nil] forCellReuseIdentifier:@"MBVoiceViewCell"];
    
}
- (void)loadData{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/article/collect_list/") parameters:@{@"page":s_Integer(_page),@"session":sessiondict} success:^(id responseObject) {
        [self dismiss];
        
        
        if (_page == 1) {
            MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
            footer.refreshingTitleHidden = YES;
            self.tableView.mj_footer = footer;
        }else{
            [self.tableView .mj_footer endRefreshing];
        }
        if ([responseObject count] >0) {
            [self.dataArr addObjectsFromArray:responseObject];
            
            _page++;
            
        }else{
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
        [self.tableView reloadData];
        if (_dataArr.count > 0 ) {
            _headView.hidden = YES;
          
        }else{
           _headView.hidden = NO;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
    }];
    
}

-(NSString *)titleStr{
   return @"文章收藏";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(MBVoiceViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
//    cell.fd_enforceFrameLayout = NO;
    cell.dataDic = _dataArr[indexPath.section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [tableView fd_heightForCellWithIdentifier:@"MBVoiceViewCell" cacheByIndexPath:indexPath configuration:^(MBVoiceViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MBVoiceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBVoiceViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBArticleDetailViewController *VC = [[MBArticleDetailViewController alloc] init];
    VC.url = URL(_dataArr[indexPath.section][@"url"]);
    VC.title = _dataArr[indexPath.section][@"title"];
    VC.dataDic = _dataArr[indexPath.section];
    [self pushViewController:VC Animated:YES];
    
}

@end
