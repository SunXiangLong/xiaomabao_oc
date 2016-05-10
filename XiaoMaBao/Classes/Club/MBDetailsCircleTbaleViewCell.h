//
//  MBDetailsCircleTbaleViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBDetailsCircleTbaleViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *post_title;
@property (weak, nonatomic) IBOutlet UILabel *post_time;
@property (weak, nonatomic) IBOutlet UILabel *reply_cnt;

@property (weak, nonatomic) IBOutlet UILabel *author_name;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *array;
@end
