//
//  MBUserEvaluationListCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface MBUserEvaluationListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *user_time;
@property (weak, nonatomic) IBOutlet UILabel *user_center;
@property (nonatomic,strong) NSArray *comment_imgs;
@property (nonatomic,strong) NSArray *comment_thumb_imgs;
@property (nonatomic,strong) NSString *shop_id;
@property (nonatomic,weak) BkBaseViewController*VC;


@end
