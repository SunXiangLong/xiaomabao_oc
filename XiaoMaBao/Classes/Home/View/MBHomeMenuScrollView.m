//
//  MBHomeMenuScrollView.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/12.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBHomeMenuScrollView.h"
#import "MBHomeMenuButton.h"

@interface MBHomeMenuScrollView ()
@property (strong,nonatomic) NSMutableArray *buttons;
@end

@implementation MBHomeMenuScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.buttons = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithHexString:@"ffedd2"];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.buttonArray = [NSMutableArray array];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    
    MBHomeMenuButton *btn = [MBHomeMenuButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = self.buttons.count;
    [btn addTarget:self action:@selector(tapMenuItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self.buttons addObject:btn];
    [self.buttonArray addObject:btn];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    [self addSubview:lineView];
    
    CGFloat width = self.ml_width / 6;
    CGFloat height = 28;
    self.contentSize = CGSizeMake(width * self.buttons.count + 30, 0);
    
    [self.buttons enumerateObjectsUsingBlock:^(MBHomeMenuButton *obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            obj.currentSelectedStatus = YES;
        }
        obj.frame = CGRectMake(idx * width, 0, width, height);
        lineView.frame = CGRectMake(CGRectGetMaxX(obj.frame), 0, PX_ONE, obj.ml_height);
    }];
    
    
}

- (void)setSelectedWithIndex:(NSUInteger)index{
    if (index >= self.buttons.count) {
        return;
    }
    [self.buttons enumerateObjectsUsingBlock:^(MBHomeMenuButton *obj, NSUInteger idx, BOOL *stop) {
        if (idx == index) {
            obj.currentSelectedStatus = YES;
        }else{
            obj.currentSelectedStatus = NO;
        }
    }];
    
}

#pragma mark - <MBHomeMenuScrollViewDelegate>
- (void)tapMenuItem:(UIButton *)btn{
    if ([self.homeDelegate respondsToSelector:@selector(homeMenuScrollView:didSelectedIndex:)]) {
        
        [self.buttons enumerateObjectsUsingBlock:^(MBHomeMenuButton *obj, NSUInteger idx, BOOL *stop) {
            if (idx == btn.tag) {
                obj.currentSelectedStatus = YES;
            }else{
                obj.currentSelectedStatus = NO;
            }
        }];
        
        [self.homeDelegate homeMenuScrollView:self didSelectedIndex:btn.tag];
    }
}

@end
