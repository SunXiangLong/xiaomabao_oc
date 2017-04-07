//
//  MBLovelyBabyImageCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBLovelyBabyImageCell.h"

@implementation MBLovelyBabyImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (IBAction)btn:(UIButton *)sender {
    self.btnBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
