//
//  MBBrandDetailsViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#import "MBBrandDetailsViewController.h"
#import "MBGoodSSearchViewController.h"
#import "MBBrandDetailsCollectionViewCell.h"
#import "MBBrandDetailsCollectionViewReusableView.h"
#import "MBShopingViewController.h"
#import "MBBrandDetailModel.h"
@interface MBBrandDetailsViewController ()<UISearchBarDelegate>{
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,copy) BrandDetailModel *model;
@end

@implementation MBBrandDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchUI];
    _page = 1;
    [self requestData];
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    footer.refreshingTitleHidden = YES;
    self.collectionView.mj_footer = footer;


}
- (void)searchUI{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(64 , 26.5, UISCREEN_WIDTH - 64*2, 30)];
    searchBar.placeholder = @"请输入要搜索商品名称";
    searchBar.backgroundImage = [UIImage imageNamed:@"PYSearch.bundle/clearImage"];
    searchBar.delegate = self;
    [self.navBar addSubview:searchBar];
    
    
}
- (void)requestData{
    [self show];
    [MBNetworking POSTOrigin:@"http://api.xiaomabao.com/feature/detail" parameters:@{@"type":_type,@"id":_ID,@"page":s_Integer((long)_page)} success:^(id responseObject) {
        [self dismiss];
        [self.collectionView.mj_footer endRefreshing];
        
        if ([responseObject[@"goods_list"] count] > 0) {
            if (_page == 1) {
                _model = [BrandDetailModel yy_modelWithJSON:responseObject];
            }else{
                [_model.goodsList addObjectsFromArray:[BrandDetailModel yy_modelWithJSON:responseObject].goodsList];
            }
            
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _model?1:0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _model.goodsList.count;
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        MBBrandDetailsCollectionViewReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MBBrandDetailsCollectionViewReusableView" forIndexPath:indexPath];
        
        reusableview.model = _model.brand;
        return reusableview;
        
        
        
    }
    
    return [[UICollectionReusableView alloc] init];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBBrandDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBBrandDetailsCollectionViewCell" forIndexPath:indexPath];
    cell.model = _model.goodsList[indexPath.item];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
    shopDetailVc.GoodsId = _model.goodsList[indexPath.item].goods_id;
    [self pushViewController:shopDetailVc Animated:true];
    
    
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
    CGFloat height = [_model.brand.brand_desc sizeWithFont:SYSTEMFONT(12) lineSpacing:2 withMax:UISCREEN_WIDTH- 40];
    return CGSizeMake(UISCREEN_WIDTH, 90 + height );
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    MBGoodSSearchViewController *searchViewController = [[MBGoodSSearchViewController alloc] init];
    searchViewController.hotSearches = @[@"美德乐", @"花王", @"跨境购", @"婴儿车", @"玩具",@"围巾", @"尿不湿",@"诺优能",@"特福芬",@"麦婴",@"奶瓶",@"行李箱",@"智高chicco"];
    searchViewController.hotSearchStyle =  PYHotSearchStyleColorfulTag;
    searchViewController.searchBar.placeholder = @"请输入要搜索商品名称";
    searchViewController.hotSearchHeader.text = @"大家都在搜";
    
    MBNavigationViewController *nav = [[MBNavigationViewController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"mm_navGroundImage"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:nav  animated:NO completion:nil];
    
    return NO;
}


@end
