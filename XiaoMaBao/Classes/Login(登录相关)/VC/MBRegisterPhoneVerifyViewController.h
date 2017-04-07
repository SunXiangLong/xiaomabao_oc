//
//  MBRegisterPhoneVerifyViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBRegisterPhoneVerifyViewController : BkBaseViewController
@property (nonatomic,assign) BOOL isRegistered;
@property (nonatomic, copy) NSString *phoneNumb;
@property (nonatomic, copy) NSString *phoneVerifyCode;

@end
