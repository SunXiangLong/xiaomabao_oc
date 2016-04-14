//
//  ZLDateView.h
//  日历
//
//  Created by 张磊 on 14-11-2.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLDateView;

@protocol ZLDateViewDelegate <NSObject>
// 点击了那天的日期
- (void) dateViewDidClickDateView: (ZLDateView *) dateView atIndexDay : (NSInteger ) day;

@end

@interface ZLDateView : UIView

@property (nonatomic , weak) IBOutlet id <ZLDateViewDelegate> delegate;
@property (strong,nonatomic) NSArray *datys;


@end
