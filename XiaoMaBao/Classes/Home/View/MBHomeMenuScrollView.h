//
//  MBHomeMenuScrollView.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/12.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBHomeMenuScrollView;
@protocol MBHomeMenuScrollViewDelegate <NSObject>
/**
 *  点击某个Item抛给首页
 */
- (void)homeMenuScrollView:(MBHomeMenuScrollView *)scrollView didSelectedIndex:(NSInteger)index;
@end

@interface MBHomeMenuScrollView : UIScrollView
- (void)setTitle:(NSString *)title;
@property (weak,nonatomic) id<MBHomeMenuScrollViewDelegate> homeDelegate;
@property (nonatomic,strong) NSMutableArray *buttonArray;

- (void)setSelectedWithIndex:(NSUInteger)index;
@end
