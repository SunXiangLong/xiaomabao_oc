//
//  MBServiceOrderThreeCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBServiceOrderThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *store_name;
@property (weak, nonatomic) IBOutlet UILabel *store_adress;
@property (weak, nonatomic) IBOutlet UILabel *store_phone;


@property (weak, nonatomic) IBOutlet UILabel *order_number;
@property (weak, nonatomic) IBOutlet UILabel *order_phone;
@property (weak, nonatomic) IBOutlet UILabel *oredr_time;
@property (weak, nonatomic) IBOutlet UILabel *order_num;
@property (weak, nonatomic) IBOutlet UILabel *order_price;
@end
