//
//  MBArticleViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBArticleViewCell : UITableViewCell
@property(copy,nonatomic)NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UILabel *post_text;
@property (weak, nonatomic) IBOutlet UILabel *user_text;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UILabel *click_cnt;
@property (weak, nonatomic) IBOutlet UIImageView *user_image;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@end
