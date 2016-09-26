//
//  MBabyRecordThreeCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBabyRecordThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image0;
@property (weak, nonatomic) IBOutlet UILabel *weekAddtime;
@property (weak, nonatomic) IBOutlet UILabel *year_month;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
