//
//  canulaCircleDetailsTableheaderView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/4.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface canulaCircleDetailsTableheaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *monthLable;


@property (weak, nonatomic) IBOutlet UILabel *centerLable;
+ (instancetype)instanceView;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;


@end
