//
//  MBRegisterFieldRightViewButton.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBRegisterFieldRightViewButton.h"

@implementation MBRegisterFieldRightViewButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.userInteractionEnabled = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    [self setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
}
@end
