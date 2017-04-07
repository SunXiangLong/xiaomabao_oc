//
//  MBNewsCircleController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewsCircleController.h"
#import "MBNewsCircleCell.h"
#import "MBPostDetailsViewController.h"
@interface MBNewsCircleController ()
{
    /**
     *  页数
     */
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *    显示无消息的view
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  消息数据
 */
@property (copy, nonatomic) NSMutableArray *dataArray;
@end

@implementation MBNewsCircleController

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray =  [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self setData];
  
}
-(NSString *)titleStr{

    return @"麻包圈消息";
    
}
/**
 *  请求消息数据
 */
- (void)setData{
    
    NSString *page = s_Integer(_page);
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
  
    [self show];
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/get_notification"];
    
    [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict,@"page":page} success:^(id responseObject) {
//        MMLog(@"%@",responseObject);
        [self dismiss];
        
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                [self.dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
                 self.topView.hidden = YES;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *str  = dic[@"notify_content"];
    NSString *str1 = dic[@"notify_base_content"];
    CGFloat height = [str1 sizeWithFont:SYSTEMFONT(12) withMaxSize:CGSizeMake(UISCREEN_WIDTH-80, MAXFLOAT)].height;
    if (height>30) {
        height = 30+16;
    }else{
        height += 20;
    }
    return 73+[str sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height+height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    MBNewsCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewsCircleCell"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewsCircleCell"owner:nil options:nil]firstObject];
    }
    [cell.user_head sd_setImageWithURL:URL(dic[@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.user_name.text = dic[@"user_name"];
    cell.notify_time.text = dic[@"notify_time"];
    cell.notify_content.text = dic[@"notify_content"];
    cell.notify_base_content.text = dic[@"notify_base_content"];
    NSString *str1 = dic[@"notify_base_content"];
    CGFloat height = [str1 sizeWithFont:SYSTEMFONT(12) withMaxSize:CGSizeMake(UISCREEN_WIDTH-80, MAXFLOAT)].height;
    
    if (height>30) {
       cell.height.constant  = 30+16;
    }else{
      cell.height.constant  = height+16;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = self.dataArray[indexPath.row];
    MBPostDetailsViewController *VC = [[MBPostDetailsViewController alloc] init];
    VC.post_id = dic[@"notify_post_id"];
    VC.comment_id = dic[@"notify_comment_id"];
    [self pushViewController:VC Animated:YES];
}


@end
