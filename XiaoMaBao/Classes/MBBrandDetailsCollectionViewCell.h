//
//  MBBrandDetailsCollectionViewCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBBrandDetailsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goods_thumb;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
