//
//  MBServiceShopsHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBServiceShopsHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *store_name;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *adress_detailed;
@property (weak, nonatomic) IBOutlet UILabel *photo;
@property (weak, nonatomic) IBOutlet UIView *view;

+ (instancetype)instanceView;
@end
