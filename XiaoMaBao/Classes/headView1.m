//
//  headView1.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "headView1.h"

@implementation headView1

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"headView1" owner:nil options:nil] lastObject];
}

@end
