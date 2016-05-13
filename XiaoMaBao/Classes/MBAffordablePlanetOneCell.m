//
//  MBAffordablePlanetOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetOneCell.h"
#import "MBMBAffordablePlanetOneChildeOneCell.h"
#import "MBActivityViewController.h"
#import "MBGroupShopController.h"
@interface MBAffordablePlanetOneCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

{


}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation MBAffordablePlanetOneCell

- (void)awakeFromNib {
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBMBAffordablePlanetOneChildeOneCell" bundle:nil] forCellWithReuseIdentifier:@"MBMBAffordablePlanetOneChildeOneCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource  = self;
}
#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return   UIEdgeInsetsMake(10, 9, 0, 9);

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = _dataArray[section];
    
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = _dataArray[indexPath.section];
        MBMBAffordablePlanetOneChildeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBMBAffordablePlanetOneChildeOneCell" forIndexPath:indexPath];
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:arr[indexPath.row][@"ad_img"]] placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
        return cell;
        
   
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        MBGroupShopController  *VC = [[MBGroupShopController alloc] init];
        [self.VC pushViewController:VC Animated:YES];
        return;
    }
     MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
     categoryVc.title = _dataArray[indexPath.section][indexPath.item][@"act_name"];
     categoryVc.act_id =  _dataArray[indexPath.section][indexPath.item][@"act_id"];
    [self.VC pushViewController:categoryVc Animated:YES];
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*231/642);
    }else if(indexPath.section ==1){
      return CGSizeMake((UISCREEN_WIDTH-28)/3, (UISCREEN_WIDTH-28)/3 *232/195);
    }
        
    return  CGSizeMake((UISCREEN_WIDTH-23)/2,(UISCREEN_WIDTH-23)/2*160/299);
    
    
    
}
@end
