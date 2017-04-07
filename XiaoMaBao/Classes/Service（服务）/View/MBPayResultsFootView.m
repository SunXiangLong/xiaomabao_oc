//
//  MBPayResultsFootView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPayResultsFootView.h"

@implementation MBPayResultsFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBPayResultsFootView" owner:nil options:nil] lastObject];
}

@end
