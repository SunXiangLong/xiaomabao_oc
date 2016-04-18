//
//  MBTopCargoTwoCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBTopCargoTwoCell.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "MBTopCargoCell.h"
@implementation MBTopCargoTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setTypeUI:(NSArray *)arry {
    if (_type) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView.collectionViewLayout = layout;
    }else{
        JCCollectionViewWaterfallLayout *layout = [[JCCollectionViewWaterfallLayout alloc] init];
        _collectionView.collectionViewLayout = layout;
    }
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MBTopCargoCell" bundle:nil] forCellWithReuseIdentifier:@"MBTopCargoCell"];
    _collectionView.scrollEnabled = NO;

}
#pragma mark --UICollectionViewdelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (_type) {
        return 10;
    }
    return 25;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (_type) {
        return 8;
    }
    return 16;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (_type) {
         return UIEdgeInsetsMake(10, 8, 10,8);
    }
    return UIEdgeInsetsMake(8, 8, 8,8);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_type) {
        return 4;
    }
        return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBTopCargoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBTopCargoCell" forIndexPath:indexPath];
    cell.backgroundColor  = MBColor;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_type) {
        return CGSizeMake(((UISCREEN_WIDTH-16-12)/2 -30)/2, ((UISCREEN_WIDTH-16-12)/2 -30)/2);
    }
    
    if (indexPath.row == 0) {
       return CGSizeMake((UISCREEN_WIDTH-16 -25)/2, (UISCREEN_WIDTH-16-25)/2*54/43);
    }
    return CGSizeMake((UISCREEN_WIDTH-16 -25)/2 , ((UISCREEN_WIDTH-16-25)/2*54/43 - 16)/2 );
  
    
}


@end
