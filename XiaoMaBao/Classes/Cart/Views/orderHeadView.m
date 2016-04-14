//
//  orderHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "orderHeadView.h"

@implementation orderHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"orderHeadView" owner:nil options:nil] lastObject];
}
@end
