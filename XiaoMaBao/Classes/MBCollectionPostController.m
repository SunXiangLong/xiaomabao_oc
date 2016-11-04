//
//  MBCollectionPostController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCollectionPostController.h"
#import "MBLoginViewController.h"
#import "MBDetailsCircleTbaleViewCell.h"
#import "MBPostDetailsViewController.h"
@interface MBCollectionPostController ()
{
    /**
     *  页数
     */
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *   收藏帖子数据
 */
@property (copy, nonatomic) NSMutableArray *dataArray;
@end

@implementation MBCollectionPostController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     _page = 1;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self setData];
   
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
}
/**
 *  请求收藏的帖子数据
 */
- (void)setData{
    
    NSString *page = s_Integer(_page);
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        [self loginClicksss];
        return;
    }
    [self show];
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/get_collect_post"];
   
    [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict,@"page":page} success:^(id responseObject) {
//        MMLog(@"%@",responseObject);
        [self dismiss];
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                [self.dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
               
                [_tableView reloadData];
                [self.tableView .mj_footer endRefreshing];
                 _page++;
                
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
        }else{
            [self show:@"没有相关数据" time:1];
        }
        
        
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        MMLog(@"%@",error);
    }];
    
    
}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    //跳转到登录页
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}
-(NSString *)titleStr{
    
   return @"我的收藏";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001;
    }
    return 10;
    
}

#pragma mark -- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"MBDetailsCircleTbaleViewCell" cacheByIndexPath:indexPath configuration:^(MBDetailsCircleTbaleViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
}
- (void)configureCell:(MBDetailsCircleTbaleViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = YES;
    cell.dataDic = self.dataArray[indexPath.section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBDetailsCircleTbaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBDetailsCircleTbaleViewCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.section];
    MBPostDetailsViewController *VC = [[MBPostDetailsViewController   alloc] init];
    VC.post_id = dic[@"post_id"];
    [self pushViewController:VC Animated:YES];
}


@end
