//
//  MBNewsCircleCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNewsCircleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_head;

@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *notify_time;
@property (weak, nonatomic) IBOutlet UILabel *notify_base_content;
@property (weak, nonatomic) IBOutlet UILabel *notify_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@end
