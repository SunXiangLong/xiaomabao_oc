//
//  MBPayResultsHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPayResultsHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *shop_image;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
+ (instancetype)instanceView;
@end
