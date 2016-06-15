//
//  MBNewBabyHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNewBabyHeadView : UIView
@property (nonatomic, strong) RACSubject *myCircleViewSubject;
+ (instancetype)instanceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_height;
@property (weak, nonatomic) IBOutlet UIImageView *baby_image;
@property (weak, nonatomic) IBOutlet UILabel *baby_weight;
@property (weak, nonatomic) IBOutlet UILabel *baby_length;
@property (weak, nonatomic) IBOutlet UILabel *baby_date;
@property (weak, nonatomic) IBOutlet UILabel *babyWeight;
@property (weak, nonatomic) IBOutlet UILabel *babylenth;
@property (weak, nonatomic) IBOutlet UILabel *babyDate;
@property (weak, nonatomic) IBOutlet UILabel *baby_content;
@property (weak, nonatomic) IBOutlet UIView *cenView;

@end
