//
//  @Author : <#Author#>
//  @Desc   : <#Desc#>
//
//  XiaoMaBao xxxxx
//
//  Created by 张磊 on 15/5/12.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBHomeViewController.h"
#import "MBHomeMenuScrollView.h"
#import "MBLoginShareButton.h"
#import "MBHomeMenuButton.h"
#import "MBHomeCategoryCell.h"
#import "MBMallItemCategoryTableViewCell.h"
#import "MBShopingViewController.h"
#import "MBHomeAdCollectionViewCell.h"
#import "MBSmallCategoryViewController.h"
#import "MBSearchViewController.h"

#import "UIImageView+WebCache.h"
#import "NSString+BQ.h"

#import <KVNProgress.h>
#import "UIButton+WebCache.h"
#import "MBNetworking.h"
#import "MJExtension.h"
#import "MBAdvert.h"
#import "MBSignaltonTool.h"
#import "MBMyCollectionViewController.h"

#import "MBGroupShopController.h"
@interface MBHomeViewController () <MBHomeMenuScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak,nonatomic) UICollectionView *collectionView;
@property (weak,nonatomic) MBHomeMenuScrollView *menuScrollView;
@property (weak,nonatomic) UICollectionView *adCollectionView;
@property (weak,nonatomic) UIPageControl *adPageControl;
@property (weak,nonatomic) UIView *activeView;
@property (weak,nonatomic) UIButton *baokuanBtn;
@property (weak,nonatomic) UIView *popView;
@property (weak,nonatomic) UIView *timeLimitView;
@property (weak,nonatomic) UIView *popItemView;

// 特卖/即将推出 Tab
@property (weak,nonatomic) UIView *tabView;

// Category
@property (weak,nonatomic) UIButton *brandButton;
@property (weak,nonatomic) UIButton *categoryListButton;
@property (weak,nonatomic) UIView *categoryLineView;
@property (weak,nonatomic) UITableView *categoryTableView;
@property (weak,nonatomic) UIView *sectionTitlesView;
@property (weak,nonatomic) UIButton *topButton;
// Main
//@property (strong,nonatomic) UIScrollView *mainBoxView;
@property (weak,nonatomic) UIView *categoryMaskView;

// 当前滚动的页数
@property (assign,nonatomic) NSUInteger currentScrollIndex;

// 定时器
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) NSArray *adverts;
@property (strong,nonatomic) NSArray *HeaderadArray;
@property (strong,nonatomic) NSArray *centerAdverts;

@property (strong,nonatomic) NSDictionary *categoryDicts;
@property (strong,nonatomic) NSDictionary *categoryListDicts;
@property (strong,nonatomic) NSDictionary *brandsDicts;

@property (strong,nonatomic) NSArray *categoryKeys;
@property (strong,nonatomic) NSArray *categoryListKeys;
@property (strong,nonatomic) NSArray *brandsKeys;

@property (strong,nonatomic) NSArray *categoryIds;
@property (strong,nonatomic) NSMutableArray *MenuItemArray;
@property (strong,nonatomic) NSMutableArray *MenuItemId;

@property (weak,nonatomic) UITableView *tableView;

@property (strong,nonatomic) UIView *headerView;
@property (assign,nonatomic) BOOL isFirstLoadCollectionView;
@property (assign,nonatomic) int isTeMai;
@property (strong,nonatomic) NSMutableArray *TeMaiArarry;
@property (strong,nonatomic) NSMutableArray *NewPushArray;
@property (strong,nonatomic) NSMutableArray *FavourableArarry;

@property (nonatomic, copy) NSString *typeTable;
@property(nonatomic,strong) UITextField *searchField;
@property(nonatomic,assign) NSInteger flag;
@end

@implementation MBHomeViewController

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.view.ml_width, self.view.ml_height - TOP_Y);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height) collectionViewLayout:flowLayout];
        collectionView.contentInset = UIEdgeInsetsMake( -TOP_Y * 2, 0, 0, 0);
        collectionView.tag = 10000;
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self,collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
        [self.view addSubview:_collectionView = collectionView];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBHome"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBHome"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.backgroundColor = NavBar_Color;
    self.view.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    UIColor *titleHighlightedColor = [UIColor greenColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                      nil] forState:UIControlStateSelected];
    [self getShufflingFigureData];
    
    [self setSearchUI];
}

- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.view.ml_width, 200);
    return headerView;
}
- (void)setMenuType:(NSString *)menuType{
    _menuType = menuType;
    
    [self getMenuItem:menuType];
}

- (void)setSearchUI{
    UITextField *searchField = [[UITextField alloc] init];
    searchField.layer.cornerRadius = 5;
    searchField.delegate = self;
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:15];
    searchField.textColor = [UIColor grayColor];
    searchField.placeholder = @"点击搜索...";
    searchField.returnKeyType = UIReturnKeySearch;
 
    [self.view addSubview:searchField];
    
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.left.equalTo(self.navBar.leftButton.mas_right).offset(10);
        make.right.equalTo(self.navBar.rightButton.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    UIView *searchLeftView = [[UIView alloc] init];
    searchLeftView.frame = CGRectMake(0, 0, 35, searchField.frame.size.height);
    
    UIImageView *searchImageView = [[UIImageView alloc] init];
    searchImageView.image = [UIImage imageNamed:@"search_icon"];
    
    
    
    searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    searchImageView.frame = CGRectMake(10, (searchField.frame.size.height - 20) * 0.5, 20, 20);
    [searchLeftView addSubview:searchImageView];
    
    searchField.leftView = searchLeftView;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField = searchField;
        
    
}

