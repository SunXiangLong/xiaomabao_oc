//
//  MBAffordablePlanetTabCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBAffordablePlanetTabCell.h"
#import "MBAffordablePlanetCVCell.h"
@implementation MBAffordablePlanetCV

@end
@implementation MBAffordablePlanetTabCell
- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(15, 8, 15, 8);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    layout.itemSize = CGSizeMake((UISCREEN_WIDTH - 31)/2, (UISCREEN_WIDTH - 31)/2 * 213/348);
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.scrollEnabled = NO;
}


@end
@implementation MBAffordablePlanetTabToCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(110, 155);
    self.collectionView.collectionViewLayout = layout;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MBAffordablePlanetCVToCell class] forCellWithReuseIdentifier:@"MBAffordablePlanetCVToCell"];
}
-(void)setModel:(TodayRecommendBotModel *)model{
    _model = model;
    [_bandImageView sd_setImageWithURL:model.ad_img placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    _collectionView.indexPath = _indexPath;
    
    [_collectionView reloadData];
   
    CGFloat offset  = [self.contentOffsetDictionary[[@(_indexPath.row) stringValue]] floatValue];
    if (offset) {
        [_collectionView setContentOffset:CGPointMake(offset, 0) animated:false];
    }else{
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:false];
    }
    
}
@end
@implementation MBFreeStoreTabCell
- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(110, 155);
    self.collectionView.collectionViewLayout = layout;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MBAffordablePlanetCVToCell class] forCellWithReuseIdentifier:@"MBAffordablePlanetCVToCell"];
}
-(void)setContentOffsetDictionary:(NSMutableDictionary *)contentOffsetDictionary{
    _contentOffsetDictionary = contentOffsetDictionary;
    CGFloat offset  = [self.contentOffsetDictionary[@"top"] floatValue];
    if (offset) {
        [_collectionView setContentOffset:CGPointMake(offset, 0) animated:false];
    }else{
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:false];
    }

}

@end
