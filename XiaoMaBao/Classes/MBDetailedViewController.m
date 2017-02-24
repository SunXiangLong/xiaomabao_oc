//
//  MBDetailedViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBDetailedViewController.h"
#import "XWCatergoryView.h"
#import "MBCategoryViewTwoCell.h"
#import "MBGoodsDetailsViewController.h"
#import "MBGoodSSearchViewController.h"
@interface MBDetailedViewController ()<XWCatergoryViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
{
    NSInteger _page;
    NSArray *_meunArray;
    
    UIButton *_lastBtn;
    BOOL _isOnePriceBtn;
    
    NSString *_priceStored;
    NSString *_type;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (copy, nonatomic) NSMutableArray *recommend_goods;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation MBDetailedViewController
- (NSMutableArray *)recommend_goods{
    if (!_recommend_goods) {
        _recommend_goods = [NSMutableArray array];
    }
    return _recommend_goods;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchUI];
    [self refreshLoading];
    [self addBottomLineView:_topView];
    _page =1;
    _lastBtn = _defaultBtn;
    _priceStored = @"";
    _meunArray = @[@"default",@"salesnum",@"new"];
    _type = _meunArray.firstObject;
    [self setData];
}
- (void)searchUI{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(64 , 26.5, UISCREEN_WIDTH - 64*2, 30)];
    searchBar.placeholder = @"请输入要搜索商品名称";
    searchBar.backgroundImage = [UIImage imageNamed:@"PYSearch.bundle/clearImage"];
    searchBar.delegate = self;
    [self.navBar addSubview:searchBar];
}

- (IBAction)btn:(UIButton *)sender {
    
    if (sender.tag == 3 ) {
        _lastBtn.selected = false;
        _lastBtn = nil;
        if (!_isOnePriceBtn) {
            _isOnePriceBtn = true;
            [_priceBtn setImage:[UIImage imageNamed:@"priceSortedUP"] forState:UIControlStateNormal];
            _priceStored = @"asc";
        }else{
            if (sender.selected) {
                sender.selected = false;
                _priceStored = @"asc";
            }else{
                sender.selected = true;
                _priceStored = @"desc";
            }
            
        }
        _page = 1;
        [_recommend_goods removeAllObjects];
        _type = @"price";
        [self setData];
    }else{
        [_priceBtn setImage:[UIImage imageNamed:@"priceSortedDefault"] forState:UIControlStateNormal];
        _priceBtn.selected = false;
        _isOnePriceBtn = false;
        _priceStored = @"";
        if ([_lastBtn isEqual:sender]) {
            return;
        }
        sender.selected = true;
        if (_lastBtn) {
            _lastBtn.selected = false;
        }
        _lastBtn = sender;
        if (![_type isEqualToString:_meunArray[sender.tag]]) {
            _page = 1;
            [_recommend_goods removeAllObjects];
            _type = _meunArray[sender.tag];
            [self setData];
            
        }
    }
    
    
}
#pragma mark -- 上拉加载
- (void)refreshLoading{
    
      [_collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewTwoCell"];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
    
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
    NSString *url;
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    if (self.countries) {
      url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/taxfreeStore/goods_list/",self.cat_id,page,_type];
    }else{
    url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/AffordablePlanet/get_category_goods/",self.cat_id,page,_type];
    }
    [MBNetworking newGET:url parameters:@{@"sort":_priceStored} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        MMLog(@"%@ ",responseObject);
        
           [self.collectionView .mj_footer endRefreshing];
        if (responseObject) {
            if ([[responseObject valueForKey:@"goods_list"] count]>0) {
                [self.recommend_goods addObjectsFromArray:[responseObject valueForKey:@"goods_list"]];
                
                
                _page ++;
                [self.collectionView    reloadData];
            }else{
                [self.collectionView    reloadData];
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
           
            
         
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];

        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
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
    NSDictionary *dic;
    if (_recommend_goods.count > 0) {
        dic = _recommend_goods[indexPath.item];
    }else{
        return nil;
    }
    
    MBCategoryViewTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBCategoryViewTwoCell" forIndexPath:indexPath];
    [cell.showImageVIew sd_setImageWithURL:[NSURL URLWithString:dic[@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.describeLabel.text = dic[@"goods_name"];
    cell.shop_price.text = [NSString stringWithFormat:@"¥ %@",dic[@"goods_price"]];
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
     NSDictionary *dic = _recommend_goods[indexPath.item];
     MBGoodsDetailsViewController  *VC = [[MBGoodsDetailsViewController alloc] init];
     VC.GoodsId = dic[@"goods_id"];
    [self pushViewController:VC Animated:YES];
        
    
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    
    return  CGSizeMake((UISCREEN_WIDTH-9)/2,(UISCREEN_WIDTH-9-29)/2+98);
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    MBGoodSSearchViewController *searchViewController = [[MBGoodSSearchViewController alloc] init:NO];
    searchViewController.hotSearches = @[@""];
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
