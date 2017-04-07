//
//  MBVoucherTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/12.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBVoucherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *use_valide_date;
@property (strong, nonatomic) IBOutlet UILabel *coupon_name;
@property (weak, nonatomic) IBOutlet UILabel *useRange;

@end
