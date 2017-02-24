//
//  MBGoodsPropertyTableViewCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/23.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBGoodsModel.h"
@interface MBGoodsPropertyTableViewCell : UITableViewCell
@property(strong,nonatomic)MBGoodsPropertyModel *model;
@property(assign, nonatomic) BOOL isShowImage;
@end
