//
//  ObjCModel.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "ObjCModel.h"

@implementation ObjCModel
- (void)showLogin{
 NSLog(@"Js调用了OC的方法，参数为：%@", @"000");

}

// 通过JSON传过来
- (void)showGood:(NSString *)params{
 NSLog(@"Js调用了OC的方法，参数为：%@", params);
}
- (void)showTopic:(NSString *)params{
 NSLog(@"Js调用了OC的方法，参数为：%@", params);
}
- (void)showGroup:(NSString *)params{
    NSLog(@"Js调用了OC的方法，参数为：%@", params);

}

@end
