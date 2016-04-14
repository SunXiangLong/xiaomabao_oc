//
//  MBMaBaoVolumeHeaderView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMaBaoVolumeHeaderView.h"

@implementation MBMaBaoVolumeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBMaBaoVolumeHeaderView" owner:nil options:nil] lastObject];
}
- (IBAction)touxiang:(id)sender {
}

@end
