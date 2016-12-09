//
//  MBBrandViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBrandViewController.h"
#import "MBSellingCollectionViewCell.h"
#import "MBMoreBrandsCollectionViewCell.h"
#import "MBStyleCollectionViewCell.h"
#import "MBShopingViewController.h"
#import "MBTimeModel.h"
@interface MBBrandViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSTimer  *_timer;
    NSString *_end_time;
    NSString *_mid_banner;
    NSString *_mid_link;
    NSString *_top_banner;
    NSArray *_hot_goods;
    NSArray *_group_topics;
    NSArray *_normal_goods;
    NSInteger lettTimes;
    NSMutableArray *_timeModel;
 
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *daylable;
@property (weak, nonatomic) IBOutlet UILabel *secondlable;
@property (weak, nonatomic) IBOutlet UILabel *hourLable;
@property (weak, nonatomic) IBOutlet UILabel *minuteLable;

@end

@implementation MBBrandViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBBrand"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBBrand"];
    [_timer invalidate];
    _timer = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = self.titles;
    _timeModel = [NSMutableArray array];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBSellingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBSellingCollectionViewCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBStyleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBStyleCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBMoreBrandsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBMoreBrandsCollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2"];
    [self setData];
}
- (void)setData{
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/group/topic") parameters:@{@"topic_id":self.goodId} success:^(id responseObject) {
        [self dismiss];
        if (responseObject) {
            NSDictionary *userData = (NSDictionary *)responseObject;
            MMLog(@"%@",userData);
            _end_time = userData[@"end_time"];
            _mid_banner = userData[@"mid_banner"];
            _mid_link = userData[@"mid_link"];
            _top_banner = userData[@"top_banner"];
            _hot_goods = userData[@"hot_goods"];
            [self setModel];
            [self createTimer];
            _group_topics = userData[@"group_topics"];
            _normal_goods = userData[@"normal_goods"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
    
    
}
#pragma mark - 倒计时
-(void)setModel{

    for (NSDictionary *dic in _hot_goods) {
        MBTimeModel *model = [[MBTimeModel alloc] init];
        model.timeNum = [dic[@"promote_end_date"] integerValue] - (NSInteger)[[NSDate date] timeIntervalSince1970];
        [_timeModel addObject:model];
    }
    
    _collectionView.delegate =self;
    _collectionView.dataSource = self;
     _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}
- (void)createTimer {
    
   _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)timerEvent{
        for (int i = 0 ; i<_hot_goods.count; i++) {
            MBTimeModel *model = _timeModel[i];
            [model countDown];
        }
    
    
    [self timeFireMethod];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
}

#pragma mark -- 图片点击手势
- (void)SingleTap{

    MBShopingViewController *VC = [[MBShopingViewController alloc] init];
    VC.GoodsId = _mid_link;
    [self pushViewController:VC Animated:YES];

}
#pragma mark -- banner图上倒计时
- (void)timeFireMethod{
    lettTimes --;
    NSInteger leftdays = lettTimes/(24*60*60);
    NSInteger hour = (lettTimes-leftdays*24*3600)/3600;
    NSInteger minute = (lettTimes - hour*3600-leftdays*24*3600)/60;
    NSInteger second = (lettTimes - hour *3600 - 60*minute-leftdays*24*3600);
    self.daylable.text = [NSString stringWithFormat:@"%ld",leftdays];
    self.secondlable.text = [NSString stringWithFormat:@"%ld",hour];
    self.hourLable.text = [NSString stringWithFormat:@"%ld",minute];
    self.minuteLable.text = [NSString stringWithFormat:@"%ld",second];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UICollectionViewdelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    return insets;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        
        if (indexPath.section == 0) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            UIImageView *shopImgView = [[UIImageView alloc] init];
            shopImgView.frame = CGRectMake(0,0, self.view.ml_width , self.view.ml_width*35/75);
            [shopImgView sd_setImageWithURL:[NSURL URLWithString:_top_banner] placeholderImage:[UIImage imageNamed:@"placeholder_num3"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                shopImgView.alpha = 0.3f;
                [UIView animateWithDuration:1
                                 animations:^{
                                     shopImgView.alpha = 1.0f;
                                 }
                                 completion:nil];
                
            }];
            [reusableview addSubview:shopImgView];
            _timeView.frame = CGRectMake(UISCREEN_WIDTH-20-170, shopImgView.ml_height-18, 170, 16);
            
            lettTimes = [_end_time integerValue] - (NSInteger)[[NSDate date] timeIntervalSince1970];
            if (lettTimes<0) {
                
            }else{
            
              [shopImgView addSubview:_timeView];
            }
           
         
            UILabel *lable   = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(shopImgView.frame)+10, UISCREEN_WIDTH-20, 40)];
            lable.backgroundColor = [UIColor colorR:0 colorG:83 colorB:191];
            lable.text = @"热卖爆款";
            lable.textAlignment = 1;
            lable.textColor = [UIColor whiteColor];
            [reusableview addSubview:lable];
            
            return reusableview;
        }else if(indexPath.section == 1){
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1" forIndexPath:indexPath];
            UIImageView *shopImgView = [[UIImageView alloc] init];
            shopImgView.userInteractionEnabled = YES;
            shopImgView.frame = CGRectMake(0,0, self.view.ml_width , self.view.ml_width*240/640);
            [shopImgView sd_setImageWithURL:[NSURL URLWithString:_mid_banner] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                shopImgView.alpha = 0.3f;
                [UIView animateWithDuration:1
                                 animations:^{
                                     shopImgView.alpha = 1.0f;
                                 }
                                 completion:nil];
                
            }];

            
            UITapGestureRecognizer *single = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap)];
            single.numberOfTapsRequired = 1;
            [shopImgView addGestureRecognizer:single];
            
            [reusableview addSubview:shopImgView];
            return reusableview;
        }else{
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView2" forIndexPath:indexPath];
            UILabel *lable   = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UISCREEN_WIDTH-20, 40)];
            lable.backgroundColor = [UIColor colorR:0 colorG:83 colorB:191];
            lable.text = @"更多品牌";
            lable.textAlignment = 1;
            lable.textColor = [UIColor whiteColor];
            [reusableview addSubview:lable];
            return  reusableview;
        }
        
    }
    
    return nil;
}






- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _hot_goods.count;
    }else if(section == 1){
        return _normal_goods.count;
    }else{
        
        return _group_topics.count;
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        MBSellingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBSellingCollectionViewCell" forIndexPath:indexPath];
        cell.shopName.text = _hot_goods[indexPath.row][@"name"];
        cell.org_price.text = [NSString stringWithFormat:@"¥%@", _hot_goods[indexPath.row][@"org_price"]];
        cell.market_price.text = [NSString stringWithFormat:@"¥%@", _hot_goods[indexPath.row][@"market_price"]];
        cell.salesnum.text = _hot_goods[indexPath.row][@"salesnum"];
        [cell loadData:_timeModel[indexPath.item] indexPath:indexPath];
        [cell.nationalImageView sd_setImageWithURL:[NSURL URLWithString:_hot_goods[indexPath.row][@"origin_pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.nationalImageView.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.nationalImageView.alpha = 1.0f;
                             }
                             completion:nil];
        }];
        [cell.shopImageView sd_setImageWithURL:[NSURL URLWithString:_hot_goods[indexPath.row][@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.shopImageView.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.shopImageView.alpha = 1.0f;
                             }
                             completion:nil];
            
        }];
        return cell;
    }else if(indexPath.section == 1){
        MBStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBStyleCollectionViewCell" forIndexPath:indexPath];
        
        cell.shopNameLable.text =  _normal_goods[indexPath.row][@"name"];
        cell.org_price.text = _normal_goods[indexPath.row][@"org_price"];
        cell.market_price.text = _normal_goods[indexPath.row][@"market_price"];
        cell.discount.text = [NSString stringWithFormat:@"%@折",_normal_goods[indexPath.row][@"discount"]];
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:_normal_goods[indexPath.row][@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.showImageView.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.showImageView.alpha = 1.0f;
                             }
                             completion:nil];
            
        }];
        
        return cell;
    }else{
        
        MBMoreBrandsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMoreBrandsCollectionViewCell" forIndexPath:indexPath];
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:_group_topics[indexPath.row][@"ad_code"]] placeholderImage:[UIImage imageNamed:@"placeholder_num3"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.showImageView.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.showImageView.alpha = 1.0f;
                             }
                             completion:nil];
            
        }];

        return cell;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MBShopingViewController *VC = [[MBShopingViewController alloc] init];
        VC.GoodsId = _hot_goods[indexPath.row][@"goods_id"];
        [self pushViewController:VC Animated:YES];
    }else if(indexPath.section == 1){
        MBShopingViewController *VC = [[MBShopingViewController alloc] init];
        VC.GoodsId = _normal_goods[indexPath.row][@"goods_id"];
        [self pushViewController:VC Animated:YES];
    }else{
        
        MBBrandViewController *VC = [[MBBrandViewController alloc] init];
        VC.goodId = _group_topics[indexPath.item][@"ad_link"];
        VC.titles = _group_topics[indexPath.item][@"title"];
        [self pushViewController:VC Animated:YES];
    }



}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(UISCREEN_WIDTH-20, 100);
    }else if(indexPath.section == 1){
        return  CGSizeMake((UISCREEN_WIDTH-30)/2, (UISCREEN_WIDTH-40)/2+70);
    }else{
        
        return  CGSizeMake((UISCREEN_WIDTH-30)/2,(UISCREEN_WIDTH-30)/2*35/75);
    }
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*35/75+50);
    }else if(section == 1){
        return CGSizeMake(0, 0*240/640);
    }else{
        return CGSizeMake(UISCREEN_WIDTH, 40);
    }
    
}
@end
