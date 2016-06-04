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
@property (weak, nonatomic) IBOutlet SevenSwitch *tool_switch;


@property (weak, nonatomic) IBOutlet UILabel *tool_title;
@end