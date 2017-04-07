//
//  MBBrandDetailsCollectionViewCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAffordablePlanetModel.h"
@interface MBBrandDetailsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goods_thumb;
@property (weak, nonatomic) IBOutlet YYLabel *goods_price;
@property (weak, nonatomic) IBOutlet YYLabel *goods_name;
@property (weak, nonatomic) IBOutlet YYLabel *market_price;
@property(copy,nonatomic) GoodModel *model;
@end
