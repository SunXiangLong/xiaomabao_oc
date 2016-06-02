//
//  MBBabyToolCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyToolCell.h"

@implementation MBBabyToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    [_tool_switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    _tool_switch.offImage = [UIImage imageNamed:@"tool_cross"];
    _tool_switch.onImage = [UIImage imageNamed:@"tool_check"];
    _tool_switch.onTintColor = UIcolor(@"c84d51");
    _tool_switch.inactiveColor = UIcolor(@"605b6a");
    _tool_switch.isRounded = NO;
    [_tool_switch setOn:NO animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)switchChanged:(SevenSwitch *)sender {
    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
}
@end
