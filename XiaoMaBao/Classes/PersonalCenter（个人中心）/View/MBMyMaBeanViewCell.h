//
//  MBMyMaBeanViewCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBBeanInfoModel.h"
@interface MBMyMaBeanViewCell : UITableViewCell
@property (nonatomic,strong) MBRecordsModel *model;
@property (weak, nonatomic) IBOutlet UILabel *record_desc;
@property (weak, nonatomic) IBOutlet UILabel *record_time;
@property (weak, nonatomic) IBOutlet UILabel *record_val;

@end
