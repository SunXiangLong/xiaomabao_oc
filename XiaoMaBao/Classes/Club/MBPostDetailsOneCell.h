//
//  MBPostDetailsOneCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPostDetailsOneCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *post_title;
@property (weak, nonatomic) IBOutlet UILabel *author_name;
@property (weak, nonatomic) IBOutlet UILabel *reply_cnt;

@property (weak, nonatomic) IBOutlet UILabel *circle_name;
@property (weak, nonatomic) IBOutlet UIImageView *author_userhead;
@property (weak, nonatomic) IBOutlet UILabel *post_content;

@end
