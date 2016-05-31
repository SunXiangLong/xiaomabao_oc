//
//  MBFreeStoreViewOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetViewCell.h"
#import "MBFreeStoreViewOnechildCell.h"
#import "MBShopingViewController.h"
#import "MBAffordablePlanetMoreCell.h"
#import "MBActivityViewController.h"
@interface MBAffordablePlanetViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
{
}

@property (weak, nonatomic) IBOutlet UICollectionView *collerctionView;

@end
@implementation MBAffordablePlanetViewCell
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr =dataArr;
    _collerctionView.dataSource = self;
    _collerctionView.delegate = self;
  
   
}
- (void)awakeFromNib {
    UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset =  UIEdgeInsetsMake(0, 0, 0, 0);

    _collerctionView.collectionViewLayout = flowLayout;
    _collerctionView.showsHorizontalScrollIndicator = NO;
  
    [_collerctionView registerNib:[UINib nibWithNibName:@"MBFreeStoreViewOnechildCell" bundle:nil] forCellWithReuseIdentifier:@"MBFreeStoreViewOnechildCell"];
    
    [_collerctionView registerNib:[UINib nibWithNibName:@"MBAffordablePlanetMoreCell" bundle:nil] forCellWithReuseIdentifier:@"MBAffordablePlanetMoreCell"];
}


#pragma mark --UICollectionViewdelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count+1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.dataArr.count) {
        return  CGSizeMake(85,155);
    }
    return  CGSizeMake(120,155);
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item ==_dataArr.count) {
        
        MBAffordablePlanetMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetMoreCell" forIndexPath:indexPath];
       
        return cell;
    }
    
        NSDictionary *dic  = _dataArr[indexPath.item];
        MBFreeStoreViewOnechildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBFreeStoreViewOnechildCell" forIndexPath:indexPath];
        [cell.showImageView sd_setImageWithURL:URL(dic[@"goods_thumb"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.shopName.text = dic[@"goods_name"];
        cell.shopprice.text = string(@"¥", dic[@"goods_price"]);
        return cell;
   
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==_dataArr.count) {
        MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
        categoryVc.title = self.act_name;
        categoryVc.act_id =self.act_id ;
        [self.VC pushViewController:categoryVc Animated:YES];
      
    }else{
        MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
        shopDetailVc.GoodsId = _dataArr[indexPath.item][@"goods_id"];
        [self.VC pushViewController:shopDetailVc Animated:YES];
        
    
    }
    
}

@end
