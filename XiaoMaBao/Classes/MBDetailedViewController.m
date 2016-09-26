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
#import "MBShopingViewController.h"
@interface MBDetailedViewController ()<XWCatergoryViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _page;
    NSString *_type;
    NSArray *_meunArray;
    NSMutableArray *_recommend_goods;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MBDetailedViewController
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBDetailedViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBDetailedViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopView];
    [self refreshLoading];
    _page =1;


    _meunArray = @[@"default",@"salesnum",@"new",@"stock"];
    _recommend_goods = [NSMutableArray array];
    [self setData:_meunArray.firstObject];
}
#pragma mark -- 上拉加载
- (void)refreshLoading{
    
      [_collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewTwoCell"];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setRefre)];
    
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    
    // 设置footer
    self.collectionView.mj_footer = footer;
}
- (void)setTopView{
    XWCatergoryView * catergoryView = [[XWCatergoryView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 34)];
    catergoryView.titles = @[@"综合",@"销量",@"最新",@"只看有货"];;
    catergoryView.delegate = self;
    catergoryView.titleColorChangeGradually = YES;
    catergoryView.backEllipseEable = NO;
    catergoryView.bottomLineEable = YES;
    catergoryView.bottomLineColor = [UIColor colorWithHexString:@"c86a66"];
    catergoryView.bottomLineWidth = 3;
    catergoryView.titleFont = [UIFont boldSystemFontOfSize:14];
    catergoryView.bottomLineSpacingFromTitleBottom =8;
    catergoryView.titleColor = [UIColor colorWithHexString:@"333333"];
    catergoryView.titleSelectColor = [UIColor colorWithHexString:@"c86a66"];
    [self.topView addSubview:catergoryView];

}
#pragma mark --上拉用
- (void)setRefre{
    [self show];
    NSString *url;
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    if (self.countries) {
        url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/taxfreeStore/goods_list/",self.cat_id,page,_type];
    }else{
        url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/AffordablePlanet/get_category_goods/",self.cat_id,page,_type];
    }
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        MMLog(@"%@ ",responseObject);
        
        [self.collectionView .mj_footer endRefreshing];
        if (responseObject) {
            if ([[responseObject valueForKey:@"goods_list"] count]>0) {
                [_recommend_goods addObjectsFromArray:[responseObject valueForKey:@"goods_list"]];
                
                
                _page ++;
                [self.collectionView    reloadData];
            }else{
                
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
#pragma mark -- 请求数据
- (void)setData:(NSString *)type{
    _type = type;
    [self show];
    NSString *url;
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    if (self.countries) {
      url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/taxfreeStore/goods_list/",self.cat_id,page,_type];
    }else{
    url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/AffordablePlanet/get_category_goods/",self.cat_id,page,_type];
    }
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        MMLog(@"%@ ",responseObject);
        
           [self.collectionView .mj_footer endRefreshing];
        if (responseObject) {
            if ([[responseObject valueForKey:@"goods_list"] count]>0) {
                [_recommend_goods addObjectsFromArray:[responseObject valueForKey:@"goods_list"]];
                
                
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
-(NSString *)titleStr{
    
    return self.title?:@"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - <UICollectionViewDataSource>
- (void)catergoryView:(XWCatergoryView *)catergoryView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![_type isEqualToString:_meunArray[indexPath.item]]) {
        _page = 1;
        [_recommend_goods removeAllObjects];
        [self setData:_meunArray[indexPath.item]];
 
    }
       MMLog(@"%ld",(long)indexPath.item);
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
        cell.shop_price.text = [NSString stringWithFormat:@"¥ %@",dic[@"goods_price"]];
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
