//
//  MBUserEvaluationListController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBUserEvaluationListController.h"
#import "MBUserEvaluationListTableHeadView.h"
#import "MBUserEvaluationListCell.h"
@interface MBUserEvaluationListController ()
{
    NSMutableArray *_commentsArray;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBUserEvaluationListController
- (void)viewDidLoad {
    [super viewDidLoad];
    _commentsArray = [NSMutableArray array];
    self.tableView.tableHeaderView = [self setTableHeadView];
    _page = 1;
    [self setheadData];
    
    
}
- (void)setRefresh{
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
}
-(NSString *)titleStr{
    return self.title?:@"个人全部评价";
}
#pragma mark -- 上拉加载数据
- (void)setheadData{
    
    [self show];

    
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_root,@"/service/user_comments/",_user_id,page];
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        if (_page == 1) {
            [self setRefresh];
        }else{
        [self.tableView .mj_footer endRefreshing];
        }
        if ([[responseObject valueForKey:@"data"]count]>0) {
            MMLog(@"%@",responseObject);
            
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
- (UIView *)setTableHeadView{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0,UISCREEN_WIDTH , 115);
    MBUserEvaluationListTableHeadView *tabHeadView  = [MBUserEvaluationListTableHeadView  instanceView];
    tabHeadView.frame  = view.frame;
     tabHeadView.user_name.text = self.user_name;
   [tabHeadView.showIageView sd_setImageWithURL:[NSURL URLWithString:self.user_imageURl] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    [view addSubview:tabHeadView];
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _commentsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _commentsArray[indexPath.row];
    NSString *str = dic[@"comment_content"];
    NSArray *arr =  dic[@"comment_imgs"];
    CGFloat strHeight = [str sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(UISCREEN_WIDTH-62, MAXFLOAT)].height;
    CGFloat imageHeight = 0;
    if (arr.count!= 0) {
        if (arr.count>3) {
            imageHeight =  (UISCREEN_WIDTH -32)/3*2+3*8;
        }else{
            imageHeight =  (UISCREEN_WIDTH -32)/3+2*8;
        }
    }
    
    return 61+strHeight+imageHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _commentsArray[indexPath.row];
    MBUserEvaluationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBUserEvaluationListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBUserEvaluationListCell" owner:nil options:nil]firstObject];
    }
    cell.user_name.text = dic[@"shop_name"];
    cell.user_time.text = dic[@"comment_date"];
    cell.user_center.text = dic[@"comment_content"];
    cell.comment_imgs = dic[@"comment_imgs"];
    cell.comment_thumb_imgs = dic[@"comment_thumb_imgs"];
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.VC =self;
    cell.shop_id = dic[@"shop_id"];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
