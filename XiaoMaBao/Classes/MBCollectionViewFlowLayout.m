//
//  MBCollectionViewFlowLayout.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCollectionViewFlowLayout.h"

@implementation MBCollectionViewFlowLayout
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

   return [super layoutAttributesForItemAtIndexPath:indexPath];
}

//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSArray * original   = [super layoutAttributesForElementsInRect:rect];
//    NSArray * array = [[NSArray alloc] initWithArray:original copyItems:YES];
//    return array;
//}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获得super已经计算好的布局属性
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:original copyItems:YES];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        
        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1 - delta / self.collectionView.frame.size.width;
        
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return array;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
