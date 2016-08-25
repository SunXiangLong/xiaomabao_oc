//
//  MBVideoView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBVideoView.h"

@implementation MBVideoView
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBVideoView" owner:nil options:nil] lastObject];
}

@end