#pragma mark --获取导航菜单栏相关数据
-(void)getMenuItem:(NSString *)menu_type
{
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getFavourableMenu"] parameters:@{@"menu_type":menu_type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        // NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
        
        
        _MenuItemArray = [NSMutableArray array];
        _MenuItemId = [NSMutableArray array];
        
        if ([menu_type isEqualToString:@"1"]) {
            
            [_MenuItemArray addObject:@"首页"];
        }
        
        for (NSDictionary *dict in [responseObject valueForKeyPath:@"data"]) {
            [_MenuItemArray addObject:[dict valueForKeyPath:@"menu_name"]];
            [_MenuItemId addObject:[dict valueForKeyPath:@"menu_id"]];
            
        }
        
        
        if (_MenuItemArray.count>0) {
            // 设置顶部导航的Item
            [self setupMenuItem];
            [_collectionView reloadData];
        }
        [self getTeMaiAndTuiChu:@"1"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
       
        // 设置顶部导航的Item
        [self setupMenuItem];
      
    }];
    
}
#pragma mark --获取特卖和即将推出数据
-(void)getTeMaiAndTuiChu:(NSString *)type
{
    if ([type isEqualToString:@"2"]) {
        [self show];
    }
    NSDictionary *pagination = @{@"page":@"1", @"count":@"100"};
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/shouYe"] parameters:@{@"type":type,@"pagination":pagination} success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [self dismiss];
        
        if ([type isEqualToString:@"1"]) {
            _TeMaiArarry = [responseObject valueForKeyPath:@"data"];
            
        }else if ([type isEqualToString:@"2"])
        {
            _NewPushArray = [responseObject valueForKeyPath:@"data"];
            
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
      
        [self show:@"请求失败！" time:1];
    }];
    
}
#pragma mark --获取首页广告图数据
- (void)getShufflingFigureData{
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"index/advert"] parameters:nil success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
     
        self.HeaderadArray = [responseObject valueForKeyPath:@"data"];
//        NSLog(@"%@",[responseObject valueForKeyPath:@"data"]);
        
        
        self.adverts = [MBAdvert objectArrayWithKeyValuesArray:[responseObject valueForKeyPath:@"data"]];
        [self collectionView];
        [self getMenuItem:@"1"];
        [self.adCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败" time:1];
        
    }];
}
#pragma mark -- 获取各个分类数据
-(void)getFavourableList:(NSInteger)index width:(MBHomeMenuScrollView *)scrollView
{
   
   

    if(index < 1){
        _flag = index;
        
        return;
    }
    
    
    if (index == _flag) {
        
        return;
    }
    
    //NSLog(@"%ld %ld",(long)index,(long)_flag);
    
    
    [self show];
    
    NSString * menuId = _MenuItemId[index-1];
    NSDictionary *pagination = @{@"page":@"1", @"count":@"100"};
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getFavourableList"] parameters:@{@"menu_id":menuId,@"pagination":pagination} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
     
        [self dismiss];
        _FavourableArarry = [responseObject valueForKeyPath:@"data"];
        
        [self.collectionView setContentOffset:CGPointMake((index  * scrollView.ml_width), self.collectionView.contentOffset.y) animated:YES];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self show:@"请求失败！" time:1];
        NSLog(@"%@",error);
       
    }];
    _flag = index;
    
}


