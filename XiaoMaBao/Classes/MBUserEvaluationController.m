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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBUserEvaluationController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBUserEvaluationController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _commentsArray = [NSMutableArray    array];
    _page = 1;
    [self setheadData];
    [self setRefresh];
    
}
- (void)setRefresh{
    
    
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
    
}

#pragma mark -- 上拉加载数据
- (void)setheadData{
    
    [self show];
    
    
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_SHERVICE,@"service/shop_comments/",_shop_id,page];
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        
        NSLog(@"%@",responseObject);
        
        if ([[responseObject valueForKey:@"data"]count]>0) {
            
      
            [_commentsArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
            _page++;
            [self.tableView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView .mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
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
   
    return 81+strHeight+imageHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       NSDictionary *dic = _commentsArray[indexPath.row];
    MBUserEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBUserEvaluationCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBUserEvaluationCell" owner:nil options:nil]firstObject];
    }
    cell.user_name.text = dic[@"user_name"];
    cell.user_time.text = dic[@"comment_date"];
    cell.user_center.text = dic[@"comment_content"];
    cell.comment_imgs = dic[@"comment_imgs"];
    cell.comment_thumb_imgs = dic[@"comment_thumb_imgs"];
    cell.user_id   =    dic[@"user_id"];
    cell.imageUrl  = dic[@"header_img"];
    cell.VC = self;
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:cell.imageUrl ] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
