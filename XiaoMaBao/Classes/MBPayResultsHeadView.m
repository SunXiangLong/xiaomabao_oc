//
//  MBPayResultsHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPayResultsHeadView.h"

@implementation MBPayResultsHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBPayResultsHeadView" owner:nil options:nil] lastObject];
}
@end
