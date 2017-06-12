//
//  MBpreparePregnantSetViewController.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/5.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBpreparePregnantSetViewController : BkBaseViewController
/***  宝宝id*/
@property (nonatomic, copy)  NSString *baby_id;
@property (nonatomic,copy)  void (^afterTheDateSetForPregnantRefreshAgain)(void);
@end
