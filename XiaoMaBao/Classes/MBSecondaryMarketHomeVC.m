//
//  MBSecondaryMarketHomeVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSecondaryMarketHomeVC.h"
#import "MBSecondaryMarketHomeTabCell.h"
#import "MBSearchSecondaryMarketVC.h"
#import "MBSecondaryMarketModel.h"

#import "MBAffordablePlanetCVCell.h"
#import "MBWebViewController.h"
#import "MBCheckInViewController.h"
#import "MBActivityViewController.h"
#import "MBCategoryViewController.h"
#import "MBGoodsDetailsViewController.h"
#import "MBGroupShopController.h"
#import "MBGoodsDetailsViewController.h"
@interface MBSecondaryMarketHomeVC ()<SDCycleScrollViewDelegate,UISearchBarDelegate>
{
    UIButton *_lastButon;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeadView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *shufflingView;
@property (strong, nonatomic) IBOutlet UIView *senheadView;
@property (weak, nonatomic) IBOutlet UIButton *recommendedBtn;
@property (weak, nonatomic) IBOutlet UIButton *nearBtn;
@property (nonatomic,strong) MBSecondaryMarketModel  *model;
@property (nonatomic,strong) NSMutableArray <secondaryMarketGoodsListModel *> *goodsListArray;
@end

@implementation MBSecondaryMarketHomeVC
-(NSMutableArray<secondaryMarketGoodsListModel *> *)goodsListArray{
    if (!_goodsListArray) {
        _goodsListArray = [NSMutableArray array];
    }
    return _goodsListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self requestData];
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)setUI{
    _lastButon = _recommendedBtn;
//    _tableViewHeadView.ml_height = UISCREEN_WIDTH *(35/75 + 17/75);
    _tableView.tableFooterView = [[UIView alloc] init];
    _shufflingView.delegate = self;
    _shufflingView.backgroundColor = [UIColor whiteColor];
    _shufflingView.autoScrollTimeInterval = 5.0f;
    _shufflingView.imageURLStringsGroup = @[];
    _shufflingView.placeholderImage = [UIImage imageNamed:@"placeholder_num3"];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(64 , 26.5, UISCREEN_WIDTH - 64*2, 30)];
    searchBar.placeholder = @"请输入要搜索商品名称";
    searchBar.backgroundImage = [UIImage imageNamed:@"PYSearch.bundle/clearImage"];
    searchBar.delegate = self;
    [self.navBar addSubview:searchBar];
}
- (IBAction)btnAction:(UIButton *)sender {
    if (![sender isEqual:_lastButon]) {
        
     
        [_lastButon setTitleColor:UIcolor(@"919293") forState:UIControlStateNormal];
        
        [sender setTitleColor:UIcolor(@"d67274") forState:UIControlStateNormal];
        
        _lastButon = sender;
        
        
    }
    
}
- (IBAction)messageCenter:(UIButton *)sender {
    
    NSString *sid  = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
        [self  loginClicksss:@"mabao"];
        return ;
    }
   
    if ( [MBSignaltonTool getCurrentUserInfo].isLogin) {
        [self performSegueWithIdentifier:@"MBSMMessageCenterVC" sender:nil];
    }else{
    
        [self show:@"授权登录失败，请退出重新登录" time:1];
    }
   
}

- (void)moreData{

    [self show];
    NSDictionary *parameters = @{@"page":s_Integer(_page)};
    if ([MBSignaltonTool getCurrentUserInfo].sessiondict) {
        parameters = @{@"session":[MBSignaltonTool getCurrentUserInfo].sessiondict,@"page":s_Integer(_page)};
    }
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/secondary/index") parameters:parameters success:^(id responseObject) {
        [self dismiss];
        [self.tableView.mj_footer endRefreshing];

        MBSecondaryMarketModel *model = [MBSecondaryMarketModel yy_modelWithDictionary:responseObject];
        if (model.goods_list.count > 0) {
             [self.goodsListArray addObjectsFromArray:model.goods_list];
             [self.tableView reloadData];
            _page ++;
        }else{
        
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败，请检查网络连接" time:1];
    }];

}
- (void)requestData{
    [self show];
    NSDictionary *parameters = @{};
    if ([MBSignaltonTool getCurrentUserInfo].sessiondict) {
        parameters = @{@"session":[MBSignaltonTool getCurrentUserInfo].sessiondict};
    }
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/secondary/index") parameters:parameters success:^(id responseObject) {
        [self dismiss];
        MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
        footer.refreshingTitleHidden = YES;
        self.tableView.mj_footer = footer;
        _page = 2;
        self.model = [MBSecondaryMarketModel yy_modelWithDictionary:responseObject];
        [self.goodsListArray addObjectsFromArray:_model.goods_list];
        NSMutableArray *urlImageArray= [NSMutableArray array];
        [self.model.today_recommend_top enumerateObjectsUsingBlock:^(todayRecommendTopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [urlImageArray addObject:obj.ad_img];
        }];
        
        
        _shufflingView.delegate = self;
        _shufflingView.backgroundColor = [UIColor whiteColor];
        _shufflingView.autoScrollTimeInterval = 5.0f;
        _shufflingView.imageURLStringsGroup = urlImageArray;
        _shufflingView.placeholderImage = [UIImage imageNamed:@"placeholder_num3"];
        
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败，请检查网络连接" time:1];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSInteger ad_type = [_model.today_recommend_top[index].ad_type integerValue];
    
    
    switch (ad_type) {
        case 1: {
            [MobClick event:@"AffordablePlane0"];
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _model.today_recommend_top[index].act_id;
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            [MobClick event:@"AffordablePlane0"];
            MBGoodsDetailsViewController *VC = [[MBGoodsDetailsViewController alloc] init];
            VC.GoodsId  = _model.today_recommend_top[index].act_id;
            VC.title = _model.today_recommend_top[index].ad_name;
            [self pushViewController:VC Animated:YES];
        }break;
        case 3: {
            [MobClick event:@"AffordablePlane0" attributes:@{@"WebUrl":@"网页活动"}];
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:_model.today_recommend_top[index].act_img];
            VC.title = _model.today_recommend_top[index].ad_name;
            VC.isloging = YES;
            
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 4: {
            [MobClick event:@"AffordablePlane0"];
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            VC.title = _model.today_recommend_top[index].ad_name;
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 5: {
            
        }break;
        default: break;
    }

}
#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_goodsListArray) {
      return 1;
    }
    
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goodsListArray.count;
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return  0;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return  0.001;
//
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    return UISCREEN_WIDTH * 35/75 + 170;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    return _senheadView;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBSecondaryMarketHomeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBSecondaryMarketHomeTabCell" forIndexPath:indexPath];
    cell.model = _goodsListArray[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
#pragma mark --UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    MBSearchSecondaryMarketVC *searchViewController = [[MBSearchSecondaryMarketVC alloc] init:PYSearchResultShowModeSecondaryMarket];
    searchViewController.hotSearches = @[@"电视机",@"山地车",@"床头柜",@"电风扇",@"空调",@"电脑",@"夏天衣服"];
    searchViewController.baseSearchTableView.hidden = false;
    searchViewController.hotSearchStyle =  PYHotSearchStyleColorfulTag;
    searchViewController.searchBar.placeholder = @"输入你正在找的宝贝";
    searchViewController.hotSearchHeader.text = @"大家都在搜";
    MBNavigationViewController *nav = [[MBNavigationViewController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"mm_navGroundImage"] forBarMetrics:UIBarMetricsDefault];
   
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:nav  animated:NO completion:nil];
   
    
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
