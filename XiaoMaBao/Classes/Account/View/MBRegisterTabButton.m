//
//  MBRegisterTabButton.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/4/30.
//  Copyright (c) 2015年 com.xiaomabao.www. All rights reserved.
//

#import "MBRegisterTabButton.h"
#import <PureLayout.h>

@interface MBRegisterTabButton ()
@property (weak,nonatomic) UIView *selectedStatusLineView;
@end

@implementation MBRegisterTabButton

- (UIView *)selectedStatusLineView{
    if (!_selectedStatusLineView) {
        UIView *selectedStatusLineView = [[UIView alloc] init];
        selectedStatusLineView.backgroundColor = [UIColor colorWithHexString:@"24aa98"];
        selectedStatusLineView.hidden = YES;
        [self addSubview:_selectedStatusLineView = selectedStatusLineView ];
    }
    return _selectedStatusLineView;
}

- (id)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
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

- (void)setSelectedStatus:(BOOL)selectedStatus{
    _selectedStatus = selectedStatus;
    
    if (selectedStatus) {
        [self.selectedStatusLineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self];
        [self.selectedStatusLineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.selectedStatusLineView autoSetDimension:ALDimensionHeight toSize:2];
        [self.selectedStatusLineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.selectedStatusLineView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    }
    
    self.selectedStatusLineView.hidden = !(selectedStatus);
}

- (void)setup{
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self setTitleColor:[UIColor colorWithHexString:@"24aa98"] forState:UIControlStateNormal];
}
@end
