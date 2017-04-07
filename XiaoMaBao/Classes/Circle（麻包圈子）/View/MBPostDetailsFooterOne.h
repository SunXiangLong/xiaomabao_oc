//
//  MBPostDetailsFooterOne.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/7/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPostDetailsFooterOne : UIView
+ (instancetype)instanceView;


@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *user_cnt;
@end
