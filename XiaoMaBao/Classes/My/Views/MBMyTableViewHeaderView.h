//
//  MBMyTableViewHeaderView.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBMyTableViewHeaderView : UIView
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *score;
@property (strong, nonatomic) UILabel *myPosts;
@property (strong, nonatomic) UILabel *follow;
@property (strong, nonatomic) UILabel *fans;
+ (instancetype)instanceView;
@end
