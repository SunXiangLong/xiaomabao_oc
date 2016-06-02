//
//  MBNewBabyHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyHeadView.h"

@implementation MBNewBabyHeadView
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBNewBabyHeadView" owner:nil options:nil] lastObject];
}
@end
