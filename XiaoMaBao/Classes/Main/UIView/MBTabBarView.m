//
//  MBTabBarView.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/12.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBTabBarView.h"

@implementation MBTabBarView

- (void)addSubview:(UIView *)view{
    [super addSubview:view];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat width = self.frame.size.width / count;
    CGFloat height = self.frame.size.height;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *view, NSUInteger idx, BOOL *stop) {
        view.frame = CGRectMake(width * idx, 0, width, height);
    }];
}


@end
