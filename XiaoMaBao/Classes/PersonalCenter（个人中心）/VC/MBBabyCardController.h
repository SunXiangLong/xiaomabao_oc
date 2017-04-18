//
//  MBBabyCardController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBBabyCardController : BkBaseViewController
@property (nonatomic, strong) RACSubject *myCircleViewSubject;
/**是否只是查看麻包卡*/
@property (nonatomic,assign) BOOL isJustLookAt;

@end
