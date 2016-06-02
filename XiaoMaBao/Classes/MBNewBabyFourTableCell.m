//
//  MBNewBabyFourTableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyFourTableCell.h"

@implementation MBNewBabyFourTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)dianji:(UITapGestureRecognizer *)sender {
    
    NSLog(@"%ld",sender.view.tag);
}


@end
