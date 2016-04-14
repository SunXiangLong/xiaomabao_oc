//
//  MBServiceRefundHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceRefundHeadView.h"

@implementation MBServiceRefundHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBServiceRefundHeadView" owner:nil options:nil] lastObject];
}


@end
