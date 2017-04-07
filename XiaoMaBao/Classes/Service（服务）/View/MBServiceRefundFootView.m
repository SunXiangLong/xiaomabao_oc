//
//  MBServiceRefundFootView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceRefundFootView.h"

@implementation MBServiceRefundFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBServiceRefundFootView" owner:nil options:nil] lastObject];
}



@end
