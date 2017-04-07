//
//  MBMyMaBeanViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyMaBeanViewController.h"
#import "MBBeanInfoModel.h"
#import "MBMyMaBeanViewCell.h"
#import "MBGiveFriendsViewController.h"
@interface MBMyMaBeanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UILabel *madouNumber;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBBeanInfoModel *beanModel;
@end

@implementation MBMyMaBeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self requestDaTa];
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDaTa)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
    
}
- (IBAction)giveFriends:(UIButton *)sender {
    [self performSegueWithIdentifier:@"MBGiveFriendsViewController" sender:nil];
    
}

-(NSString *)titleStr{
    return @"我的麻豆";
}
-(void)requestDaTa{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/bean/info") parameters:@{@"session":dict,@"page":s_Integer(_page)} success:^(id responseObject) {
        [self dismiss];
        [self.tableView.mj_footer endRefreshing];
        MMLog(@"%@",responseObject);
        _madouNumber.text = [NSString stringWithFormat:@"%@",responseObject[@"number"]];
        _tableView.hidden = false;
        if ([responseObject[@"records"] count] > 0) {
            
            if (_page == 1) {
                _beanModel = [MBBeanInfoModel yy_modelWithDictionary:responseObject];
                
                
            }else{
                
                [_beanModel.record addObjectsFromArray:[MBBeanInfoModel yy_modelWithDictionary:responseObject].record];
                
            
            }
            _page ++;
           [self.tableView reloadData];
            

        }else{
            if (_page == 1) {
//                [_tableView.mj_footer removeSubviews];
                _tableView.mj_footer = nil;
            }{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
       
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:.8];
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_beanModel||_beanModel.record.count == 0) {
        return 1;
    }
    return _beanModel.record.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_beanModel||_beanModel.record.count == 0) {
        return UISCREEN_HEIGHT - 235 - 64;
    }
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_beanModel||_beanModel.record.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMyMaBeanViewNullCell" forIndexPath:indexPath];
        
        return cell;

    }
    MBMyMaBeanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMyMaBeanViewCell" forIndexPath:indexPath];
    cell.model = _beanModel.record[indexPath.row];
    return cell;
    
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"MBGiveFriendsViewController"]) {
         MBGiveFriendsViewController *VC = (MBGiveFriendsViewController *)segue.destinationViewController;
         VC.num = _beanModel.number;
         WS(weakSelf)
         VC.block = ^(){
             _page = 1;
             weakSelf.beanModel = nil;
             [weakSelf requestDaTa];
         };
     }
 }
 

@end
