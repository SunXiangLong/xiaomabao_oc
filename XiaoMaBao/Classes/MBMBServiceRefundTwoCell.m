//
//  MBMBServiceRefundTwoCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMBServiceRefundTwoCell.h"

@implementation MBMBServiceRefundTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)is_select:(UIButton *)sender {

    NSString *selected = @"";
    if (sender.selected) {
        selected = @"0";
    }else{
       selected = @"1";
    
    }
    NSNotification *notification =[NSNotification notificationWithName:@"is_selected" object:nil userInfo:@{@"indexPath":self.indexPath,@"selected":selected}];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
     
    
    
}

@end
