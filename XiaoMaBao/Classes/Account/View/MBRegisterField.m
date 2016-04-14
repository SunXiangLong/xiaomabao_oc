//
//  MBRegisterField.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBRegisterField.h"

@implementation MBRegisterField

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    self.font = [UIFont systemFontOfSize:12];
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 2;
    
    self.clearButtonMode = UITextFieldViewModeAlways;
    
}

@end
