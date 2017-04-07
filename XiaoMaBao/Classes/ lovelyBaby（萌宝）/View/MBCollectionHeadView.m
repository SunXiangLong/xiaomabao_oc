//
//  MBCollectionHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCollectionHeadView.h"

@implementation MBCollectionHeadView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.height.constant = 0.5;
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBCollectionHeadView" owner:nil options:nil] lastObject];
}
@end
