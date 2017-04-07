//
//  MBStyleCollectionViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBStyleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLable;
@property (weak, nonatomic) IBOutlet UILabel *org_price;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *market_price;

@end
