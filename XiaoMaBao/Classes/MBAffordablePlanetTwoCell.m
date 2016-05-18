//
//  MBAffordablePlanetTwoCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetTwoCell.h"
#import "MBAffordablePlanetTwoChildOneCell.h"
#import "MBCategoryViewController.h"
@interface MBAffordablePlanetTwoCell()<UICollectionViewDelegate,UICollectionViewDataSource>
{

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation MBAffordablePlanetTwoCell

- (void)awakeFromNib {
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBAffordablePlanetTwoChildOneCell" bundle:nil] forCellWithReuseIdentifier:@"MBAffordablePlanetTwoChildOneCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource  = self;
}
#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return   UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBAffordablePlanetTwoChildOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetTwoChildOneCell" forIndexPath:indexPath];
    if (indexPath.row==3||indexPath.row==7) {
        cell.h_view.hidden = YES;
    }
    if (indexPath.item>3) {
         cell.w_view.hidden = YES;
    }
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.item][@"icon"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cell.name.text  = _dataArray[indexPath.item][@"cat_name"];
    return cell;
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBCategoryViewController *VC = [[MBCategoryViewController alloc] init];
    VC.title = _dataArray[indexPath.item][@"cat_name"];
    VC.cat_id = _dataArray[indexPath.item][@"cat_id"];
    [self.VC pushViewController:VC Animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return  CGSizeMake((UISCREEN_WIDTH-18)/4,(UISCREEN_WIDTH-18)/4+21);
    
    
    
}

@end
