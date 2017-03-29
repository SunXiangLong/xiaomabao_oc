//
//  MBWelfareCardCollectionViewCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBWelfareCardModel.h"
@interface MBWelfareCardCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) MBWelfareCardModel *model;

@end
@interface MBElectronicCardOneCell : UICollectionViewCell
@property (nonatomic,strong) MBElectronicCardModel *model;

@end
@interface MBElectronicCardTwoCell : UICollectionViewCell
@property (nonatomic,strong) MBElectronicCardModel *model;
@property (nonatomic, copy) void (^delete)( MBElectronicCardModel *);
@end
@interface MBElectronicSubOrderCardCell : UITableViewCell
@property (nonatomic,strong) MBElectronicCardModel *model;
@property (nonatomic, copy) void (^delete)( MBElectronicCardModel *);
@end
