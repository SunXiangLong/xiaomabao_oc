//
//  MBMyCircleController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBMyCircleController : BkBaseViewController

@property (copy ,nonatomic) void (^block)(NSInteger num);
/**
 *  是否从下一个界面返回
 */
@property (nonatomic, assign) BOOL isDimiss;
@end
