//
//  MBBabyWebController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBBabyWebController : BkBaseViewController
@property (nonatomic,strong) NSURL *url;
@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@property (nonatomic,copy)  void (^toolDataRefresh)(void);
@end
