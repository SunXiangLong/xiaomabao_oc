//
//  MBGoodSSearchViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBGoodSSearchViewController.h"
#import "MBCategoryViewTwoCell.h"
#import "MBShopingViewController.h"
@interface MBGoodSSearchViewController (){
  
    NSArray *_keywordArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger page;
@property (strong,nonatomic) NSString *searchText;
@property (strong, nonatomic) NSMutableArray *recommend_goods;
@end

@implementation MBGoodSSearchViewController
-(NSMutableArray *)recommend_goods{
    if (!_recommend_goods) {
        _recommend_goods = [NSMutableArray array];
    }
    return _recommend_goods;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    [self refreshData];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewTwoCell"];
    [self refreshLoading];
    WS(weakSelf)
    self.didSearchBlock =  ^(MBSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        weakSelf.page = 1;
        weakSelf.searchText = searchText;
        [weakSelf.recommend_goods removeAllObjects];
        [weakSelf.collectionView reloadData];
        [weakSelf searchData];
    };
    
}

-(void)refreshData{
    [self show];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/search/recommond"];
    
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        
        if (responseObject) {
           
            
            
             self.hotSearches = responseObject[@"keywords"];
            self.hotSearchStyle =  PYHotSearchStyleColorfulTag;
            self.searchBar.placeholder = @"请输入要搜索商品名称";
            self.hotSearchHeader.text = @"大家都在搜";
           
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];

}
#pragma mark -- 上拉加载
- (void)refreshLoading{
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchData)];
    footer.refreshingTitleHidden = YES;
    self.collectionView.mj_footer = footer;
}
- (void)searchData{
    {//搜索数据
        NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];
        NSDictionary *params = @{@"keywords":self.searchText,@"having_goods":@"false"};
        NSDictionary *pagination = @{@"count":@"10",@"page":page};
        [self show];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/search/index"] parameters:@{@"filter":params,@"pagination":pagination} success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
            [self dismiss];
            NSArray *arr = [responseObject valueForKeyPath:@"data"];
            [self.collectionView .mj_footer endRefreshing];
            [self.view bringSubviewToFront:self.collectionView];
            if (arr.count==0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
                
                return;
            }
            
            [self.recommend_goods addObjectsFromArray:arr];
            [self.collectionView reloadData];
            _page ++;
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
            [self show:@"请求失败" time:1];
        }];
        
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return   UIEdgeInsetsMake(3, 3, 3, 3);
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.recommend_goods.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _recommend_goods[indexPath.item];
    
    MBCategoryViewTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBCategoryViewTwoCell" forIndexPath:indexPath];
    [cell.showImageVIew sd_setImageWithURL:[NSURL URLWithString:dic[@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.describeLabel.text = dic[@"goods_name"];
    cell.shop_price.text =  dic[@"shop_price_formatted"];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _recommend_goods[indexPath.item];
    MBShopingViewController  *VC = [[MBShopingViewController alloc] init];
    VC.GoodsId = dic[@"goods_id"];
    [self.navigationController pushViewController:VC animated:NO];
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  CGSizeMake((UISCREEN_WIDTH-9)/2,(UISCREEN_WIDTH-9-29)/2+98);
    
}
@end
