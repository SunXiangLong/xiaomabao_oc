//
//  MBAffordablePlanetViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewFreeStoreViewController.h"
#import "MBCollectionHeadView.h"
#import "MBShopingViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
#import "MBMBAffordablePlanetOneChildeOneCell.h"
#import "MBFreeStoreViewOneCell.h"
#import "MBAffordablePlanetViewCell.h"
#import "MBDetailedViewController.h"
#import "MBAffordablePlanetNewViewCell.h"
@interface MBNewFreeStoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

{
 
    NSArray *_bandImageArray;
    NSMutableArray *_today_recommend_bot;
    /**
     *  国家馆数据
     */
    NSArray *_category;
    /**
     *  轮播图下滑动商品数据
     */
    NSArray *_recommend_goods;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) NSMutableArray *today_recommend_bo;
@end

@implementation MBNewFreeStoreViewController
-(NSMutableArray *)today_recommend_bot{
    
    if (!_today_recommend_bot) {
        _today_recommend_bot = [NSMutableArray array];
        
    }
    return _today_recommend_bot;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    

    [_collectionView registerNib:[UINib nibWithNibName:@"MBAffordablePlanetViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBAffordablePlanetViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBMBAffordablePlanetOneChildeOneCell" bundle:nil] forCellWithReuseIdentifier:@"MBMBAffordablePlanetOneChildeOneCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBAffordablePlanetNewViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBAffordablePlanetNewViewCell"];
    
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView3"];
    
    [self setData];
  
}
#pragma mark -- 请求数据
- (void)setData{
    
    [self show];
NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/TaxfreeStore/index2"];
    
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        
        if (responseObject) {
            _today_recommend_bot = [NSMutableArray array];
            _bandImageArray = [responseObject valueForKey:@"today_recommend_top"];
        [self.today_recommend_bot addObjectsFromArray:[responseObject valueForKeyPath:@"today_recommend_bot"]];
            _recommend_goods = [responseObject  valueForKeyPath:@"recommend_goods"];
            _category = [responseObject valueForKey:@"category"];
           
        
            
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
      MMLog(@"%@",@"收到内存⚠️");
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
    
    NSInteger ad_type = [_bandImageArray[index][@"ad_type"] integerValue];
    
    
    switch (ad_type) {
        case 1: {
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _bandImageArray[index][@"act_id"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            
            MBShopingViewController *VC = [[MBShopingViewController alloc] init];
            VC.GoodsId = _bandImageArray[index][@"ad_con"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 3: {
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:_bandImageArray[index][@"ad_con"]];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 4: {
            
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            VC.title = _bandImageArray[index][@"ad_name"];
            
            [self pushViewController:VC Animated:YES];
            
        }break;
     
        default: break;
    }
    
}

#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if(section == 1){
        return 15;
    }
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return   UIEdgeInsetsMake(15, 8, 15, 8);
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
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_WIDTH*35/75) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
            cycleScrollView.imageURLStringsGroup = urlImageArray;
            cycleScrollView.autoScrollTimeInterval = 3.0f;
            [reusableview addSubview:cycleScrollView];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            headView.tishi.text = @"麻包推荐";
            [reusableview addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cycleScrollView.mas_bottom).offset(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(50);
            }];
            
            return reusableview;
        }else if(indexPath.section == 1){
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2" forIndexPath:indexPath];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            [reusableview addSubview:headView];
            headView.tishi.text = @"国家馆";
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(50);
            }];
            return reusableview;
        }else{
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView3" forIndexPath:indexPath];
            MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
            [reusableview addSubview:headView];
            headView.tishi.text = @"精选活动";
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(50);
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
    }else if(section ==1){
        return _category.count;
    }
    
    return _today_recommend_bot.count;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        MBMBAffordablePlanetOneChildeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMBAffordablePlanetOneChildeOneCell" forIndexPath:indexPath];
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:_category[indexPath.item][@"c_img"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
       
        return cell;
        
    }else if (indexPath.section ==0){
    
        MBAffordablePlanetNewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetNewViewCell" forIndexPath:indexPath];
 
        cell.dataArr = _recommend_goods;
        cell.act_id =  _today_recommend_bot[0][@"act_id"];
        cell.act_name = _today_recommend_bot[0][@"act_name"];
        cell.VC = self;
        
        return cell;
    
    }
    
    MBAffordablePlanetViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetViewCell" forIndexPath:indexPath];

    return cell;
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MBAffordablePlanetViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        [cell.showImage sd_setImageWithURL:URL(_today_recommend_bot[indexPath.item][@"ad_img"]) placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
        cell.act_id =  _today_recommend_bot[indexPath.item][@"act_id"];
        cell.act_name = _today_recommend_bot[indexPath.item ][@"act_name"];
        cell.VC = self;
        cell.dataArr = _today_recommend_bot[indexPath.item][@"goods"];
        [cell.collerctionView reloadData];
    }


}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
       
  
            MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
            categoryVc.title = _today_recommend_bot[indexPath.item][@"act_name"];
            categoryVc.act_id = _today_recommend_bot[indexPath.item][@"act_id"];
            [self pushViewController:categoryVc Animated:YES];
        
    }else if(indexPath.section == 1 ){
        NSDictionary *dic  =   _category  [indexPath.item];
        MBDetailedViewController  *VC = [[MBDetailedViewController alloc] init];
        VC.cat_id =  dic[@"c_id"];
        VC.title = dic[@"c_name"];
        VC.countries  = dic[@"c_name"];
        [self  pushViewController:VC Animated:YES];

    
    }
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        return CGSizeMake(UISCREEN_WIDTH,  155);
        
    }else if(indexPath.section == 1){
        
     return CGSizeMake((UISCREEN_WIDTH-15-16)/2 , (UISCREEN_WIDTH-15-16)/2*213/348);
    
    }
    

    
   return CGSizeMake(UISCREEN_WIDTH,  155 + UISCREEN_WIDTH *35/75+15);
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(UISCREEN_WIDTH,UISCREEN_WIDTH*35/75+50);
    }else if(section == 1){
        return CGSizeMake(UISCREEN_WIDTH, 50);
    }else{
        return CGSizeMake(UISCREEN_WIDTH, 50);
    }
    
}

@end
