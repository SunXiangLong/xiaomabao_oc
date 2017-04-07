//
//  MBMoreCirclesController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBMoreCirclesController : BkBaseViewController
@property (nonatomic ,strong) UIView *MinView;
@property (copy ,nonatomic) void (^block)(NSInteger num);

@end
