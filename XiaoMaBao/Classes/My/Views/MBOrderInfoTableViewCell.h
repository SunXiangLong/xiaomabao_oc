//
//  MBOrderInfoTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBOrderInfoTableViewController.h"
@interface MBOrderInfoTableViewOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *consignee;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property(copy,nonatomic)NSDictionary *dataDic;
@end
@interface MBOrderInfoTableViewTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_sn;
@property (weak, nonatomic) IBOutlet UILabel *add_time_formatted;
@property (weak, nonatomic) IBOutlet UILabel *shipping_fee_formatted;
@property (weak, nonatomic) IBOutlet UILabel *goods_amount_formatted;

@property (weak, nonatomic) IBOutlet UILabel *total_fee_formatted;
@property (weak, nonatomic) IBOutlet UILabel *card_fee_formatted;
@property (weak, nonatomic) IBOutlet UILabel *discount_formatted;
@property (weak, nonatomic) IBOutlet UILabel *coupus_formatted;
@property (weak, nonatomic) IBOutlet UILabel *bonus_formatted;

@property(copy,nonatomic)NSDictionary *dataDic;
@end
@interface MBOrderInfoTableViewThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imag;
@property (weak, nonatomic) IBOutlet UILabel *shop_price;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property(copy,nonatomic)NSDictionary *dataDic;
@end
@interface MBOrderInfoTableViewFourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shipping_name;

@property (weak, nonatomic) IBOutlet UILabel *invoice_no;
@property (nonatomic,assign) MBOrderInfoTableViewController *VC;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property(copy,nonatomic)NSDictionary *dataDic;
@end
