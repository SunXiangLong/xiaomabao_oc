//
//  CanulaCircleHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CanulaCircleHeadView.h"

@implementation CanulaCircleHeadView

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"CanulaCircleHeadView" owner:nil options:nil] lastObject];
}
- (void)awakeFromNib {
//    NSLog(@"%@",@"测试");
}
@end
