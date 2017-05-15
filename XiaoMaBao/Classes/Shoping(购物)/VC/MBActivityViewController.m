//
//  MBActivityViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBActivityViewController.h"

#import "MBCategoryViewTwoCell.h"
#import "MBGoodsDetailsViewController.h"
#import "timeView.h"
#import "MBGoodSSearchViewController.h"
@interface MBActivityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>{

    NSInteger _page;
    NSArray *_meunArray;
    NSString *_banner;
    NSString *_end_time;
    NSTimer *_myTimer;
    NSInteger _lettTimes;
    timeView *_timeView;
    UIButton *_lastBtn;
    BOOL _isOnePriceBtn;
    NSString *_priceStored;
    NSString *_type;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (copy, nonatomic) NSMutableArray *recommend_goods;
@end

@implementation MBActivityViewController
- (NSMutableArray *)recommend_goods{
    if (!_recommend_goods) {
        _recommend_goods = [NSMutableArray array];
    }
    return _recommend_goods;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_myTimer invalidate];
    _myTimer = nil;
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (_myTimer == nil) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
    }
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchUI];
    _lastBtn = _defaultBtn;
    _priceStored = @"";
    [self addBottomLineView:_topView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewTwoCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
    _page = 1;
    _meunArray = @[@"default",@"salesnum",@"new"];
    _type = _meunArray.firstObject;
    [self setData];
   
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
            _type =_meunArray[sender.tag];
            [self setData];
            
        }
    }
    
    
}
- (void)searchUI{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(64 , 26.5, UISCREEN_WIDTH - 64*2, 30)];
    searchBar.placeholder = @"请输入要搜索商品名称";
    searchBar.backgroundImage = [UIImage imageNamed:@"PYSearch.bundle/clearImage"];
    searchBar.delegate = self;
    [self.navBar addSubview:searchBar];
}
#pragma mark -- 上拉加载
- (void)refreshLoading{
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    footer.refreshingTitleHidden = YES;
    self.collectionView.mj_footer = footer;
}

#pragma mark -- 请求数据
- (void)setData{

    [self show];
    NSString *url;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];

     url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/topic/info/",self.act_id,page,_type];
    [MBNetworking newGET:url parameters:@{@"sort":_priceStored} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
//        MMLog(@"%@ ",responseObject);
        if (_page == 1) {
             [self refreshLoading];
        }else{
        [self.collectionView .mj_footer endRefreshing];
        }
        if (responseObject) {
            if ([[responseObject valueForKey:@"goods_list"] count]>0) {
                [self.recommend_goods addObjectsFromArray:[responseObject valueForKey:@"goods_list"]];
                _banner   = [responseObject valueForKey:@"banner"];
                _end_time = [responseObject valueForKey:@"end_time"];
                _lettTimes = [_end_time integerValue];
                _page ++;
                [self.collectionView reloadData];
                
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
-(void)timeFireMethod:(NSTimer *)timer{
    _lettTimes--;
    if (_lettTimes>0) {
        NSInteger leftdays = _lettTimes/(24*60*60);
        NSInteger hour = (_lettTimes-leftdays*24*3600)/3600;
        NSInteger minute = (_lettTimes - hour*3600-leftdays*24*3600)/60;
        NSInteger second = (_lettTimes - hour *3600 - 60*minute-leftdays*24*3600);
        _timeView.day.text = leftdays>10?[NSString stringWithFormat:@"%ld",(long)leftdays]:[NSString stringWithFormat:@"0%ld",(long)leftdays];
        _timeView.hours.text = hour>10?[NSString stringWithFormat:@"%ld",(long)hour]:[NSString stringWithFormat:@"0%ld",(long)hour];
        _timeView.points.text =  minute>10?[NSString stringWithFormat:@"%ld",(long)minute]:[NSString stringWithFormat:@"0%ld",(long)minute];
        _timeView.second.text = second>10?[NSString stringWithFormat:@"%ld",(long)second]:[NSString stringWithFormat:@"0%ld",(long)second];
    }
    
    if(_lettTimes==0){
        [_myTimer invalidate];
        _myTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    
    return self.recommend_goods.count;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1" forIndexPath:indexPath];
            reusableview.backgroundColor = [UIColor whiteColor];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(0, 3, UISCREEN_WIDTH, UISCREEN_WIDTH*35/75);
            [reusableview addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_banner] placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
            NSInteger leftdays = _lettTimes/(24*60*60);
            NSInteger hour = (_lettTimes-leftdays*24*3600)/3600;
            NSInteger minute = (_lettTimes - hour*3600-leftdays*24*3600)/60;
            NSInteger second = (_lettTimes - hour *3600 - 60*minute-leftdays*24*3600);
            
            if (!_timeView) {
                timeView *View = [timeView instanceView];
                View.day.text = leftdays>10?[NSString stringWithFormat:@"%ld",(long)leftdays]:[NSString stringWithFormat:@"0%ld",(long)leftdays];
                View.hours.text = hour>10?[NSString stringWithFormat:@"%ld",(long)hour]:[NSString stringWithFormat:@"0%ld",(long)hour];
                View.points.text =  minute>10?[NSString stringWithFormat:@"%ld",(long)minute]:[NSString stringWithFormat:@"0%ld",(long)minute];
                View.second.text = second>10?[NSString stringWithFormat:@"%ld",(long)second]:[NSString stringWithFormat:@"0%ld",(long)second];
                
                
                [reusableview   addSubview:_timeView = View];
                [View mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.left.mas_equalTo(0);
                    make.top.equalTo(imageView.mas_bottom).offset(0);
                    make.right.mas_equalTo(-5);
             
                    
                }];
            }
           
         return reusableview;
        }
    
       
    }
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBCategoryViewTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBCategoryViewTwoCell" forIndexPath:indexPath];
    NSDictionary *dic = _recommend_goods[indexPath.item];
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

        return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*35/75+33);
   

}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    MBGoodSSearchViewController *searchViewController = [[MBGoodSSearchViewController alloc] init:PYSearchResultShowModeGoods];
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
