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
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBCollectionPostController"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBCollectionPostController"];
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     _page = 1;
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
//        NSLog(@"%@",responseObject);
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
        
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
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
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary  *dic = _dataArray[indexPath.row];
    NSString *post_content = dic[@"post_content"];
    CGFloat post_content_height = [post_content sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH - 24, MAXFLOAT)].height;
    
    if (post_content_height>51) {
        post_content_height = 51+10;
    }else{
        post_content_height +=5;
    }
    if ([dic[@"post_imgs"] count]>0) {
        return 70+(UISCREEN_WIDTH -16*3)/3*133/184+post_content_height;
    }
    return 70+post_content_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary  *dic = _dataArray[indexPath.row];
    MBDetailsCircleTbaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBDetailsCircleTbaleViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBDetailsCircleTbaleViewCell"owner:nil options:nil]firstObject];
    }
    cell.array = dic[@"post_imgs"];
    cell.post_title.text = dic[@"post_title"];
    cell.post_time.text = dic[@"post_time"];
    cell.reply_cnt.text = dic[@"reply_cnt"];
    cell.author_name.text = dic[@"author_name"];
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
