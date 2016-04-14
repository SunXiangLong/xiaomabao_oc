//
//  MBMyHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBMyHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *back_image;
@property (weak, nonatomic) IBOutlet UIImageView *user_image;
@property (weak, nonatomic) IBOutlet UILabel *user_guanzhu;
@property (weak, nonatomic) IBOutlet UILabel *user_price;
@property (weak, nonatomic) IBOutlet UILabel *user_tiezi;
+ (instancetype)instanceView;
@end
