//
//  MBServiceShopsTableHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceShopsTableHeadView.h"

@implementation MBServiceShopsTableHeadView

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBServiceShopsTableHeadView" owner:nil options:nil] lastObject];
}

@end
