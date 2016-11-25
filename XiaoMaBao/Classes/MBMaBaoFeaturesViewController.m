//
//  MBMaBaoFeaturesViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/10/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMaBaoFeaturesViewController.h"
#import "MBMaBaoFeaturesBrandCell.h"
#import "MBMaBaoFeaturesShopCell.h"
#import "MBShopingViewController.h"
#import "MBBrandDetailsViewController.h"
#import "MBMaBaoFeaturesModel.h"
@interface MBMaBaoFeaturesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) MaBaoFeaturesModel *model;
@end

@implementation MBMaBaoFeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    [self requestData];
}
- (void)requestData{
    
    [self show];
    
    
    [MBNetworking newGET:@"http://api.xiaomabao.com/feature/index" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dismiss];
        
        _model = [MaBaoFeaturesModel yy_modelWithJSON:responseObject];
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MBBrandDetailsViewController *VC = (MBBrandDetailsViewController *)segue.destinationViewController;
    FeatureModel *model = (FeatureModel *)sender;
    VC.type = model.type;
    VC.ID = model.ID;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _model?2:0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _model.feature.count;
    }else{
        
        return _model.hot_goods.count;
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 1) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
            reusableview.backgroundColor = [UIColor whiteColor];
            [self addTopLineView:reusableview];
            [self addBottomLineView:reusableview];
            YYLabel *lable = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 45)];
            lable.font = YC_RTWSYueRoud_FONT(15);
            lable.textAlignment = 1;
            lable.textColor = [UIColor colorWithHexString:@"999999"];
            lable.text = @"精选商品";
            [reusableview addSubview:lable];
            
            
            return reusableview;
            
        }
        
    }
    
    return [[UICollectionReusableView alloc] init];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MBMaBaoFeaturesBrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMaBaoFeaturesBrandCell" forIndexPath:indexPath];
        cell.imgUrl = _model.feature[indexPath.row].img;
        return cell;
    }
    
    MBMaBaoFeaturesShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMaBaoFeaturesShopCell" forIndexPath:indexPath];
    cell.model = _model.hot_goods[indexPath.row];
    [self addBottomLineView:cell];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
        shopDetailVc.GoodsId = _model.hot_goods[indexPath.row].goods_id;
        [self pushViewController: shopDetailVc Animated:YES];
        
    }else{
        
        [self performSegueWithIdentifier:@"MBBrandDetailsViewController" sender:_model.feature[indexPath.row]];
        
    }
    
}
#pragma mark <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return 15;
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return UIEdgeInsetsMake(10, 8, 10, 8);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return  CGSizeMake((UISCREEN_WIDTH - 16 -15)/2,(UISCREEN_WIDTH - 16 -15)/2*212/344);
    }
    return  CGSizeMake(UISCREEN_WIDTH,133);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return CGSizeMake(UISCREEN_WIDTH, 45);
    }
    return CGSizeMake(0, 0);
    
}

@end
