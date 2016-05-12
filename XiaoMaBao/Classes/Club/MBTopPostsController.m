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
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBTopPostsController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBTopPostsController"];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    self.navBar = nil;
    _page = 1;
    [self setData];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
}
#pragma mark -- 热帖数据数据
- (void)setData{

    NSString *page = s_Integer(_page);
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BASE_URL_root,@"/circle/get_circle_hot/",page];
    
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//      NSLog(@"%@",responseObject);
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                [self.dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
                _page++;
                [_tableView reloadData];
                 [self.tableView .mj_footer endRefreshing];
            
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
           
        }else{
         [self show:@"没有相关数据" time:1];
        }
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *post_title = dic[@"post_title"];
      NSString *post_content = dic[@"post_content"];
    CGFloat post_title_height = [post_title sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH - 24, MAXFLOAT)].height;
    CGFloat post_content_height = [post_content sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH - 24, MAXFLOAT)].height;
    if (post_content_height>51) {
        post_content_height = 51+10;
    }else{
        post_content_height+=5;
    }
    return 72+post_title_height+post_content_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    
    MBTopPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBTopPostCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBTopPostCell"owner:nil options:nil]firstObject];
    }
    [cell.user_image sd_setImageWithURL:[NSURL URLWithString:dic[@"author_userhead"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.user_name.text = dic[@"author_name"];
    cell.circle_name.text = dic[@"circle_name"];
    cell.post_title.text = dic[@"post_title"];
    cell.post_content.text = dic[@"post_content"];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = _dataArray[indexPath.row];
    MBPostDetailsViewController *VC = [[MBPostDetailsViewController   alloc] init];
    VC.post_id = dic[@"post_id"];
    [self pushViewController:VC Animated:YES];
}


@end
