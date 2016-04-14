//
//  MBSearchShowViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBSearchShowViewController.h"
#import "MBCategoryViewTwoCell.h"
#import "MBShopingViewController.h"
@interface MBSearchShowViewController ()
{
    NSMutableArray *_recommend_goods;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MBSearchShowViewController
-(void)viewWillDisappear:(BOOL)animated
{
   
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBSearchShowViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBSearchShowViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshLoading];
    _recommend_goods = [NSMutableArray arrayWithArray:self.dataArr];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewTwoCell"];
    _page = 2;
    
}
#pragma mark -- 上拉加载
- (void)refreshLoading{
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchData)];
    footer.refreshingTitleHidden = YES;
    self.collectionView.mj_footer = footer;
}
- (void)searchData{
    {//搜索数据
        NSString *page = [NSString stringWithFormat:@"%ld",_page];
        NSDictionary *params = @{@"keywords":self.title,@"having_goods":@"false"};
        NSDictionary *pagination = @{@"coun":@"20",@"page":page};
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"search"] parameters:@{@"filter":params,@"pagination":pagination} success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
    
            
            NSArray *arr = [responseObject valueForKeyPath:@"data"];
                [self.collectionView .mj_footer endRefreshing];
            
            if (arr.count==0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
                
                return;
            }else{
                NSString *str1 = [arr lastObject][@"goods_id"];
                NSString *str2 = [_recommend_goods lastObject][@"goods_id"];
                
                
                
                
                if ([str1 isEqualToString:str2]) {
                    
                    
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                    
                    return;
                }
                
            }
            
            NSMutableArray *indexArray = [NSMutableArray array];
            for (NSInteger i =_recommend_goods.count; i<arr.count+_recommend_goods.count; i++) {
                [indexArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            }
            
            [_recommend_goods addObjectsFromArray:arr];
            [self.collectionView insertItemsAtIndexPaths:indexArray];
            
            
            _page ++;
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self show:@"请求失败" time:1];
        }];
        
        
    }

}
-(NSString *)titleStr{
    
    return self.title?:@"";
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _recommend_goods.count;
    
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
    [self pushViewController:VC Animated:YES];
    
    
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  CGSizeMake((UISCREEN_WIDTH-9)/2,(UISCREEN_WIDTH-9-29)/2+98);
    
}

@end
