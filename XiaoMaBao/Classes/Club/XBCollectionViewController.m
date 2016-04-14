//
//  XBCollectionViewController.m
//  XBScrollPageControllerDemo
//
//  Created by Scarecrow on 15/9/8.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBCollectionViewController.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "MBcheshiCollectionViewCell.h"
#import "MBCanulaCircleDetailsViewController.h"
#import "MBRecommendedCollectionViewCell.h"
#import "WNXRefresgHeader.h"
@interface XBCollectionViewController ()
{
    NSInteger _page;
    /**
     *  是否是下拉刷新；
     */
    BOOL isHeadRefresh;
}
@end

@implementation XBCollectionViewController

- (instancetype)init{
    JCCollectionViewWaterfallLayout *layout = [[JCCollectionViewWaterfallLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10 ;
    layout.sectionInset = UIEdgeInsetsMake(10, 8, 10, 8);
 
    self = [self initWithCollectionViewLayout:layout];
    if (self) {
    
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"XBCollectionViewController"];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"XBCollectionViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    _page = 2;
    self.collectionView.backgroundColor =  [UIColor  colorR:236 colorG:237 colorB:241];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
   [ self.collectionView registerNib:[UINib nibWithNibName:@"MBRecommendedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBRecommendedCollectionViewCell"];
    
    [self setFootRefres];
//   [self  setHeadRefresh];
}
#pragma mark --上拉加载
- (void)setFootRefres{

    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    
// 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
//    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    
    // 设置footer
    self.collectionView.mj_footer = footer;
    


}

#pragma mark --下拉刷新
- (void)setHeadRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    WNXRefresgHeader *header = [WNXRefresgHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.collectionView.mj_header = header;
}
#pragma mark --刷新数据
- (void)refreshData{
    _page = 1;
 
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talkcatlist"];
   
    [MBNetworking POST:url parameters:@{@"cat_id":self.cat_id,@"page":page}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                  ;
                   NSLog(@"%@",responseObject.data);
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       self.dataArray = [NSMutableArray arrayWithArray:responseObject.data[@"data"]];
                       [self.collectionView reloadData];
                      
                       
                   }
                     [self.collectionView .mj_header endRefreshing];
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self.VC show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   [self.collectionView .mj_header endRefreshing];
                   
               }
     ];
    
    
}
#pragma mark --请求更多商品信息
- (void)setheadData{
    
 
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talkcatlist"];
   
    [self.VC show];
    [MBNetworking POST:url parameters:@{@"cat_id":self.cat_id,@"page":page}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                 NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                    [self.collectionView .mj_footer endRefreshing];
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self.VC dismiss];
                       if (_page<[responseObject.data[@"max_page"] integerValue]+1) {
                           
                           NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
                           [array addObjectsFromArray:responseObject.data[@"data"]];
                           self.dataArray = array;
                           NSLog(@"%lu",(unsigned long)self.dataArray.count);

                           _page++;
                           [self.collectionView reloadData];
                           // 拿到当前的上拉刷新控件，结束刷新状态
                  
                       }else{
                           [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                           return ;
                       }
                       
                   
                       
                   

                
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self.VC show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                 [self.collectionView .mj_footer endRefreshing];
                   
               }
     ];
    
    
}


- (void)dealloc
{
    
       
    XBLog(@"XBCollectionViewController delloc");
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
   return self.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger image_w =0 ;
    NSInteger image_h = 0 ;
    
    if ([self.dataArray[indexPath.item][@"first_img"] isKindOfClass:[NSDictionary class]]) {
        NSString *str1 = self.dataArray[indexPath.item][@"first_img"][@"origin_w"];
        NSString *str2 = self.dataArray[indexPath.item][@"first_img"][@"origin_h"];
        image_w = [str1 integerValue];
        image_h = [str2 integerValue];
        
    }else if ([self.dataArray[indexPath.item][@"imglist"] count] >0)
    {
        NSString *str1 = self.dataArray[indexPath.item][@"imglist"][0][@"ori_width"];
        NSString *str2 = self.dataArray[indexPath.item][@"imglist"][0][@"ori_heigth"];
        image_w = [str1 integerValue];
        image_h = [str2 integerValue];
    }else{
        image_w = 1;
        image_h = 0;
    }
    NSInteger width = (UISCREEN_WIDTH-16-10)/2;
        return CGSizeMake(width, 72+width*image_h/image_w);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    MBRecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBRecommendedCollectionViewCell" forIndexPath:indexPath];
     NSString *str = self.dataArray[indexPath.item][@"content"];
    cell.neirongLable.text  = str;
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item][@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
    cell.userName.text = self.dataArray[indexPath.item][@"user_name"];
    cell.userTime.text = self.dataArray[indexPath.item][@"baby_age"];
    cell.VC =self;
    cell.user_id = self.dataArray[indexPath.item][@"user_id"];
    if ([self.dataArray[indexPath.item][@"first_img"]count]>0   ) {
   [cell.showImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item][@"first_img"][@"origin"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];

    }else if ([self.dataArray[indexPath.item][@"imglist"] count] >0){
       [cell.showImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item][@"imglist"][0][@"origin"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
    }else{
      cell.showImage.image = nil;
    }
   
    
    
    return cell;

  
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
  
    
    
  
    if (offsetY<lunboHeight) {
      
       self.offsetY = offsetY;
    

        
    }else {
        self.offsetY = lunboHeight;


    }
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    MBCanulaCircleDetailsViewController *VC = [[MBCanulaCircleDetailsViewController alloc] init];
    VC.tid = self.dataArray[indexPath.item][@"tid"];


    [self.navigationController pushViewController:VC animated:YES];
}




@end
