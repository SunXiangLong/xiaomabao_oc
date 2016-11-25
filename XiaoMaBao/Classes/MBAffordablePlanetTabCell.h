//
//  MBAffordablePlanetTabCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAffordablePlanetModel.h"
#import "MBFreeStoreModel.h"
@interface MBAffordablePlanetCV : UICollectionView
@property(strong,nonatomic)NSIndexPath *indexPath;

@end
@interface MBAffordablePlanetTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MBAffordablePlanetCV *collectionView;
@end
@interface MBAffordablePlanetTabToCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bandImageView;
@property (weak, nonatomic) IBOutlet MBAffordablePlanetCV *collectionView;
@property (nonatomic,strong)  TodayRecommendBotModel *model;
@property(copy,nonatomic)NSMutableDictionary *contentOffsetDictionary;
@property(copy,nonatomic)NSIndexPath *indexPath;
@end
@interface MBFreeStoreTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MBAffordablePlanetCV *collectionView;
@property(copy,nonatomic)NSMutableDictionary *contentOffsetDictionary;
@end
