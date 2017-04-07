//
//  MBUserEvaluationListTableHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBUserEvaluationListTableHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UIImageView *showIageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

+ (instancetype)instanceView;
@end
