//
//  MBBabyDueDateController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBBabyDueDateController : BkBaseViewController
@property (nonatomic, copy)  NSString *baby_id;
@property (nonatomic,copy)  void (^setUpAfterTheMaternalRefresh)();
@end
