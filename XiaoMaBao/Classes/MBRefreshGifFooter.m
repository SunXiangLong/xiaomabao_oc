//
//  MBRefreshGifFooter.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBRefreshGifFooter.h"

@implementation MBRefreshGifFooter

- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
