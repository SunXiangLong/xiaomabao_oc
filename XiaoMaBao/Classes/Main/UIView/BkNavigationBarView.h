//
//  BkNavigationBarView.h
//  背包客
//
//  Created by mac on 14-9-13.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"
@class BkNavigationBarView;

@protocol BkNavigationBarViewDelegate <NSObject>

@optional
- (void) navigationBarViewPopController : (BkNavigationBarView *) navigationBarView;

@end

@interface BkNavigationBarView : UIView
+ (instancetype ) navigationBarView;
@property (nonatomic,copy) NSString *title;
/**
 *  右标题
 */
@property (nonatomic,copy) NSString *rightStr;

@property (copy,nonatomic) NSString *leftImage;

/**
 *  左标题
 */
@property (nonatomic,copy) NSString *leftStr;

@property (nonatomic, weak) UIButton *leftButton;
@property (nonatomic, weak) UIButton *rightButton;
-(void)setButtonBadge:(CustomBadge *)badge;
@property (nonatomic, weak) UIButton *titleButton;

@property (nonatomic,weak) id <BkNavigationBarViewDelegate> delegate;
/**
 * 是否有返回按钮
 */
@property (nonatomic,assign, getter = isBack) BOOL back;


@property (assign,nonatomic) CGFloat leftButtonW;

@end
