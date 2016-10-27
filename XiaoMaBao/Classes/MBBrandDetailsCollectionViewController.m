//
//  MBBrandDetailsCollectionViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBrandDetailsCollectionViewController.h"
#import "MBBrandDetailsCollectionViewCell.h"
#import "MBBrandDetailsCollectionViewReusableView.h"
#import "MBShopingViewController.h"
@interface MBBrandDetailsCollectionViewController ()
{
    MBProgressHUD *_hud;
    NSInteger _page;
    NSDictionary *_brandDic;
}
@property (nonatomic,copy)NSMutableArray *goodsArray;
@end

@implementation MBBrandDetailsCollectionViewController

-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
        
    }
    return _goodsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self requestData];
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    footer.refreshingTitleHidden = YES;
    self.collectionView.mj_footer = footer;
    
}
- (void)requestData{
    [self show];
    [MBNetworking POSTOrigin:@"http://api.xiaomabao.com/feature/detail" parameters:@{@"type":_type,@"id":_ID,@"page":s_Integer(_page)} success:^(id responseObject) {
        [self dismiss];
        [self.collectionView.mj_footer endRefreshing];
        
        if ([responseObject[@"goods_list"] count] > 0) {
            if (_page == 1) {
                _brandDic = responseObject[@"brand"];
                
                
            }
            [self.goodsArray addObjectsFromArray:responseObject[@"goods_list"]];
            _page++;
            [self.collectionView reloadData];
        }else{
            [self.collectionView.mj_footer  endRefreshingWithNoMoreData];
            return ;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
    
}
-(void)show{
    
    UIView *view = [[UIApplication   sharedApplication] keyWindow];
    _hud = [[MBProgressHUD alloc] initWithView:view];
    [self.navigationController.view addSubview:_hud];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud show:YES];
    });
}
-(void)show:(NSString *)str time:(NSInteger)timer{
    
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
-(void)dismiss{
    
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
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.goodsArray.count;
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        MBBrandDetailsCollectionViewReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MBBrandDetailsCollectionViewReusableView" forIndexPath:indexPath];
        
        reusableview.dataDic = _brandDic;
        return reusableview;
        
        
        
    }
    
    return [[UICollectionReusableView alloc] init];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBBrandDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBBrandDetailsCollectionViewCell" forIndexPath:indexPath];
    cell.dataDic = _goodsArray[indexPath.row];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
    shopDetailVc.GoodsId = _goodsArray[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:shopDetailVc animated:YES];
    
    
}
#pragma mark <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 3, 5, 3);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake((UISCREEN_WIDTH - 9)/2,(UISCREEN_WIDTH - 9)/2 + 90);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat height = [_brandDic[@"brand_desc"] sizeWithFont:SYSTEMFONT(12) lineSpacing:2 withMax:UISCREEN_WIDTH- 40];
    return CGSizeMake(UISCREEN_WIDTH, 90 + height );
}

@end
