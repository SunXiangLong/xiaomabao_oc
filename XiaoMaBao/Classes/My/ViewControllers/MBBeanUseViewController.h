//
//  MBBeanUseViewController.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBBeanUseViewController : BkBaseViewController
@property (nonatomic,copy) void(^block)(NSString *);
@property (nonatomic,strong) NSString *number;

@end
