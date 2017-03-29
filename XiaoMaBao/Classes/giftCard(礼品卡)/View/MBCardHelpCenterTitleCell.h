//
//  MBCardHelpCenterTitleCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBElectronicCardOrderModel.h"
@interface MBCardHelpCenterTitleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *ttitleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
@interface MBCardHelpCenterCenterCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollew;
@property (strong, nonatomic) UIImage *image;
@end
@interface MBElectronicCardInfoCell : UITableViewCell

@property (nonatomic,strong) virtualModel *model;

@end

@interface MBElectronicCardOrderCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
