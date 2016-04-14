//
//  MBServiceHomeCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBServiceHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *neirong;
@property (weak, nonatomic) IBOutlet UILabel *user_city;
@property (weak, nonatomic) IBOutlet UIImageView *user_cityImage;
@property (weak, nonatomic) IBOutlet UIImageView *user_adressImage;

@end
