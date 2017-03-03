//
//  MBGoodsEvaluationViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBGoodsEvaluationViewController.h"
#import "MBGoodsModel.h"
#import "MBShopTableViewCell.h"
@interface MBGoodsEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSInteger _page;
    
}
/**商品评价数据 */
@property (nonatomic, strong) MBGoodCommentModel *goodCommentModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MBGoodsEvaluationViewController
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,TOP_Y, UISCREEN_WIDTH,UISCREEN_HEIGHT - TOP_Y)];
        [_tableView registerNib:[UINib nibWithNibName:@"MBShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBShopTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    _page = 1;
    [self getGoodsCommentsData];
    
}
-(NSString *)titleStr{
    return @"商品评价";
}
#pragma mark -- 获取商品评价数据;
-(void)getGoodsCommentsData
{
    
    [self show];
    [MBNetworking    POSTOrigin:string(BASE_URL_root, @"/goods/comments") parameters:@{@"goods_id":self.GoodsId,@"page":s_Integer(_page)} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        if ([self checkData:responseObject]) {
            if (_page==1) {
                
                MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getGoodsCommentsData)];
                footer.refreshingTitleHidden = YES;
                _tableView.mj_footer = footer;
                
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            if ([responseObject[@"status"][@"succeed"] integerValue] == 1) {
                
                if (_page == 1) {
                    
                    _goodCommentModel = [MBGoodCommentModel yy_modelWithDictionary:responseObject[@"data"]];
                    
                }else{
                    [_goodCommentModel.commentsList addObjectsFromArray:[MBGoodCommentModel yy_modelWithDictionary:responseObject].commentsList];
                }
                
                if ([responseObject[@"data"][@"comments_list"] count] == 0) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                
                [_tableView reloadData];
 
            }
            
            _page ++;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        [self show:@"请求失败，请检查你的网络连接！" time:.5];
        MMLog(@"%@",error);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goodCommentModel.commentsList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 30;
    
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *commonView = [[UIView alloc] init];
    commonView.frame = CGRectMake(0, 0, self.view.ml_width, 30);
    UILabel *commonLbl = [[UILabel alloc] init];
    commonLbl.frame = CGRectMake(MARGIN_8, 0, commonView.ml_width, commonView.ml_height);
    commonLbl.font = [UIFont systemFontOfSize:14];
    commonLbl.textColor = [UIColor colorWithHexString:@"323232"];
    commonLbl.text = [NSString stringWithFormat:@"评论晒单 (%@人评论)",_goodCommentModel.comment_num];
    [commonView addSubview:commonLbl];
    
    UILabel *praiseTextLbl = [[UILabel alloc] init];
    praiseTextLbl.font = [UIFont systemFontOfSize:14];
    praiseTextLbl.text = @"好评率";
    praiseTextLbl.frame = CGRectMake(commonView.ml_width - 8 - 50, 0, 50, commonView.ml_height);
    [commonView addSubview:praiseTextLbl];
    
    UILabel *praiseLbl = [[UILabel alloc] init];
    praiseLbl.font = [UIFont systemFontOfSize:14];
    praiseLbl.textColor = [UIColor colorWithHexString:@"e8465e"];
    praiseLbl.text = _goodCommentModel.good_comment_rate;
    praiseLbl.frame = CGRectMake(commonView.ml_width - 8 - 100, 0, 50, commonView.ml_height);
    [commonView addSubview:praiseLbl];
    return commonView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return  [tableView fd_heightForCellWithIdentifier:@"MBShopTableViewCell" cacheByIndexPath:indexPath configuration:^(MBShopTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    if ([cell isKindOfClass:[MBShopTableViewCell class]]) {
        
        MBShopTableViewCell *commtCell  = (MBShopTableViewCell *)cell;
        commtCell.model = _goodCommentModel.commentsList[indexPath.row];
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBShopTableViewCell" forIndexPath:indexPath];
    [cell uiedgeInsetsZero];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

@end
