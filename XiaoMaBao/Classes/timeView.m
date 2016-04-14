//
//  timeView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "timeView.h"

@implementation timeView

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"timeView" owner:nil options:nil] lastObject];
}

@end
