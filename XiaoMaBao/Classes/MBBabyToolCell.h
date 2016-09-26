//
//  MBBabyToolCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"
@interface MBBabyToolCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tool_image;
@property (weak, nonatomic) IBOutlet UILabel *tool_center;
@property (weak, nonatomic) IBOutlet UILabel *tool_title;
@property(strong,nonatomic)NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableWidth;
@property (weak, nonatomic) IBOutlet UILabel *toolkit_remind_time;
@end
