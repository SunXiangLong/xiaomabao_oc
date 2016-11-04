//
//  MBVoiceViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBVoiceViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *post_title;
@property (weak, nonatomic) IBOutlet UILabel *post_center;
@property (weak, nonatomic) IBOutlet UIImageView *post_image1;
@property (weak, nonatomic) IBOutlet UIImageView *post_image2;
@property (weak, nonatomic) IBOutlet UIImageView *post_image3;
@property (weak, nonatomic) IBOutlet UILabel *user_title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *user_title_top;


@property (weak, nonatomic) IBOutlet UILabel *atype;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
