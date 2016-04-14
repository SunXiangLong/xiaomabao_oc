//
//  headView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "headView.h"

@implementation headView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"headView" owner:nil options:nil] lastObject];
}
@end
