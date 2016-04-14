//
//  ApplyTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/26.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "ApplyTableViewCell.h"

@implementation ApplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)refund:(UIButton *)sender {
    NSNotification *notification =[NSNotification notificationWithName:@"refund" object:nil userInfo:@{@"button":sender}];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

- (IBAction)huan:(UIButton *)sender {
    NSNotification *notification =[NSNotification notificationWithName:@"huan" object:nil userInfo:@{@"button":sender}];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

@end
