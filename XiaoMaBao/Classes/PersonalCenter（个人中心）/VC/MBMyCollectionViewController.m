//
//  MBMyCollectionViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBMyCollectionViewController.h"
#import "MBMyCollectionTableViewCell.h"
#import "MBGoodsDetailsViewController.h"
#import "MBGoodsCollectionModel.h"
#import "MBGoodsSpecsView.h"
@interface MBMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>{
    
}
@property (strong,nonatomic) UITableView *tableView;
@property (assign,nonatomic) NSInteger page;
@property (strong,nonatomic) MBGoodsCollectionModel *model;
@property (strong,nonatomic) MBGoodsSpecsRootModel *goodsSpecsModel;

@end

@implementation MBMyCollectionViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView registerNib:[UINib nibWithNibName:@"MBMyCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBMyCollectionTableViewCell"];
        tableView.dataSource = self,tableView.delegate = self;
        tableView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT - TOP_Y);
        _tableView = tableView;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self.view addSubview:self.tableView];
    [self requestData];
   
}
- (NSString *)titleStr{
    return @"商品收藏";
}
- (void)presentSemiType:(MBGoodsModel *)model{
    
    MBGoodsSpecsView * imagev = [[MBGoodsSpecsView alloc] initWithModel:_goodsSpecsModel type:3];
    imagev.VC = self;
    imagev.inventoryNum =  [model.salesnum integerValue];
    [self presentSemiView:imagev];
}
//获取数据
-(void)requestData
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [self show];
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/collect/goods_list") parameters:@{@"session":session,@"page":s_Integer(_page)} success:^(id responseObject) {
        [self dismiss];
        
        MBGoodsCollectionModel *model =   [MBGoodsCollectionModel yy_modelWithDictionary:responseObject];
        if (_page == 1) {
            MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
            footer.refreshingTitleHidden = YES;
            self.tableView.mj_footer = footer;
            _model = model;
            [self.tableView reloadData];
            _page ++;
            if (model.dataModel.count == 0) {
                self.tableView.mj_footer.hidden = true;
                self.stateStr = @"暂无收藏商品数据";
            }
        }else{
            [self.tableView.mj_footer endRefreshing];
            if (model.dataModel.count > 0) {
                [_model.dataModel addObjectsFromArray:model.dataModel];
                [self.tableView reloadData];
                _page ++;
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
#pragma mark -- 请求规格数据
-(void)getGoodsPropertyData:(MBGoodsModel *)model{
    
    [self show];
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/goods/getgoodsspecs") parameters:@{@"goods_id":model.goods_id} success:^(id responseObject) {
        [self dismiss];
        if ([self checkData:responseObject]&&[responseObject[@"status"][@"succeed"] integerValue] == 1) {
    
            _goodsSpecsModel = [MBGoodsSpecsRootModel yy_modelWithDictionary:responseObject[@"data"]];
            [self presentSemiType:model];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:.5];
    }];
    
}
- (void)removeCollection:(MBGoodsModel *)model{

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/collect/del_goods") parameters:@{@"session":sessiondict,@"rec_id":model.rec_id} success:^(id responseObject) {
        MMLog(@"%@",responseObject);
        [self dismiss];
        if ([responseObject[@"status"][@"succeed"] integerValue] == 1) {
            [self show:@"已从收藏中移除" time:1];
            [_model.dataModel  removeObject:model];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}

#pragma mark -- UITabledelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model?_model.dataModel.count:0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MBMyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMyCollectionTableViewCell" forIndexPath:indexPath];
    cell.model = self.model.dataModel[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBGoodsDetailsViewController *shop = [[MBGoodsDetailsViewController alloc] init];
    shop.GoodsId = _model.dataModel[indexPath.row].goods_id;
    [self.navigationController pushViewController:shop animated:YES];
}
#pragma mark -- 在滑动手势删除某一行的时候，显示出更多的按钮

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 移除收藏
    WS(weakSelf)
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"移除收藏"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        
        [weakSelf removeCollection:weakSelf.model.dataModel[indexPath.row]];
        
    }];
    
    
    //加入购物车
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"加入购物车"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        
         [weakSelf getGoodsPropertyData:weakSelf.model.dataModel[indexPath.row]];
        
        
    }];
    
    //将设置好的按钮放到数组中返回
    return@[deleteRowAction,moreRowAction];
    
}


@end
