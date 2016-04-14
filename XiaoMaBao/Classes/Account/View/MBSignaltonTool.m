//
//  MBSignaltonTool.m
//  XiaoMaBao
//
//  Created by 余朋飞 on 15/7/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSignaltonTool.h"

@implementation MBSignaltonTool
//当前登录用户的信息 为单例模式
+(MBUserDataSingalTon * )getCurrentUserInfo
{
    static dispatch_once_t pred;
    static MBUserDataSingalTon *currentUser;
    dispatch_once(&pred, ^{
        currentUser = [[MBUserDataSingalTon alloc] init];
    });
    return currentUser;
}
@end
