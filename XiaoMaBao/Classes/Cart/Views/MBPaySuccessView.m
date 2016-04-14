//
//  MBPaySuccessView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPaySuccessView.h"

@implementation MBPaySuccessView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBPaySuccessView" owner:nil options:nil] lastObject];
}

@end
