//
//  MBHomeMenuButton.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/17.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBHomeMenuButton.h"

@interface MBHomeMenuButton ()

@end

@implementation MBHomeMenuButton

- (UIView *)lineView{
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] init];
        
           lineView.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
      
     
        
        lineView.hidden = YES;
        [self addSubview:lineView];
        self.lineView = lineView;
    }
    return _lineView;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - 2, self.ml_width, 2);
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setCurrentSelectedStatus:(BOOL)currentSelectedStatus{
        _currentSelectedStatus = currentSelectedStatus;
        self.lineView.hidden = !currentSelectedStatus;
        if (currentSelectedStatus) {
            
            [self setTitleColor:[UIColor colorWithHexString:@"e8465e"] forState:UIControlStateNormal];
        }else{
            
            [self setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        }
        

    
}

@end
