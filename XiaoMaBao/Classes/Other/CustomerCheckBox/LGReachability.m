//
//  LGReachability.m
//  AFN封装实时更新网络状态
//
//  Created by 李堪阶 on 15/11/8.
//  Copyright © 2015年 LG. All rights reserved.
//


#import "LGReachability.h"

@implementation LGReachability

+ (void)LGwithSuccessBlock:(successFBlock)success
{
    [[self sharedManager]startMonitoring];
    
    [[self sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == 0) {
            success(@"无连接");
        }else if (status == 1){
            success(@"3G/4G网络");
        }else if (status == 2){
            success(@"wifi状态下");
        }
    }];
}

@end
