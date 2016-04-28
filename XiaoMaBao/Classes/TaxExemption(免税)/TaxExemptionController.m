//
//  TaxExemptionController.m
//  XiaoMaBao
//
//  Created by 朱理哲 on 15/8/27.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "TaxExemptionController.h"

#import "MBHomeViewController.h"
#import "MBHomeMenuScrollView.h"
#import "MBLoginShareButton.h"
#import "MBHomeMenuButton.h"
#import "MBHomeCategoryCell.h"
#import "MBMallItemCategoryTableViewCell.h"
#import "MBShopingViewController.h"
#import "MBHomeAdCollectionViewCell.h"
#import "MBActivityViewController.h"
#import "MBSearchViewController.h"

#import "UIImageView+WebCache.h"
#import "NSString+BQ.h"


#import "UIButton+WebCache.h"
#import "MBNetworking.h"
#import "MJExtension.h"
#import "MBAdvert.h"
#import "MBSignaltonTool.h"
#import "MBMyCollectionViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "iCarousel.h"
@interface TaxExemptionController () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,iCarouselDataSource,iCarouselDelegate,MBHomeMenuScrollViewDelegate>

@property (weak,nonatomic) UICollectionView *collectionView;
@property (weak,nonatomic) MBHomeMenuScrollView *menuScrollView;
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

@property (nonatomic, copy) NSString *typeTable;
//iCarousel
@property (nonatomic, weak) iCarousel *carousel;

@end

@implementation TaxExemptionController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"免税";
    
   iCarousel *carousel = [[iCarousel alloc]init];
    carousel.frame = CGRectMake(0, TOP_Y +  28, self.view.ml_width, self.view.ml_height - TOP_Y - 44 - 28) ;
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.type = iCarouselTypeLinear;
    carousel.pagingEnabled = YES;
    carousel.scrollSpeed = 2;
    self.carousel = carousel;

    [self.view addSubview:self.carousel];
   // [self.view addSubview:[self generateView]];
    [self getMenuItem:@"2"];
    [self requestData:@"2"];
}

#pragma mark - 生成view
-(UIView*)generateView{
    UITableView* tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - 44 ))];
    [tableView registerNib:[UINib nibWithNibName:@"MBMallItemCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBMallItemCategoryTableViewCell"];
    tableView.contentInset = UIEdgeInsetsMake(28, 0, 0, 0);
    tableView.dataSource = self ;
    tableView.delegate = self ;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView = tableView ;
    return tableView ;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂时没有相关商品，我们会尽快备货";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"敬请期待！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"illustration_big_3"];
}

#pragma mark - 获取item菜单
-(void)getMenuItem:(NSString *)menu_type
{
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getFavourableMenu"] parameters:@{@"menu_type":menu_type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
        _MenuItemArray = [NSMutableArray array];
        _MenuItemId = [NSMutableArray array];
        
        for (NSDictionary *dict in [responseObject valueForKeyPath:@"data"]) {
            [_MenuItemArray addObject:[dict valueForKeyPath:@"menu_name"]];
            [_MenuItemId addObject:[dict valueForKeyPath:@"menu_id"]];
        }
        [self setupMenuItemWithItem:_MenuItemArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

- (void)setupMenuItemWithItem:(NSArray*)titles{
    MBHomeMenuScrollView *scrollView = [[MBHomeMenuScrollView alloc] init];
    scrollView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, 28);
    scrollView.homeDelegate = self ;
    [self.view addSubview:scrollView];
    self.menuScrollView = scrollView;
//      for (NSInteger i = 0; i < titles.count - 1;i++) {
//        if (i == 0) {
//            [scrollView setTitle:titles[i]];
//            continue;
//        }
//        [scrollView setTitle:titles[i]];
//    }
    
    for (NSInteger i = 0; i<10; i++) {
        if (i == 0) {
        [scrollView setTitle:[NSString stringWithFormat:@"测试%ld",i]];
        continue;
                    }
                    [scrollView setTitle:[NSString stringWithFormat:@"测试%ld",i]];
    }
}


-(void)animateReload{
    [UIView transitionWithView:self.tableView duration:.2 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        
    }];
}

//获取数据
-(void)requestData:(NSString *)menu_id
{
    NSDictionary *pagination = @{@"page":@"1", @"count":@"100",@"menu_id":menu_id};
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getFavourableList"] parameters:pagination success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _TeMaiArarry = [responseObject valueForKeyPath:@"data"];
        
        
        [self.carousel reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma ark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return  self.view.ml_width*333/750;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _TeMaiArarry.count ;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBMallItemCategoryTableViewCell *cell  = (MBMallItemCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MBMallItemCategoryTableViewCell" forIndexPath:indexPath];
    
        cell.decribe.text = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_name"];
        cell.zheKou.text = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"favourable_name"];
        NSString *urlstr = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_img"];
        NSString *endStr = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"active_remainder_time"];
        NSString *timeStr = [NSDate deltaTimeFrom:nil end:endStr];
        cell.LeavesTime.text = timeStr;
        NSURL *url = [NSURL URLWithString:urlstr];
        [cell.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
        cell.startTimerLabel.hidden = YES;
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
    categoryVc.act_id = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_id"];
    categoryVc.title = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_name"];
  
    [self.navigationController pushViewController:categoryVc animated:YES];
}

-(NSInteger)numberOfItemsInCarousel:(iCarousel * __nonnull)carousel
{
    return _MenuItemArray.count;

}
-(UIView *)carousel:(iCarousel * __nonnull)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
   
    UITableView* v =  (UITableView*)[self generateView ];
    v.tableFooterView = [UIView new];
    v.frame = self.carousel.bounds;
    return v;
}
-(void)carouselCurrentItemIndexDidChange:(iCarousel * __nonnull)carousel
{
    if (_MenuItemId==nil||_MenuItemId.count==0)return ;
    [self requestData:_MenuItemId[carousel.currentItemIndex]];
    [self.menuScrollView setSelectedWithIndex:carousel.currentItemIndex];

}

-(CGFloat)carousel:(iCarousel * __nonnull)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    
    return value;
}

#pragma maek --  头部分类点击事件
- (void)homeMenuScrollView:(MBHomeMenuScrollView *)scrollView didSelectedIndex:(NSInteger)index{
   
    if (_MenuItemId==nil||_MenuItemId.count==0)return ;
    
    [self requestData:_MenuItemId[index]];
    [self.menuScrollView setSelectedWithIndex:index];
    self.carousel.currentItemIndex = index ;
}


@end
