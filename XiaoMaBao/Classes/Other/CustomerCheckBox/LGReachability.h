//
//  LGReachability.h
//  AFN封装实时更新网络状态
//
//  Created by 李堪阶 on 15/11/8.
//  Copyright © 2015年 LG. All rights reserved.
//

//#import <AFNetworking/AFNetworking.h>
#import <AFNetworking.h>

//成功回调
typedef void (^successFBlock)(NSString *status);



@interface LGReachability : AFNetworkReachabilityManager

/**
 *  网络状态
 */
+ (void)LGwithSuccessBlock:(successFBlock)success;
@end
