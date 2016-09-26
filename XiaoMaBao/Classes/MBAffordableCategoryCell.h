//
//  MBAffordableCategoryCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BFIndexedCollectionView : UICollectionView


@end
static NSString *AffordableCategoryCollectionCell = @"MBAffordableCategoryCollectionCell";
@interface MBAffordableCategoryCell : UITableViewCell
@property (strong, nonatomic)  BFIndexedCollectionView *collectionView;
- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate;
@end
