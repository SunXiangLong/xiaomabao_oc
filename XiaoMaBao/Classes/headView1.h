//
//  headView1.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headView1 : UIView
+ (instancetype)instanceView;

@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property (weak, nonatomic) IBOutlet UILabel *namelable;
@property (weak, nonatomic) IBOutlet UILabel *shuoming;

@end
