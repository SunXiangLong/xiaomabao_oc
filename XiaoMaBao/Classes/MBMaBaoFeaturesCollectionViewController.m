//
//  MBMaBaoFeaturesCollectionViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMaBaoFeaturesCollectionViewController.h"
#import "MBMaBaoFeaturesBrandCell.h"
#import "MBMaBaoFeaturesShopCell.h"
#import "MBShopingViewController.h"
#import "MBBrandDetailsViewController.h"
@interface MBMaBaoFeaturesCollectionViewController ()

{

MBProgressHUD *_hud;
}
@property (nonatomic,copy)NSArray *goodsArray;
@property (nonatomic,copy)NSArray *brandArray;
@end

@implementation MBMaBaoFeaturesCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    
}

- (void)requestData{
    [self show];
       [MBNetworking newGET:@"http://api.xiaomabao.com/feature/index" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           [self dismiss];
          // MMLog(@"%@",responseObject);
           _goodsArray = responseObject[@"hot_goods"];
           _brandArray = responseObject[@"feature"];
           [self.collectionView reloadData];
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           MMLog(@"%@",error);
           [self show:@"请求失败" time:1];
       }];

}
- (void)show{
    
    UIView *view = [[UIApplication   sharedApplication] keyWindow];
    _hud = [[MBProgressHUD alloc] initWithView:view];
    [self.navigationController.view addSubview:_hud];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud show:YES];
    });
    
    
}
- (void)show:(NSString *)str time:(NSInteger)timer{
    
    UIView *view = [[UIApplication   sharedApplication] keyWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.removeFromSuperViewOnHide = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES afterDelay:timer];
        [self dismiss];
    });
    
}
- (void)dismiss{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud hide:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _brandArray.count;
    }else{
    
        return _goodsArray.count;
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 1) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MBMaBaoFeaturesReusableView" forIndexPath:indexPath];
           
            return reusableview;

            }

    }

    return [[UICollectionReusableView alloc] init];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        MBMaBaoFeaturesBrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMaBaoFeaturesBrandCell" forIndexPath:indexPath];
        cell.imgUrl = _brandArray[indexPath.row][@"img"];
        return cell;
    }
    
    MBMaBaoFeaturesShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMaBaoFeaturesShopCell" forIndexPath:indexPath];
    cell.dataDic = _goodsArray[indexPath.row];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
        shopDetailVc.GoodsId = _goodsArray[indexPath.row][@"goods_id"];
        [self.navigationController pushViewController:shopDetailVc animated:YES];

    }else{
        MBBrandDetailsViewController *VC = [[MBBrandDetailsViewController alloc] init];
        VC.type = _brandArray[indexPath.row][@"type"];
        VC.ID = _brandArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:VC animated:YES];
        
        
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
    return  CGSizeMake(UISCREEN_WIDTH,95);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
         return CGSizeMake(UISCREEN_WIDTH, 45);
    }
   return CGSizeMake(0, 0);
    
    
}
@end
