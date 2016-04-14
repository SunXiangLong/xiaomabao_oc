//
//  NSTimer+Addition.h
//  YXLScrollView
//
//  Created by Yexinglong on 14/10/9.
//  Copyright (c) 2014年 Yexinglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)
//关闭定时器
- (void)pauseTimer;
//启动定时器
- (void)resumeTimer;
//添加一个定时器
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com