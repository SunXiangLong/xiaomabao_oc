//
//  MBMessageTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *usertime;
@property (weak, nonatomic) IBOutlet UILabel *userCenter;

@end
