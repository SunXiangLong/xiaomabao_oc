//
//  MBCategoryViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCategoryViewController.h"
#import "MBCategoryViewTwoCell.h"
#import "MBCategoryViewOneCell.h"
#import "MBShopingViewController.h"
#import "MBDetailedViewController.h"
@interface MBCategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataArray;
    NSInteger _page;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MBCategoryViewController
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBCategoryViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBCategoryViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1"];
   [_collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewOneCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewOneCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewTwoCell"];
    _dataArray = [NSMutableArray array];
    [self setData];
    
    _page = 2;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    
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
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/AffordablePlanet/child_category_index/"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",url,self.cat_id];
    [MBNetworking newGET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        NSLog(@"%@ ",responseObject);
        
        
        if (responseObject) {
            
            NSMutableArray *category = [NSMutableArray arrayWithArray:[responseObject valueForKey:@"category"]];
             NSMutableArray *goods_list = [NSMutableArray arrayWithArray:[responseObject valueForKey:@"goods_list"]];
            
            [_dataArray addObject:category];
              [_dataArray addObject:goods_list];
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
#pragma mark -- 上拉加载
- (void)setheadData{
    
    [self show];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/AffordablePlanet/get_category_goods/"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@",url,self.cat_id,page];
    [MBNetworking newGET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        NSLog(@"%@ ",responseObject);
        
          [self.collectionView .mj_footer endRefreshing];
        if (responseObject) {
            NSMutableArray *arr = _dataArray[1];
            if ([[responseObject valueForKey:@"goods_list"] count]>0) {
              
                [arr addObjectsFromArray:[responseObject valueForKey:@"goods_list"]];
                [self.collectionView reloadData];
                
                _page ++;
            }else{
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
           
        }else{
         [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
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
#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 3;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return   UIEdgeInsetsMake(3, 3, 3, 3);
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = _dataArray[section];
    return arr.count;
   
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.section][indexPath.item];
    if (indexPath.section==0) {
       MBCategoryViewOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBCategoryViewOneCell" forIndexPath:indexPath];
        if (![dic[@"icon"]isEqualToString:@""]) {
         [cell.showImagaeView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        }else{
         [cell.showImagaeView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]] placeholderImage:[UIImage imageNamed:@""]];
        }
    
        cell.name.text = dic[@"cat_name"];
        return cell;
    }else{
        MBCategoryViewTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBCategoryViewTwoCell" forIndexPath:indexPath];
         [cell.showImageVIew sd_setImageWithURL:[NSURL URLWithString:dic[@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.describeLabel.text = dic[@"goods_name"];
        cell.shop_price.text = [NSString stringWithFormat:@"¥ %@",dic[@"goods_price"]];
        return cell;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        
        if (indexPath.section == 1) {
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView1" forIndexPath:indexPath];
            UIImageView *imageView = [[UIImageView   alloc] init];
            imageView.backgroundColor = [UIColor colorWithHexString:@"606060"];
            [reusableview addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(50);
                make.right.mas_equalTo(-50);
                make.height.mas_equalTo(1);
                
            }];
            
            UILabel *lable = [[UILabel alloc] init];
            lable.backgroundColor  = [UIColor colorWithHexString:@"ecedf1"];
            lable.text = @"麻包精选";
            lable.textAlignment = 1;
            lable.font  = [UIFont systemFontOfSize:15];
            lable.textColor = [UIColor colorWithHexString:@"606060"];
            [reusableview addSubview:lable];
            
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.mas_equalTo(0);
                make.width.mas_equalTo(80);
            }];
            return reusableview;
        }
   
    }
     return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = _dataArray[indexPath.section][indexPath.item];
    if (indexPath.section==1) {
        MBShopingViewController  *VC = [[MBShopingViewController alloc] init];
        VC.GoodsId = dic[@"goods_id"];
        [self pushViewController:VC Animated:YES];
        return;
    }else{
     if (![dic[@"icon"]isEqualToString:@""]) {
        MBDetailedViewController  *VC = [[MBDetailedViewController alloc] init];
         VC.cat_id =  dic[@"cat_id"];
         VC.title = dic[@"cat_name"];
        [self pushViewController:VC Animated:YES];
     }
     }
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(UISCREEN_WIDTH/4, UISCREEN_WIDTH/4+7);
    }
    
    return  CGSizeMake((UISCREEN_WIDTH-9)/2,(UISCREEN_WIDTH-9-29)/2+98);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return CGSizeMake(UISCREEN_WIDTH, 45);
    }
    return CGSizeMake(0, 0);
    
}
@end
