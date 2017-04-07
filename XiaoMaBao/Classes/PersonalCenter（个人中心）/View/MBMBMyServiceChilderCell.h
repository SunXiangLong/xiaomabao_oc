//
//  MBMBMyServiceChilderCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
#import "MBSerViceOrderModel.h"
@interface MBMBMyServiceChilderCell : UITableViewCell
@property (nonatomic,weak) BkBaseViewController *vc;
@property (nonatomic,strong) MBSerViceOrderModel *model;

@end
