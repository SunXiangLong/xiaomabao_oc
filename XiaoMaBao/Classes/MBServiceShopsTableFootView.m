//
//  MBServiceShopsTableFootView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceShopsTableFootView.h"

@implementation MBServiceShopsTableFootView

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBServiceShopsTableFootView" owner:nil options:nil] lastObject];
}

@end
