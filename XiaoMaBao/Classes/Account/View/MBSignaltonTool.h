//
//  MBSignaltonTool.h
//  XiaoMaBao
//
//  Created by 余朋飞 on 15/7/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBUserDataSingalTon.h"
@interface MBSignaltonTool : NSObject
//获取当前的用户信息
+(MBUserDataSingalTon *)getCurrentUserInfo;
@end
