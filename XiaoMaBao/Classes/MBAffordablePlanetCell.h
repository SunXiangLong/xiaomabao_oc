//
//  MBAffordablePlanetCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFIndexedCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
static NSString *CollectionViewCellIdentifier = @"MBAffordableCell";
@interface MBAffordablePlanetCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *showImage;
@property (strong, nonatomic)  AFIndexedCollectionView *collectionView;
- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;
@end
