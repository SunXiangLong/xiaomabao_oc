//
//  MBSignaltonTool.m
//  XiaoMaBao
//
//  Created by 余朋飞 on 15/7/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSignaltonTool.h"

@implementation MBSignaltonTool
+(MBUserDataSingalTon *)getCurrentUserInfo{

    return [self getCurrentUserInfo:nil];
}
//当前登录用户的信息 为单例模式
+(MBUserDataSingalTon * )getCurrentUserInfo:(NSDictionary *)dic
{
    static dispatch_once_t pred;
    static MBUserDataSingalTon *currentUser;
    if (dic) {
        dispatch_once(&pred, ^{
            currentUser = [MBUserDataSingalTon yy_modelWithDictionary:dic];
        
        });
    }
    
    return currentUser;
}
@end
