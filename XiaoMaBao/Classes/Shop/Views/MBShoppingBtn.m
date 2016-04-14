//
//  MBShoppingBtn.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/5.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBShoppingBtn.h"

@implementation MBShoppingBtn

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
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setClickStatus:(BOOL)clickStatus{
    _clickStatus = clickStatus;
    
    if (clickStatus) {
        [self setTitleColor:[UIColor colorWithHexString:@"e8465e"] forState:UIControlStateNormal];
    }else{
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

@end
