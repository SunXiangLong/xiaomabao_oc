//
//  MBServiceHomeCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBServiceHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shop_logo;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *shop_city;
@property (weak, nonatomic) IBOutlet UILabel *shop_address;
@property (weak, nonatomic) IBOutlet UILabel *shop_desc;

@property(copy,nonatomic)NSDictionary *dataDic;
@end
