//
//  MBActivityViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBActivityViewController.h"
#import "XWCatergoryView.h"
#import "MBCategoryViewTwoCell.h"
#import "MBShopingViewController.h"
#import "timeView.h"
#import "MBGoodSSearchViewController.h"
@interface MBActivityViewController ()<XWCatergoryViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>{

    NSInteger _page;
    NSString *_type;
    NSArray *_meunArray;
    NSMutableArray *_recommend_goods;
    NSString *_banner;
    NSString *_end_time;
    
    NSTimer *_myTimer;
    NSInteger _lettTimes;
    timeView *_timeView;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MBActivityViewController
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self searchUI];
    [self setTopView];

    [_collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewTwoCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
    _page = 1;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _meunArray = @[@"default",@"salesnum",@"new",@"stock"];
    _recommend_goods = [NSMutableArray array];
    [self setData:_meunArray.firstObject];
    [self refreshLoading];
}
- (void)searchUI{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(64 , 26.5, UISCREEN_WIDTH - 64*2, 30)];
    searchBar.placeholder = @"请输入要搜索商品名称";
    searchBar.backgroundImage = [UIImage imageNamed:@"PYSearch.bundle/clearImage"];
    searchBar.delegate = self;
    [self.navBar addSubview:searchBar];
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
    [catergoryView xw_realoadData];
}
#pragma mark -- 上拉加载
- (void)refreshLoading{
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setRefre)];
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    footer.refreshingTitleHidden = YES;
    self.collectionView.mj_footer = footer;
}
#pragma mark --上拉用
- (void)setRefre{
    [self show];
    NSString *url;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];

     url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/topic/info/",self.act_id,page,_type];
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
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];

     url =[NSString stringWithFormat:@"%@%@%@/%@/%@",BASE_URL_root,@"/topic/info/",self.act_id,page,type];
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
//        MMLog(@"%@ ",responseObject);
        
        [self.collectionView .mj_footer endRefreshing];
        if (responseObject) {
            if ([[responseObject valueForKey:@"goods_list"] count]>0) {
                [_recommend_goods addObjectsFromArray:[responseObject valueForKey:@"goods_list"]];
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
#pragma mark - <UICollectionViewDataSource>
- (void)catergoryView:(XWCatergoryView *)catergoryView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![_type isEqualToString:_meunArray[indexPath.item]]) {
        _page = 1;
        [_recommend_goods removeAllObjects];
        
       
        [self setData:_meunArray[indexPath.item]];
        
    }
 
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

        return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*35/75+33);
   

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
