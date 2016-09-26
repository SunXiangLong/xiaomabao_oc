//
//  MBabyRecordHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBabyRecordHeadView.h"

@implementation MBabyRecordHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBabyRecordHeadView" owner:nil options:nil] lastObject];
}

@end
