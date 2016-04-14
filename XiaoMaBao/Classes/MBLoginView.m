//
//  MBLoginView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBLoginView.h"

@implementation MBLoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBLoginView" owner:nil options:nil] lastObject];
}

@end
