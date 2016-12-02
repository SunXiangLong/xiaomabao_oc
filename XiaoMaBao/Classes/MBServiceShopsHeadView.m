//
//  MBServiceShopsHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceShopsHeadView.h"

@implementation MBServiceShopsHeadView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBServiceShopsHeadView" owner:nil options:nil] lastObject];
}




@end
