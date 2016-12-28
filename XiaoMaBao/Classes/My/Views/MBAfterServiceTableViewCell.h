//
//  MBAfterServiceTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBOrderModel.h"
@interface MBAfterServiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImageview;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@property (weak, nonatomic) IBOutlet UILabel *priceAndNumber;
@property (nonatomic,strong) MBGoodListModel *model;


@end
