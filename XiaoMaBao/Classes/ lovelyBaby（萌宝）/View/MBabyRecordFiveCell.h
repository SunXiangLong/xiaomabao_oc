//
//  MBabyRecordFiveCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBabyRecordFiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *weekAddtime;
@property (weak, nonatomic) IBOutlet UILabel *year_month;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
