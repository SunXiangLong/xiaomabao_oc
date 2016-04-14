//
//  MBCartItemButton.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/5.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBCartItemButton.h"

@implementation MBCartItemButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.layer.cornerRadius = 2.0;
    self.layer.borderWidth = PX_ONE;
    self.layer.borderColor = [UIColor colorWithHexString:@"323333"].CGColor;
    
    [self setTitleColor:[UIColor colorWithHexString:@"323333"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setClickStatus:(BOOL)clickStatus{
    _clickStatus = clickStatus;
    
    if (clickStatus) {
        self.layer.borderWidth = 0;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    }else{
        self.layer.borderWidth = PX_ONE;
        [self setTitleColor:[UIColor colorWithHexString:@"323333"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
