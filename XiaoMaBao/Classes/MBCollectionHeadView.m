//
//  MBCollectionHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCollectionHeadView.h"

@implementation MBCollectionHeadView

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBCollectionHeadView" owner:nil options:nil] lastObject];
}
@end
