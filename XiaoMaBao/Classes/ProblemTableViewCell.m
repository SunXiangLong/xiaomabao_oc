//
//  ProblemTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/26.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "ProblemTableViewCell.h"

@implementation ProblemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)address:(UIButton *)sender {
    NSNotification *notification =[NSNotification notificationWithName:@"refundAdress" object:nil userInfo:@{@"button":sender}];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

- (IBAction)tijiao:(id)sender {
    
    NSNotification *notification =[NSNotification notificationWithName:@"refundSubmit" object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
