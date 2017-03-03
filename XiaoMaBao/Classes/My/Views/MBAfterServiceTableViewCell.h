//
//  MBAfterServiceTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBOrderModel.h"
#import "MBRefundModel.h"
@interface MBAfterServiceTableViewCell : UITableViewCell

@property (nonatomic,strong) MBGoodListModel *model;
@property (nonatomic,strong) MBRefundGoodsModel *refundGoodsModel;

@end
