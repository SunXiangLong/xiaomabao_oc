//
//  MBCommentTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/4.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *userCenter;

@end
