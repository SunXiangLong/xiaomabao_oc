//
//  MBMBMyServiceChilderCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"

@interface MBMBMyServiceChilderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *store_image;
@property (weak, nonatomic) IBOutlet UILabel *store_name;
@property (weak, nonatomic) IBOutlet UILabel *store_state;
@property (weak, nonatomic) IBOutlet UIImageView *service_image;
@property (weak, nonatomic) IBOutlet UILabel *service_num;
@property (weak, nonatomic) IBOutlet UILabel *service_price;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic,strong) BkBaseViewController *vc;
@property(strong,nonatomic)NSDictionary *dataDic;
@end
