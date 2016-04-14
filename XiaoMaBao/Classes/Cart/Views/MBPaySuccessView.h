//
//  MBPaySuccessView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPaySuccessView : UIView
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;

+ (instancetype)instanceView;
@end
