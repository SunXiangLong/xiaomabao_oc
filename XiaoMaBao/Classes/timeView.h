//
//  timeView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeView : UIView
+ (instancetype)instanceView;
@property (weak, nonatomic) IBOutlet UILabel *second;

@property (weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (weak, nonatomic) IBOutlet UILabel *day;

@end
