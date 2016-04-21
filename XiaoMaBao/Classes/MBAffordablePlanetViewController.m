//
//  MBAffordablePlanetViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetViewController.h"
#import "MBCollectionHeadView.h"
#import "MBAffordablePlanetOneCell.h"
#import "MBAffordablePlanetThreeCell.h"
#import "MBAffordablePlanetTwoCell.h"
#import "MBShopingViewController.h"
#import "MBActivityViewController.h"

@interface MBAffordablePlanetViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

{
    NSDictionary *_dataDictionary;
    NSArray *_bandImageArray;
    NSMutableArray *_today_recommend;
    NSArray *_allShopArray;
    NSMutableArray *_recommend_goods;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MBAffordablePlanetViewController
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBAffordablePlanetViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBAffordablePlanetViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    _recommend_goods = [NSMutableArray array];
    _today_recommend  = [NSMutableArray array];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBAffordablePlanetOneCell" bundle:nil] forCellWithReuseIdentifier:@"MBAffordablePlanetOneCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBAffordablePlanetTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBAffordablePlanetTwoCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBAffordablePlanetThreeCell" bundle:nil] forCellWithReuseIdentifier:@"MBAffordablePlanetThreeCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView3"];
 
    [self setData];
    
    _page = 2;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    
    // 设置footer
    self.collectionView.mj_footer = footer;
}
#pragma mark -- 请求数据
- (void)setData{
    
    [self show];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/AffordablePlanet/index"];
    
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
     NSLog(@"%@ ",responseObject);
        
        if (responseObject) {
            _bandImageArray = [responseObject valueForKey:@"today_recommend_top"];
            [_today_recommend addObject:@[@{@"ad_img":[responseObject valueForKey:@"group_buy_img"]}]];
            [_today_recommend addObject:[responseObject valueForKey:@"today_recommend_mid"]];
            [_today_recommend addObject:[responseObject valueForKey:@"today_recommend_bot"]];
            _allShopArray = [responseObject valueForKey:@"category"];
            [_recommend_goods addObjectsFromArray:[responseObject valueForKey:@"recommend_goods"]];
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
#pragma mark -- 上拉加载数据
- (void)setheadData{
    
    [self show];
    
   
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@%@",BASE_URL_root,@"/AffordablePlanet/recommend_goods/",page];
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];

     
        if ([responseObject count]>0) {
            
            [_recommend_goods addObjectsFromArray:[responseObject valueForKey:@"recommend_goods"]];
            _page++;
            [self.collectionView reloadData];
            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.collectionView .mj_footer endRefreshing];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    NSInteger ad_type =[ _bandImageArray[index][@"ad_type"] integerValue];
    switch (ad_type) {
        case 1:
        {
            MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
            
 
            categoryVc.title = _bandImageArray[index][@"act_name"];
            categoryVc.act_id = _bandImageArray[index][@"act_id"];
            [self pushViewController:categoryVc Animated:YES];
        
        }
            break;
            
        default:
            break;
    }
}

#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section==2) {
        return 9;
    }
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return   UIEdgeInsetsMake(10, 9, 10, 9);
    }
     return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        
        if (indexPath.section == 0) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1" forIndexPath:indexPath];
            NSMutableArray *urlImageArray= [NSMutableArray array];
            for (NSDictionary *dic in _bandImageArray) {
                [urlImageArray addObject:dic[@"ad_img"]];
            }
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_WIDTH*33/75) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
            cycleScrollView.imageURLStringsGroup = urlImageArray;
            cycleScrollView.autoScrollTimeInterval = 3.0f;
            [reusableview addSubview:cycleScrollView];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            headView.tishi.text = @"每日必看";
            [reusableview addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cycleScrollView.mas_bottom).offset(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(31);
            }];
            
            return reusableview;
        }else if(indexPath.section == 1){
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2" forIndexPath:indexPath];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            [reusableview addSubview:headView];
                 headView.tishi.text = @"全部分类";
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(31);
            }];
            return reusableview;
        }else{
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView3" forIndexPath:indexPath];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            [reusableview addSubview:headView];
                 headView.tishi.text = @"推荐单品";
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(31);
            }];
            return  reusableview;
        }
        
    }
    
    return nil;
}






- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else{
        
        return _recommend_goods.count;
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MBAffordablePlanetOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetOneCell" forIndexPath:indexPath];
        cell.dataArray = _today_recommend;
        cell.VC = self;
        return cell;
       
    }else if(indexPath.section == 1){
        MBAffordablePlanetTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetTwoCell" forIndexPath:indexPath];
        cell.dataArray = _allShopArray;
        cell.VC =self;
        return cell;
        
    }else{
        MBAffordablePlanetThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetThreeCell" forIndexPath:indexPath];
        [cell.showImageVIew sd_setImageWithURL:[NSURL URLWithString:_recommend_goods[indexPath.item][@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.describeLabel.text = _recommend_goods[indexPath.item][@"goods_name"];
        cell.shop_price.text  = [NSString stringWithFormat:@"¥ %@",_recommend_goods[indexPath.item][@"goods_price"]];
        return cell;
        
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==2) {
        MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
        shopDetailVc.GoodsId = _recommend_goods[indexPath.item][@"goods_id"];
        [self pushViewController:shopDetailVc Animated:YES];

        
        
    }
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, 40+(UISCREEN_WIDTH-28)/3*232/195+(UISCREEN_WIDTH-23)/2*160/299*2+UISCREEN_WIDTH*231/642);
    }else if(indexPath.section == 1){
        return  CGSizeMake(UISCREEN_WIDTH , ((UISCREEN_WIDTH-18)/4+21)*2);
    }else{
        
        return  CGSizeMake((UISCREEN_WIDTH-27)/2,(UISCREEN_WIDTH-47)/2+62);
    }
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*33/75+31);
    }else if(section == 1){
        return CGSizeMake(UISCREEN_WIDTH, 31);
    }else{
        return CGSizeMake(UISCREEN_WIDTH, 31);
    }
    
}

@end