- (NSString *)rightImage{
    return @"icon_menu";
}
- (NSString *)leftImage{
    return @"logo";
}
#pragma mark ---  设置领积分下四个button
- (void)setupTimeLimit{
    [_timeLimitView removeFromSuperview];
    
    UIView *timeLimitView = [[UIView alloc] init];
    timeLimitView.frame = CGRectMake(0, CGRectGetMaxY(self.activeView.frame) + MARGIN_5, self.view.ml_width, self.view.ml_width/2*297/468);
    
    UIButton *adBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    adBtn1.frame = CGRectMake(0, 0, self.view.ml_width * 0.5, timeLimitView.ml_height);
    adBtn1.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [timeLimitView addSubview:adBtn1];
    adBtn1.tag = 101;
    [adBtn1 addTarget:self action:@selector(adbtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *adBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    adBtn2.frame = CGRectMake(adBtn1.ml_width, 0, self.view.ml_width * 0.5, timeLimitView.ml_height * 0.5);
    adBtn2.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [timeLimitView addSubview:adBtn2];
    adBtn2.tag = 102;
    [adBtn2 addTarget:self action:@selector(adbtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *adBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    adBtn3.frame = CGRectMake(adBtn1.ml_width, adBtn2.ml_height, (self.view.ml_width * 0.5) / 2, timeLimitView.ml_height * 0.5);
    adBtn3.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [timeLimitView addSubview:adBtn3];
    adBtn3.tag = 103;
    [adBtn3 addTarget:self action:@selector(adbtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *adBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    adBtn4.frame = CGRectMake(CGRectGetMaxX(adBtn3.frame), adBtn2.ml_height, adBtn3.ml_width, timeLimitView.ml_height * 0.5);
    adBtn4.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [timeLimitView addSubview:adBtn4];
    [adBtn4 addTarget:self action:@selector(adbtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    adBtn4.tag = 104;
    
    
    [self.headerView addSubview:_timeLimitView = timeLimitView];
    
}
-(void)adbtn1Click:(UIButton *)btn
{
    if([self.centerAdverts count] <= 0){
        return;
    }
    if (btn.tag == 101) {

        NSArray *baokuanArray = [self.centerAdverts objectAtIndex:0];
        NSString *dict = [baokuanArray valueForKeyPath:@"ad_link"];
       
        MBSmallCategoryViewController *categoryVc = [[MBSmallCategoryViewController alloc] init];
        categoryVc.act_id = [self componentsSeparatedByString:dict];
        categoryVc.type = @"2";
        categoryVc.act_img = [[self.centerAdverts objectAtIndex:0] valueForKeyPath:@"ad_code"];
        [self.navigationController pushViewController:categoryVc animated:YES];
    }else if (btn.tag == 102)
    {
   
        NSArray *baokuanArray = [self.centerAdverts objectAtIndex:1];
        NSString *dict = [baokuanArray valueForKeyPath:@"ad_link"];
        MBSmallCategoryViewController *categoryVc = [[MBSmallCategoryViewController alloc] init];
        categoryVc.act_id = [self componentsSeparatedByString:dict];
        categoryVc.type = @"2";
        categoryVc.act_img = [[self.centerAdverts objectAtIndex:1] valueForKeyPath:@"ad_code"];
        [self.navigationController pushViewController:categoryVc animated:YES];
        
    }else if (btn.tag == 103)
    {
 
        NSArray *baokuanArray = [self.centerAdverts objectAtIndex:2];
        NSString *dict = [baokuanArray valueForKeyPath:@"ad_link"];
        MBSmallCategoryViewController *categoryVc = [[MBSmallCategoryViewController alloc] init];
        categoryVc.act_id = [self componentsSeparatedByString:dict];
        categoryVc.type = @"2";
        categoryVc.act_img = [[self.centerAdverts objectAtIndex:2] valueForKeyPath:@"ad_code"];
        [self.navigationController pushViewController:categoryVc animated:YES];
        
    }else if (btn.tag == 104)
    {

        NSArray *baokuanArray = [self.centerAdverts objectAtIndex:3];
        NSString *dict = [baokuanArray valueForKeyPath:@"ad_link"];
        MBSmallCategoryViewController *categoryVc = [[MBSmallCategoryViewController alloc] init];
        categoryVc.act_id =[self componentsSeparatedByString:dict];
        categoryVc.type = @"2";
        categoryVc.act_img = [[self.centerAdverts objectAtIndex:3] valueForKeyPath:@"ad_code"];
        
        
        [self.navigationController pushViewController:categoryVc animated:YES];
        
    }
}
#pragma mark -- 惊爆价(设置图片比例)
- (void)setupBaokuan{
    
    [_baokuanBtn removeFromSuperview];
    UIView *bkView = [[UIView alloc] init];
    bkView.frame = CGRectMake(0, CGRectGetMaxY(self.timeLimitView.frame) + MARGIN_5, self.view.ml_width, self.view.ml_width*333/750);
    UIButton *baokuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    baokuanBtn.frame = CGRectMake(0, 0,self.view.ml_width, bkView.ml_height);
    [baokuanBtn addTarget:self action:@selector(baokuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bkView addSubview:_baokuanBtn = baokuanBtn];
    
    [self.headerView addSubview:bkView];
}

#pragma mark -  爆款
-(void)baokuanBtnClick
{
    if([self.centerAdverts count] <= 0){
        return;
    }
    
    NSArray *baokuanArray = [self.centerAdverts objectAtIndex:self.centerAdverts.count -1];
    NSString *dict = [baokuanArray valueForKeyPath:@"ad_link"];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSInteger i = 0;
//    NSArray *array = [dict componentsSeparatedByString:@","];
//    for (NSString *str in array) {
//        NSArray *strs = [str componentsSeparatedByString:@":"];
//        for (NSString *s in strs) {
//            NSString *key = [strs firstObject];
//            if ([key isEqualToString:[strs firstObject]] && i == 0) {
//                key = [key substringFromIndex:1];
//            }
//            NSString *val = [strs lastObject];
//            if ([val isEqualToString:[strs lastObject]] && i == strs.count - 1) {
//                val = [val substringWithRange:NSMakeRange(0, val.length - 1)];
//            }
//            i++;
//            params[key] = val;
//            break;
//        }
//    }
    
    
    MBShopingViewController *shopVc = [[MBShopingViewController alloc] init];
    shopVc.GoodsId = [self componentsSeparatedByString:dict];
    [self.navigationController pushViewController:shopVc animated:YES];
    
    
}
- (void)setupMenuItem{
    MBHomeMenuScrollView *scrollView = [[MBHomeMenuScrollView alloc] init];
    scrollView.homeDelegate = self;
    scrollView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, 28);
    [self.view addSubview:scrollView];
    self.menuScrollView = scrollView;
    
    
    NSArray *titles = [NSArray array];
    
    if (_MenuItemArray.count>0) {
        titles = _MenuItemArray;
    }
    for (NSInteger i = 0; i < titles.count;i++) {
        [scrollView setTitle:titles[i]];
    }
    
    
    //Pop
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.ml_width - 30, CGRectGetMinY(scrollView.frame), 30, 28);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(showPopItemView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *btnLeftLineView = [[UIView alloc] init];
    btnLeftLineView.frame = CGRectMake(0, 0, PX_ONE, btn.ml_height);
    btnLeftLineView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    [btn addSubview:btnLeftLineView];
}

#pragma mark 设置即将推出和最新特卖布局
- (UIView *)setupTabTuiChu{
    UIView *tabView = [[UIView alloc] init];
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.frame = CGRectMake(0, CGRectGetMaxY(self.baokuanBtn.frame) + MARGIN_5, self.view.ml_width, 36);
    tabView.tag = 102;
    if(_isTeMai == 3){
        return tabView;
    }
    
    MBHomeMenuButton *btn1 = [MBHomeMenuButton buttonWithType:UIButtonTypeCustom];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn1 setTitle:@"最新特卖" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, self.view.ml_width * 0.5, tabView.ml_height);
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(clickTuiChuTab:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tabLineView = [[UIView alloc] init];
    tabLineView.frame = CGRectMake(btn1.ml_width, 0, PX_ONE, btn1.ml_height);
    tabLineView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    [tabView addSubview:tabLineView];
    
    MBHomeMenuButton *btn2 = [MBHomeMenuButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    [btn2 setTitle:@"即将推出" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(btn1.ml_width, 0, btn1.ml_width,tabView.ml_height);
    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn2 addTarget:self action:@selector(clickTuiChuTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [tabView addSubview:btn1];
    [tabView addSubview:btn2];
    
    if (_isTeMai == 0) {
        btn1.currentSelectedStatus = YES;
        [self clickTuiChuTab:btn1];
    }else if(_isTeMai == 1){
        btn1.currentSelectedStatus = YES;
    }else{
        btn2.currentSelectedStatus = YES;
    }
    
    return tabView;
}



- (CGFloat)leftButtonW{
    return 80;
}

- (void)titleClick{
   
}
#pragma mark - 即将推出和最新特卖点击事件
- (void)clickTuiChuTab:(MBHomeMenuButton *)btn{
    
    btn.currentSelectedStatus = YES;
    
    if (btn.tag == 1) {
        _typeTable = @"tie";
        // 特卖
        MBHomeMenuButton *btn2 = (MBHomeMenuButton *)[btn.superview viewWithTag:2];
        [UIView animateWithDuration:.25 animations:^{
            btn2.currentSelectedStatus = NO;
        }];
        _isTeMai = 1;
        [self getTeMaiAndTuiChu:@"1"];
    }else if (btn.tag == 2){
        _typeTable = @"new";
        // 即将推出
        MBHomeMenuButton *btn1 = (MBHomeMenuButton *)[btn.superview viewWithTag:1];
        [UIView animateWithDuration:.25 animations:^{
            btn1.currentSelectedStatus = NO;
        }];
        _isTeMai = 2;
        [self getTeMaiAndTuiChu:@"2"];
        
    }
}
#pragma mark -- 设置首页轮播图和上面的 UIPageControl
- (void)setupAd{
    
    [self.adCollectionView removeFromSuperview];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.ml_width, 333*self.view.ml_width/750);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *adCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.view.ml_width, 333*self.view.ml_width/750) collectionViewLayout:layout];
    adCollectionView.backgroundColor = [UIColor clearColor];
    adCollectionView.pagingEnabled = YES;
    adCollectionView.showsHorizontalScrollIndicator = NO;
    adCollectionView.showsVerticalScrollIndicator = NO;
    [adCollectionView registerNib:[UINib nibWithNibName:@"MBHomeAdCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBHomeAdCollectionViewCell"];
    
    adCollectionView.dataSource = self;
    adCollectionView.delegate = self;
    [self.headerView addSubview:adCollectionView];
    self.adCollectionView = adCollectionView;
    
    UIPageControl *adPageControl = [[UIPageControl alloc] init];
    adPageControl.frame = CGRectMake(0, CGRectGetMaxY(adCollectionView.frame) - 20, self.view.ml_width, 4);
    
    adPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    adPageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"e8465e"];
    [self.headerView addSubview:_adPageControl = adPageControl];
    adPageControl.numberOfPages = self.adverts.count;
    
    
}
#pragma mark --首页轮播广告图的自动滚动定时器
- (void)addTimer{
    
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeAd) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)changeAd{
    
    self.currentScrollIndex++;
    if (self.adverts.count == 0 || self.currentScrollIndex > self.adverts.count - 1){
        
        
        self.currentScrollIndex = 0;
        
    }
    
    
    if (self.adverts.count) {
        
        [self.adCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentScrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}
#pragma mark -- 设置首页轮播图下的button
- (void)setupActivesItems{
    
    [self.activeView removeFromSuperview];
    
    UIView *activeView = [[UIView alloc] init];
    activeView.frame = CGRectMake(0, CGRectGetMaxY(self.adCollectionView.frame), self.view.ml_width, 60);
    activeView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:activeView];
    self.activeView = activeView;
    
    NSArray *titleItems = @[@"领积分", @"摇麻豆", @"我的收藏",@"团购"];
    NSArray *imgItems = @[@"icon_promotion01", @"icon_promotion02", @"icon_promotion03",@"bulk"];
    NSInteger count = titleItems.count;
    CGFloat itemW = self.view.ml_width / (count + 1);
    CGFloat itemMargin = itemW / (count + 1);
    
    
    for (NSInteger i = 0; i < count; i++) {
        MBLoginShareButton *btn = [MBLoginShareButton buttonWithType:UIButtonTypeCustom];
        btn.imageRadio = 0.7;
        btn.tag = i;
        [btn addTarget:self action:@selector(activesButtonClickPushVc:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:titleItems[i] forState:UIControlStateNormal];
        if (![imgItems[i] isEqualToString:@""]) {
            [btn setImage:[UIImage imageNamed:imgItems[i]] forState:UIControlStateNormal];
        }
        CGFloat x = i * (itemW + itemMargin) + itemMargin;
        btn.frame = CGRectMake(x, 5, itemW, 50);
        [activeView addSubview:btn];
    }
}

- (void)setupTopButton{
    [_topButton removeFromSuperview];
    UIButton *setupTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat widthOrHeight = 36;
    setupTopButton.frame = CGRectMake(self.view.ml_width - 8 - widthOrHeight, self.view.ml_height - 80 - widthOrHeight, widthOrHeight, widthOrHeight);
    [setupTopButton setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    // 回到顶部
    [setupTopButton addTarget:self action:@selector(goTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topButton = setupTopButton];
}

// 回到顶部
- (void)goTop{
    
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentInset.top) animated:YES];
    
}

- (void)activesButtonClickPushVc:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            [self performSegueWithIdentifier:@"pushMBCheckInViewController" sender:nil];
            break;
        case 1:
            // push 到摇一摇控制器
            [self performSegueWithIdentifier:@"pushMBSharkViewController" sender:nil];
            break;
        case 2:
            [self pushMyCollectionVc];
            break;
        case 3:{MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            [self pushViewController:VC Animated:YES]; } break;
            
        default:
            break;
    }
}

- (void)pushMyCollectionVc{
    
    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    if (userInfo.uid == nil) {
        //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //由storyboard根据myView的storyBoardID来获取我们要切换的视图
        UIViewController *myViewVc = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
        //由navigationController推向我们要推向的view
        [self.navigationController pushViewController:myViewVc animated:YES];
        return;
    }
    
    MBMyCollectionViewController *collectionVC = [[MBMyCollectionViewController alloc] init];
    [self.navigationController pushViewController:collectionVC animated:YES];
    
}
- (void)showPopItemView:(UIButton *)btn{
    
    [self.popView removeFromSuperview];
    
    UIView *popView = [[UIView alloc] init];
    popView.frame = self.view.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewDidSelected:)]];
    self.popView = popView;
    
    UIView *makeView = [[UIView alloc] init];
    makeView.frame = self.view.bounds;
    makeView.backgroundColor = [UIColor blackColor];
    makeView.alpha = 0.5;
    [popView addSubview:makeView];
    
    UIView *popItemView = [[UIView alloc] init];
    popItemView.backgroundColor = [UIColor whiteColor];
    NSInteger num = _MenuItemArray.count%3;
    if (num==0) {
        popItemView.frame = CGRectMake(self.view.ml_width, TOP_Y, 270, _MenuItemArray.count/3*40);
    }else{
    
       popItemView.frame = CGRectMake(self.view.ml_width, TOP_Y, 270, (_MenuItemArray.count/3+1)*40);
    }
    
    [popView addSubview:_popItemView = popItemView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(dismissPopItemView) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    backButton.frame = CGRectMake(0, 0, 30, popItemView.ml_height);
    [popItemView addSubview:backButton];
    
    NSArray *itemTitles = [NSArray array];
    
    if (_MenuItemArray.count>0) {
        itemTitles = _MenuItemArray;
    }
    NSUInteger count = itemTitles.count;
    NSUInteger column = 3;
    
    CGFloat width = (popItemView.ml_width - 30) / column;
    CGFloat height = 40;
    
    for (NSInteger i = 0; i < count; i++) {
        CGFloat row = i / column;
        CGFloat col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:itemTitles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(col * width + 30, row * height, width, height);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [popItemView addSubview:btn];
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.frame = CGRectMake(CGRectGetMaxX(btn.frame), CGRectGetMinY(btn.frame), PX_ONE, btn.ml_height);
        rightLineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [popItemView addSubview:rightLineView];
        
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.frame = CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame), btn.ml_width, PX_ONE);
        bottomLineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [popItemView addSubview:bottomLineView];
    }
    
    [UIView animateWithDuration:.25 animations:^{
        popItemView.ml_x = self.view.ml_width - 270;
    }];
}

- (void)clickBtn:(UIButton *)btn{
    
    
    [self.menuScrollView setSelectedWithIndex:btn.tag];
    [self homeMenuScrollView:self.menuScrollView didSelectedIndex:btn.tag];
    
    [self dismissPopItemView];
}

- (void)tapViewDidSelected:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:.25 animations:^{
        self.popItemView.ml_x = self.view.ml_width;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
    }];
    
}

- (void)dismissPopItemView{
    [UIView animateWithDuration:.25 animations:^{
        self.popItemView.ml_x = self.view.ml_width;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    MBSearchViewController *searchVc = [[MBSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
    return NO;
}

#pragma mark - <UITableViewDatasource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag >= 101) {
        return 1;
    }
    return self.categoryDicts.allKeys.count ?: 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag >= 101) {
        if (_isTeMai == 1) {
            return  _TeMaiArarry.count;
        }else if(_isTeMai ==2)
        {
            return _NewPushArray.count;
        }
        else if(_isTeMai == 3){
            return _FavourableArarry.count;
        }
        else
        {
            return 0;
        }
    }
    
    if (self.categoryDicts.allKeys.count) {
        // self.sectionTitlesView.hidden == YES 代表是分类浏览
        if (self.sectionTitlesView.isHidden != true) {
            return [[self.categoryDicts valueForKeyPath:self.categoryKeys[section]] count];
        }else{
            return [[[self.categoryDicts valueForKeyPath:self.categoryIds[section]] valueForKeyPath:@"cat_id"] count];
        }
    }
    
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    if (tableView.tag >= 101) {//特卖
        MBMallItemCategoryTableViewCell *cell1 = (MBMallItemCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MBMallItemCategoryTableViewCell" forIndexPath:indexPath];
        cell1.view.backgroundColor = [UIColor whiteColor];
        if (self.isTeMai == 1) {
            cell1.decribe.text = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_name"];
//            cell1.zheKou.text = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"favourable_name"];
            NSString *urlstr = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_img"];
            NSString *endStr = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"active_remainder_time"];
            NSString *timeStr = [NSDate deltaTimeFrom:nil end:endStr];
            cell1.LeavesTime.text = timeStr;
            NSURL *url = [NSURL URLWithString:urlstr];
        
            [cell1.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num1"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell1.showImageView.alpha = 0.3f;
                [UIView animateWithDuration:1
                                 animations:^{
                                     cell1.showImageView.alpha = 1.0f;
                                 }
                                 completion:nil];
                
                //NSLog(@"%f",cell1.showImageView.ml_width/cell1.showImageView.ml_height);
            }];
            
            cell1.startTimerLabel.hidden = YES;
            
        }else if(_isTeMai == 3){
            cell1.decribe.text = [[_FavourableArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_name"];
            cell1.zheKou.text = [[_FavourableArarry objectAtIndex:indexPath.row] valueForKeyPath:@"favourable_name"];
        
            NSString *urlstr = [[_FavourableArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_img"];
            NSString *endStr = [[_FavourableArarry objectAtIndex:indexPath.row] valueForKeyPath:@"active_remainder_time"];
            NSString *timeStr = [NSDate deltaTimeFrom:nil end:endStr];
            cell1.LeavesTime.text = timeStr;
            
            
            NSURL *url = [NSURL URLWithString:urlstr];
            [cell1.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num1"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell1.showImageView.alpha = 0.3f;
                [UIView animateWithDuration:1
                                 animations:^{
                                     cell1.showImageView.alpha = 1.0f;
                                 }
                                 completion:nil];
            }];

            cell1.startTimerLabel.hidden = YES;
        }
        else if(_isTeMai==2)
        {
            cell1.decribe.text = [[_NewPushArray objectAtIndex:indexPath.row] valueForKeyPath:@"act_name"];
            cell1.zheKou.text = [[_NewPushArray objectAtIndex:indexPath.row] valueForKeyPath:@"favourable_name"];
            NSString *urlstr = [[_NewPushArray objectAtIndex:indexPath.row] valueForKeyPath:@"act_img"];
            NSString *starStr = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"start_time"];
            
            NSTimeInterval detaildate = [starStr doubleValue];
            NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:detaildate];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"MM月dd日 HH:mm"];
            NSString *destDate= [dateFormatter stringFromDate:detailDate];
            cell1.startTimerLabel.hidden = NO;
            cell1.startTimerLabel.backgroundColor = [UIColor blackColor];
            cell1.startTimerLabel.textColor = [UIColor whiteColor];
            cell1.startTimerLabel.highlighted = YES;
            cell1.startTimerLabel.opaque = NO;
            cell1.startTimerLabel.text = [NSString stringWithFormat:@"%@开售", destDate];
            NSURL *url = [NSURL URLWithString:urlstr];
            [cell1.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num1"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell1.showImageView.alpha = 0.3f;
                [UIView animateWithDuration:1
                                 animations:^{
                                     cell1.showImageView.alpha = 1.0f;
                                 }
                                 completion:nil];
            }];

      
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell1;
    }else{
        MBHomeCategoryCell *cell2 = (MBHomeCategoryCell *)[tableView dequeueReusableCellWithIdentifier:@"MBHomeCategoryCell" forIndexPath:indexPath];
        
        // self.sectionTitlesView.hidden == YES 代表是分类浏览
        if (self.sectionTitlesView.isHidden == YES) {
            cell2.titleLbl.text =  [[[[self.categoryDicts valueForKeyPath:self.categoryIds[indexPath.section]] valueForKeyPath:@"cat_id"] allValues][indexPath.row] valueForKeyPath:@"name"];
        }else{
            cell2.titleLbl.text =  [[self.categoryDicts valueForKeyPath:self.categoryKeys[indexPath.section]] allValues][indexPath.row];
        }
        cell = cell2;
       cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag >= 101) {
        
        if ([_typeTable isEqualToString:@"tie"]) {
            return (self.view.ml_width*330/750+28);
        }else{
            return (self.view.ml_width*333/750+28);
        }
    }else{
        return 33;
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag >= 101) {
        return [self setupTabTuiChu];
    }
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"262626"];
    sectionView.frame = CGRectMake(0, 20, tableView.ml_width, 44);
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.text = self.categoryKeys[section];
    sectionLabel.font = [UIFont boldSystemFontOfSize:16];
    
    CGSize size = [self.categoryKeys[section] sizeWithFont:sectionLabel.font withMaxSize:sectionView.frame.size];
    if (size.width < 46) {
        size.width = 46;
    }
    
    sectionLabel.frame = CGRectMake(0, 0, size.width, 44);
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.textColor = [UIColor whiteColor];
    sectionLabel.backgroundColor = [UIColor colorWithHexString:@"24aa98"];
    [sectionView addSubview:sectionLabel];
    return sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isFirstLoadCollectionView) {
        return 0;
    }
    if ([tableView isEqual:self.tableView]) {
      
        
        return 44;
    }
    if (tableView.tag >= 101) {
      
        
        return 36;
    }
    
    
    
    return 44;
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString:@"pushMBCheckInViewController"] || [identifier isEqualToString:@"pushMBSharkViewController"]) {
        MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
        if (userInfo.uid == nil) {
            //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            //由storyboard根据myView的storyBoardID来获取我们要切换的视图
            UIViewController *myViewVc = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
            //由navigationController推向我们要推向的view
            [self.navigationController pushViewController:myViewVc animated:YES];
            return;
        }
    }
    [super performSegueWithIdentifier:identifier sender:sender];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (tableView.tag >= 101) {//特卖和即将推出
        MBSmallCategoryViewController *categoryVc = [[MBSmallCategoryViewController alloc] init];
        
        categoryVc.type = @"3";
        if(_isTeMai == 3){
            categoryVc.act_id = [[_FavourableArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_id"];
            categoryVc.favourable_name = [[_FavourableArarry objectAtIndex:indexPath.row] valueForKeyPath:@"favourable_name"];
            categoryVc.title = [[_FavourableArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_name"];
            categoryVc.act_img = [[_FavourableArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_img"];
        }else{
            categoryVc.act_id = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_id"];
            categoryVc.favourable_name = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"favourable_name"];
            categoryVc.title = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_name"];
            categoryVc.act_img = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_img"];
        }
        
        
        [self.navigationController pushViewController:categoryVc animated:YES];
        
    }else{
        NSDictionary *dict = nil;
        // self.sectionTitlesView.hidden == YES 代表是分类浏览
        if (self.sectionTitlesView.isHidden == YES) {//分类浏览
            dict = [[[self.categoryDicts valueForKeyPath:self.categoryIds[indexPath.section]] valueForKeyPath:@"cat_id"] allValues][indexPath.row];
            
        }else{
            dict = [[self.categoryDicts valueForKeyPath:self.categoryKeys[indexPath.section]] allValues][indexPath.row];
            
        }
        
        // NSLog(@"%@",dict);
        
        MBSmallCategoryViewController *categoryVc = [[MBSmallCategoryViewController alloc] init];
        if (self.sectionTitlesView.isHidden == YES) {
            categoryVc.ID = [dict valueForKey:@"id"];
            categoryVc.urlName = @"listGoodsByCId";
            categoryVc.type = @"0";
            categoryVc.title  =  [dict valueForKey:@"name"];
            
        }else{
            categoryVc.categoryDict = dict;
            categoryVc.ID = [[self.categoryDicts valueForKeyPath:self.categoryKeys[indexPath.section]] allKeys][indexPath.row];
            categoryVc.urlName = @"listGoodsByBId";
            categoryVc.type = @"1";
            
            if (self.sectionTitlesView.isHidden == YES) {//分类浏览
                categoryVc.title  =  [[[[self.categoryDicts valueForKeyPath:self.categoryIds[indexPath.section]] valueForKeyPath:@"cat_id"] allValues][indexPath.row] valueForKeyPath:@"name"];
            }else{
                categoryVc.title  =  [[self.categoryDicts valueForKeyPath:self.categoryKeys[indexPath.section]] allValues][indexPath.row];
            }
        }
        [self.categoryTableView removeFromSuperview];
        [self.sectionTitlesView removeFromSuperview];
        [self.categoryMaskView removeFromSuperview];
        [self.navigationController pushViewController:categoryVc animated:YES];
    }
    
}
- (void)rightTitleClick{
    // 展示品牌分类列表
    [self showBrandCategoryList];
}

#pragma mark 展示品牌分类列表
- (void)showBrandCategoryList {
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:_categoryMaskView = maskView];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromMaskView:)]];
    [maskView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromMaskView:)]];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.view.ml_width - 30, 90);
    
    UIButton *brandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    brandButton.tag = 0;
    brandButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [brandButton setTitle:@"在线品牌" forState:UIControlStateNormal];
    brandButton.frame = CGRectMake(0, 42, headerView.ml_width * 0.5, 28);
    [headerView addSubview:_brandButton = brandButton];
    [brandButton addTarget:self action:@selector(clickCategoryItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *categoryListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryListButton.tag = 1;
    [categoryListButton setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    categoryListButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [categoryListButton setTitle:@"分类浏览" forState:UIControlStateNormal];
    categoryListButton.frame = CGRectMake(brandButton.ml_width, brandButton.ml_y, headerView.ml_width * 0.5, 28);
    [categoryListButton addTarget:self action:@selector(clickCategoryItem:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_categoryListButton = categoryListButton];
    
    UIView *categoryLineView = [[UIView alloc] init];
    categoryLineView.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
    categoryLineView.frame = CGRectMake(0, CGRectGetMaxY(categoryListButton.frame), categoryListButton.ml_width, 1);
    
    [headerView addSubview:_categoryLineView = categoryLineView];
    
    UITableView *categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.ml_width, 0, self.view.ml_width - 30, self.view.ml_height) style:UITableViewStylePlain];
    categoryTableView.backgroundColor = [UIColor colorWithHexString:@"323232"];
    categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [categoryTableView registerNib:[UINib nibWithNibName:@"MBHomeCategoryCell" bundle:nil] forCellReuseIdentifier:@"MBHomeCategoryCell"];
    categoryTableView.sectionHeaderHeight = 44;
    categoryTableView.sectionFooterHeight = 0;
    categoryTableView.dataSource = self,categoryTableView.delegate = self;
    categoryTableView.tableHeaderView = headerView;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_categoryTableView = categoryTableView];
    
    // 请求在线品牌列表
    [self requestOnlineBrandList];
    
}

