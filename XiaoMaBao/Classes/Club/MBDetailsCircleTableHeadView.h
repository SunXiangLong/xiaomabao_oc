//
//  MBDetailsCircleTableHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBDetailsCircleTableHeadView : UIView
/**
 *  返回xib的view
 *
 *  @return view
 */
+ (instancetype)instanceView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIImageView *circle_logo;
@property (weak, nonatomic) IBOutlet UILabel *circle_name;
@property (weak, nonatomic) IBOutlet UILabel *circle_user_cnt;

@end
