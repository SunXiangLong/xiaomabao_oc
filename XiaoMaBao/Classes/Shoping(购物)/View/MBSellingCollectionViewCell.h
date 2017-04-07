//
//  MBSellingCollectionViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSellingCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nationalImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *org_price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *salesnum;
- (void)loadData:(id)data indexPath:(NSIndexPath*)indexPath;

@end
