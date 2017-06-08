//
//  MBBabyManagementViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
@class Result;
typedef void(^Block)(Result *model);
@interface MBBabyManagementViewController : BkBaseViewController
@property (nonatomic, copy) Block block;
@property (strong,nonatomic)Result *model;
@end
