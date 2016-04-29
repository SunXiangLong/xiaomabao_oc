//
//  MBBaseView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBaseView.h"

@implementation MBBaseView

- (void)awakeFromNib {
    
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"<#MBBaseView#>" owner:nil options:nil] lastObject];
}
@end
