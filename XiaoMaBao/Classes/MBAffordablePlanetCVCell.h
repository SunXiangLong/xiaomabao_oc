//
//  MBAffordablePlanetCVCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAffordablePlanetModel.h"
#import "MBFreeStoreModel.h"
@interface MBAffordablePlanetCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bandImageView;
@property(copy,nonatomic)CategoryModel *model;
@property(copy,nonatomic) CountriesCategoryModel *countrieModel;
@end
@interface MBAffordablePlanetCVToCell : UICollectionViewCell
@property (nonatomic,strong) YYLabel    *goodsPrice;
@property (nonatomic,strong) YYLabel    *goodsName;
@property (nonatomic,strong) UIImageView    *goodsThumbImageView;
@property(copy,nonatomic)GoodModel *model;
@end
