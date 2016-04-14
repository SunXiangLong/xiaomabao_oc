//
//  MBSmallCategoryCollectionViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/3.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSmallCategoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shop_price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *SaleNumber;

@end
