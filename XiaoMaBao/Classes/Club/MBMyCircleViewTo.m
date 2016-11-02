//
//  MBMyCircleViewTo.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyCircleViewTo.h"

@implementation MBMyCircleViewTo


+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBMyCircleViewTo" owner:nil options:nil] lastObject];
}

@end