- (void)requestOnlineCategoryList{
   
    
    // 索引
    if (!self.categoryListDicts) {
        [KVNProgress showWithStatus:@"正在请求..."];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/category"] parameters:nil success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
            
            [KVNProgress dismiss];
            
          //  NSLog(@"%@",responseObject.data);
            
            
        
            NSMutableArray *keys = [NSMutableArray array];
            NSMutableArray *ids = [NSMutableArray array];
            
            self.categoryListDicts = responseObject.data;
            self.categoryDicts = self.categoryListDicts;
            
            for (NSDictionary *dict in [responseObject.data allValues]) {
                [keys addObject:[dict valueForKeyPath:@"name"]];
                [ids addObject:[dict valueForKeyPath:@"id"]];
            }
            
            self.categoryListKeys = keys;
            self.categoryKeys = self.categoryListKeys;
            self.categoryIds = ids;
            keys = nil;
            ids = nil;
            [self.categoryTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self show:@"请求失败..." time:1];
        }];
    }else{
        self.categoryKeys = self.categoryListKeys;
        self.categoryDicts = self.categoryListDicts;
        [self.categoryTableView reloadData];
    }
    
}

- (void)requestOnlineBrandList{
    // 索引
    UIView *sectionView = nil;
    if (self.sectionTitlesView.superview == nil) {
        sectionView = [[UIView alloc] init];
        sectionView.backgroundColor = [UIColor colorWithHexString:@"323232"];
        sectionView.frame = CGRectMake(self.view.frame.size.width - 20, 0, 20, self.view.frame.size.height);
        [[UIApplication sharedApplication].keyWindow addSubview:_sectionTitlesView = sectionView];
        
        [UIView animateWithDuration:.25 animations:^{
            self.categoryTableView.ml_x = 30;
        }];
    }
    
    if (!self.brandsDicts) {
        
        [KVNProgress showWithStatus:@"正在请求..."];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/categoryBrand"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [KVNProgress dismiss];
            
            self.brandsKeys = [[[responseObject valueForKeyPath:@"data"] allKeys] sortedArrayUsingSelector:@selector(compare:)];
          //  NSLog(@"response:%@",[responseObject valueForKeyPath:@"data"]);
            
            
            
            self.categoryKeys = self.brandsKeys;
            
            NSMutableArray *Brangids = [NSMutableArray array];
            
            for (NSDictionary *dict in [self.categoryDicts allValues]) {
                [Brangids addObject:[dict allKeys]];
            }
            
            self.brandsDicts = [responseObject valueForKeyPath:@"data"];
            self.categoryDicts = self.brandsDicts;
            self.categoryIds = Brangids;
            [self.categoryTableView reloadData];
            
            if (self.sectionTitlesView.subviews.count == 0) {
                CGFloat height = (self.view.frame.size.height - self.categoryTableView.tableHeaderView.frame.size.height) / self.categoryKeys.count;
                for (NSInteger i = 0; i < self.categoryKeys.count; i++) {
                    UIButton *sectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    sectionBtn.backgroundColor = [UIColor colorWithHexString:@"262626"];
                    sectionBtn.tag = i;
                    [sectionBtn setTitleColor:[UIColor colorWithHexString:@"a1a1a1"] forState:UIControlStateNormal];
                    sectionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                    sectionBtn.frame = CGRectMake(0, self.categoryTableView.tableHeaderView.frame.size.height + i * height, 20, height);
                    [sectionBtn setTitle:self.categoryKeys[i] forState:UIControlStateNormal];
                    [sectionView addSubview:sectionBtn];
                    [sectionBtn addTarget:self action:@selector(jumpSection:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           [self show:@"请求失败..." time:1];
        }];
    }else{
        self.categoryDicts = self.brandsDicts;
        self.categoryKeys = self.brandsKeys;
        [self.categoryTableView reloadData];
    }
    
    
}
#pragma mark - 点击了 在线品牌/分类浏览
- (void)clickCategoryItem:(UIButton *)btn{
    if (btn.tag == 0) {
        [UIView animateWithDuration:.25 animations:^{
            [self.brandButton setTitleColor:self.categoryLineView.backgroundColor forState:UIControlStateNormal];
            [self.categoryListButton setTitleColor:self.categoryLineView.backgroundColor forState:UIControlStateNormal];
            self.categoryLineView.ml_x = 0;
            
        }];
        
        self.sectionTitlesView.hidden = NO;
        // 请求数据
        [self requestOnlineBrandList];
    }else{
        [UIView animateWithDuration:.25 animations:^{
            [self.categoryListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.brandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.categoryLineView.ml_x = self.categoryLineView.ml_width;
        }];
        
        self.sectionTitlesView.hidden = YES;
        // 请求数据
        [self requestOnlineCategoryList];
    }
    
}

- (void)jumpSection:(UIButton *)btn{
    [self.categoryTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:btn.tag] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)removeFromMaskView:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:.15 animations:^{
        self.categoryTableView.ml_x = self.view.ml_width;
    } completion:^(BOOL finished) {
        [self.categoryTableView removeFromSuperview];
        [self.sectionTitlesView removeFromSuperview];
        [tap.view removeFromSuperview];
    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag ==10000) {
        return _MenuItemArray.count;
    }else{
        return _adverts.count;
    }
    
}

#pragma mark - <UICollectionViewDelegate>－－－轮播图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MBHomeAdCollectionViewCell";
    static NSString *ID2 = @"collectionViewCell";
    
    if (collectionView.tag == 10000) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID2 forIndexPath:indexPath];
        
        UITableView *tableView = [[cell.contentView subviews] lastObject];
        if (!([tableView isKindOfClass:[UITableView class]] || [tableView isEqual:self.tableView])) {
            
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_Y, self.view.ml_width, UISCREEN_HEIGHT - TOP_Y - self.tabBarController.tabBar.ml_height ) style:UITableViewStylePlain];
            tableView.backgroundColor = self.view.backgroundColor;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

            [tableView registerNib:[UINib nibWithNibName:@"MBMallItemCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBMallItemCategoryTableViewCell"];
            tableView.dataSource = self , tableView.delegate = self;
            
        }
        
        if (indexPath.row == 0) {
            
            self.headerView = [self tableViewHeaderView];
            // 设置幻灯片
            [self setupAd];
            // 定时器自动滚动
            [self addTimer];
            // 设置幻灯片底下活动按钮
            [self setupActivesItems];
            // 限时秒杀
            [self setupTimeLimit];
            // 爆款
            [self setupBaokuan];
            // 回到顶部按钮
            [self setupTopButton];
            
            self.headerView.ml_height = CGRectGetMaxY([[self.headerView.subviews lastObject] frame]);
            tableView.tableHeaderView = self.headerView;
           
            self.isFirstLoadCollectionView = NO;
        }else{
            self.isFirstLoadCollectionView = YES;
            tableView.tableHeaderView = nil;
        }
         tableView.contentInset = UIEdgeInsetsMake(0, 0, 32, 0);
        tableView.tag = 101 + indexPath.row;
        tableView.backgroundColor = self.view.backgroundColor;
        self.tableView = tableView;
        [tableView reloadData];
        [cell.contentView addSubview:tableView];
        
        if (!self.centerAdverts.count) {
            // 中间广告
         
            [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"index/middle_advert"] parameters:nil success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
          
                self.centerAdverts = (NSArray *)responseObject.data;
                if([self.centerAdverts count] > 0){
                    NSDictionary *advertDict = self.centerAdverts[self.centerAdverts.count - 1];
                    
                    [self.baokuanBtn sd_setImageWithURL:advertDict[@"ad_code"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
                    
                    [self.timeLimitView.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
                        if (idx < self.centerAdverts.count) {
                            NSDictionary *advertDict = self.centerAdverts[idx];
                            [btn sd_setImageWithURL:advertDict[@"ad_code"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
                        }
                    }];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }else{
            NSDictionary *advertDict = self.centerAdverts[self.centerAdverts.count - 1];
            [self.baokuanBtn sd_setImageWithURL:advertDict[@"ad_code"] forState:UIControlStateNormal];
            
            [self.timeLimitView.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
                if (idx < self.centerAdverts.count) {
                    NSDictionary *advertDict = self.centerAdverts[idx];
                    [btn sd_setImageWithURL:advertDict[@"ad_code"] forState:UIControlStateNormal];
                }
            }];
        }
        
        return cell;
    }else{
        
        MBHomeAdCollectionViewCell *cell = (MBHomeAdCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.imageView.contentMode =UIViewContentModeScaleAspectFill;
        if(indexPath.row < [self.adverts count]){
            MBAdvert *advert = self.adverts[indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",advert.ad_code]]placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
            cell.imageView.userInteractionEnabled = YES;
            
        }
    
        
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_HeaderadArray.count<=indexPath.row) {
        return;
    }

    
    if (collectionView.tag !=1000) {
        NSDictionary *dic = _HeaderadArray[indexPath.row];
        NSString *str= dic[@"ad_link"];
        MBSmallCategoryViewController *categoryVc = [[MBSmallCategoryViewController alloc] init];
        categoryVc.act_id =[self componentsSeparatedByString:str];
        categoryVc.type = @"2";
        categoryVc.act_img = [[self.centerAdverts objectAtIndex:0] valueForKeyPath:@"ad_code"];
        
        [self.navigationController pushViewController:categoryVc animated:YES];
    }
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    
    
    if (scrollView.isDragging) {
        [self removeTimer];
    }
    
    if ([scrollView isEqual:self.adCollectionView]){
        CGFloat currentPage = (scrollView.contentOffset.x / scrollView.ml_width) + 0.5;
        self.adPageControl.currentPage = currentPage;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    
    
    if (!scrollView.isDragging && self.timer == nil) {
        [self addTimer];
    }
    
    if ([scrollView isEqual:self.collectionView]) {
        CGFloat currentPage = (scrollView.contentOffset.x / scrollView.ml_width);
        [self.menuScrollView setSelectedWithIndex:currentPage];
        [self scrollViewDidEndScrollingAnimation:scrollView];
        if (currentPage == 0) {
            
            if(self.isTeMai == 3){
                self.isTeMai = 1;
                _typeTable = @"tie";
                [self getTeMaiAndTuiChu:@"1"];
            }
        }else{
           
            self.isTeMai = 3;
            _typeTable = @"new";
        
            [self getFavourableList:currentPage width:(MBHomeMenuScrollView *)scrollView];
        }
        
        self.currentScrollIndex = currentPage;
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.collectionView]) {
    NSInteger currentPage = (scrollView.contentOffset.x / scrollView.ml_width);
    MBHomeMenuButton *button =self.menuScrollView.buttonArray[currentPage];
    CGFloat offsetx = button.center.x - self.menuScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.menuScrollView.contentOffset.y);
    [self.menuScrollView setContentOffset:offset animated:YES];
    }
}

#pragma mark - <MBHomeMenuScrollViewDelegate>
- (void)homeMenuScrollView:(MBHomeMenuScrollView *)scrollView didSelectedIndex:(NSInteger)index{
    
    if (index == 0) {
        _flag =0;
        self.isTeMai = 1;
        [self getTeMaiAndTuiChu:@"1"];
        _typeTable = @"tie";
        [self.collectionView setContentOffset:CGPointMake((index  * scrollView.ml_width), self.collectionView.contentOffset.y) animated:YES];
    }else{
        self.isTeMai = 3;
        _typeTable = @"new";
       
        [self getFavourableList:index width:scrollView];
    }
    
    self.currentScrollIndex = index;
    
}
#pragma mark -- 获取这样”{type:2,id:2072}“字符串里面的 ID－>2072;
- (NSString *)componentsSeparatedByString:(NSString *)str{

    NSArray *arr = [str componentsSeparatedByString:@","];
    NSArray *arr1 = [[arr lastObject] componentsSeparatedByString:@":"];
    NSString *ID = [arr1 lastObject];
    ID = [ID substringWithRange:NSMakeRange(0, ID.length - 1)];
    return ID;
}
@end
