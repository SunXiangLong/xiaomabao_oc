//
//  MBMBSMCategoryOneTabCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class catListsModel,MBSMCategoryModel;
@interface MBSMCategoryOneTabCell : UITableViewCell
@property(strong,nonatomic)MBSMCategoryModel *model;
@end
@interface MBSMCategoryTwoCollCell : UICollectionViewCell
@property(strong,nonatomic)catListsModel *model;
@end

@interface MBSMPersonalCenterCell : UITableViewCell
@property(copy,nonatomic)NSDictionary *dataDic;
@end
