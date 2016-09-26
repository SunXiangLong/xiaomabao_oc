//
//  MBNewBabyThreeTableCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNewBabyThreeTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *post_content;
@property (weak, nonatomic) IBOutlet UILabel *view_cnt;
@property (weak, nonatomic) IBOutlet UILabel *reply_cnt;
@property (weak, nonatomic) IBOutlet UILabel *post_title;
@property(strong,nonatomic)NSDictionary *dataDic;
@end
