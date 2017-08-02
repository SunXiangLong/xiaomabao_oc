//
//  YHPhotoBrowserCellLayout.m
//  YHPhotoKit
//
//  Created by deng on 16/12/6.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHPhotoBrowserCellLayout.h"

@implementation YHPhotoBrowserCellLayout

-(id)init
{
    self = [super init];
    if (self) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
         self.itemSize = CGSizeMake(screenSize.width, screenSize.height);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //  每个item在水平方向的最小间距
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.collectionView.contentOffset = CGPointMake(0, 0);
    }
    return self;
}
- (void)prepareLayout {
    [super prepareLayout];
    //滚动结束时,翻动快些
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.pagingEnabled = YES;//滚动视图整页翻动
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end
