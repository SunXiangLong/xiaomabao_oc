//
//  MBNewMyViewHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNewMyViewHeadView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIImageView *user_image;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UIButton *login_button;
+ (instancetype)instanceView;
@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@end
