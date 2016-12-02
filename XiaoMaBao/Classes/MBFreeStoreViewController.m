//
//  MBFreeStoreViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBFreeStoreViewController.h"
#import "MBAffordablePlanetTabCell.h"
#import "MBAffordablePlanetCVCell.h"
#import "MBWebViewController.h"
#import "MBSharkViewController.h"
#import "MBCheckInViewController.h"
#import "MBActivityViewController.h"
#import "MBDetailedViewController.h"
#import "MBShopingViewController.h"
#import "MBGroupShopController.h"

@interface MBFreeStoreViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *shufflingView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FreeStoreModel *model;
@property (copy, nonatomic) NSMutableDictionary *contentOffsetDictionary;
@end

@implementation MBFreeStoreViewController
-(NSMutableDictionary *)contentOffsetDictionary{
    if (!_contentOffsetDictionary) {
        _contentOffsetDictionary = [NSMutableDictionary dictionary];
    }
    
    return _contentOffsetDictionary;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _headView.ml_height = UISCREEN_WIDTH *35/75;
    [self requestData];
    
}
#pragma mark -- 请求数据
- (void)requestData{
    
    [self show];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/TaxfreeStore/index2"];
    
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        [self dismiss];
        
        if (responseObject) {
            _model = [FreeStoreModel yy_modelWithJSON:responseObject];
            NSMutableArray *urlImageArray= [NSMutableArray array];
            [_model.today_recommend_top enumerateObjectsUsingBlock:^(TodayRecommendTopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [urlImageArray addObject:obj.ad_img];
            }];
        
            
            _shufflingView.delegate = self;
            _shufflingView.backgroundColor = [UIColor whiteColor];
            _shufflingView.autoScrollTimeInterval = 5.0f;
            _shufflingView.imageURLStringsGroup = urlImageArray;
            _shufflingView.placeholderImage = [UIImage imageNamed:@"placeholder_num3"];
            _headView.hidden = false;
            
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
        
        
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark ----- SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSInteger ad_type = [_model.today_recommend_top[index].ad_type integerValue];
    
    
    switch (ad_type) {
        case 1: {
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _model.today_recommend_top[index].act_id;
            
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            
            MBShopingViewController *VC = [[MBShopingViewController alloc] init];
            VC.GoodsId  = _model.today_recommend_top[index].ad_con;
            VC.title = _model.today_recommend_top[index].ad_name;
            [self pushViewController:VC Animated:YES];
        }break;
        case 3: {
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:_model.today_recommend_top[index].ad_con];
            VC.title = _model.today_recommend_top[index].ad_name;
            VC.isloging = YES;
            
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 4: {
            
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
    
    if (_model) {
        return  3;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return _model.today_recommend_bot.count;
    }
    
    return 1;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  170;
    }
    if (indexPath.section == 1) {
        NSInteger cont = _model.category.count/2;
        NSInteger num = _model.category.count%2;
        if (num != 0) {
            cont ++;
        }
        return   (UISCREEN_WIDTH - 15 - 16) / 2 * 213 / 348 *cont  + (cont+1) * 15;
    }
    
    return UISCREEN_WIDTH * 35/75 + 170;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 5)];
    view.backgroundColor = UIcolor(@"ececec");
    [headView addSubview:view];
    
    YYLabel *lable = [[YYLabel alloc] initWithFrame:CGRectMake(0, 5, UISCREEN_WIDTH, 45)];
    lable.font = YC_RTWSYueRoud_FONT(15);
    lable.backgroundColor = [UIColor whiteColor];
    lable.textColor = UIcolor(@"575757");
    lable.textAlignment = 1;
    lable.text = @"- 麻包推荐 -";
    [headView addSubview:lable];
    [self addBottomLineView:headView];
    if (section == 1) {
        lable.text = @"- 国家馆 -";
    }
    if (section == 2) {
        lable.text = @"- 精选活动 -";
    }
    
    return headView;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MBFreeStoreTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBFreeStoreTabCell" forIndexPath:indexPath];
        cell.contentOffsetDictionary = self.contentOffsetDictionary;
        return cell;
    }
    if (indexPath.section == 1) {
        MBAffordablePlanetTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAffordablePlanetTabCell" forIndexPath:indexPath];
        return cell;
    }
    MBAffordablePlanetTabToCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAffordablePlanetTabToCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    cell.contentOffsetDictionary = self.contentOffsetDictionary;
    cell.model = _model.today_recommend_bot[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
    
    categoryVc.act_id =  _model.today_recommend_bot[indexPath.row].act_id;
    [self pushViewController:categoryVc Animated:YES];
    
    
}
#pragma mark --UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_model) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 0) {
        return  _model.recommend_goods.count;
    }
    if (collectionView.tag == 1) {
       return _model.category.count;
    }
    MBAffordablePlanetCV *CV = (MBAffordablePlanetCV *)collectionView;
    return _model.today_recommend_bot[CV.indexPath.row].goods.count;
    
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MBAffordablePlanetCV *CV = (MBAffordablePlanetCV *)collectionView;
    
    
    if (collectionView.tag == 1) {
        MBAffordablePlanetCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetCVCell" forIndexPath:indexPath];
        cell.countrieModel = _model.category[indexPath.item];
        return cell;
    }
    GoodModel *model =  nil;
    if (collectionView.tag == 0) {
        model = _model.recommend_goods[indexPath.item];
    }
    if (collectionView.tag == 2) {
        model = _model.today_recommend_bot[CV.indexPath.row].goods[indexPath.item];
    }
    MBAffordablePlanetCVToCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetCVToCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 1) {
        
        MBDetailedViewController *VC = [[MBDetailedViewController alloc] init];
        VC.cat_id = _model.category[indexPath.item].c_id;
        VC.countries  = true;
        [self pushViewController:VC Animated:YES];
    }else{
        MBAffordablePlanetCV *CV = (MBAffordablePlanetCV *)collectionView;
        GoodModel *model =  nil;
        if (collectionView.tag == 0) {
            model = _model.recommend_goods[indexPath.item];
        }
        if (collectionView.tag == 2) {
            model = _model.today_recommend_bot[CV.indexPath.row].goods[indexPath.item];
        }
        
        
        MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
        shopDetailVc.GoodsId =  model.goods_id;
        shopDetailVc.title = model.goods_name;
        [self pushViewController:shopDetailVc Animated:YES];
    }
    
}

#pragma mark --UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    MBAffordablePlanetCV *collectionView = (MBAffordablePlanetCV *)scrollView;
   
    if (scrollView.tag == 0) {
    self.contentOffsetDictionary[@"top"] = @(horizontalOffset);
    }else{
     NSInteger index = collectionView.indexPath.row;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
    }
    
    
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
