//
//  BkBaseViewController.h
//  背包客
//
//  Created by mac on 14-9-10.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"
#import "BkNavigationBarView.h"
@interface BkBaseViewController : UIViewController
@property (nonatomic,weak) BkNavigationBarView *navBar;
/**
 *  标题
 */
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) CustomBadge *badge;
@property (nonatomic,strong) CustomBadge *messageBadge;
/**
 * 是否有返回按钮
 */
@property (nonatomic,assign, getter = isBack) BOOL back;

/**
 *  右标题
 */
@property (nonatomic,copy) NSString *rightStr;
@property (nonatomic, strong) NSArray *menuIds;

/**
 *  左标题
 */
@property (nonatomic,copy) NSString *leftStr;

/**
 *  左图片
 */
@property (nonatomic,copy) NSString *leftImage;
/**
 *  当前页面没数据的时候提示信息
 */
@property (nonatomic,strong) NSString *stateStr;

/**
 *  左边/右边 按钮点击
 */



- (void) leftTitleClick;
- (void) rightTitleClick;

/**
 *  右边图片，标题图片
 */
- (NSString *) rightImage;
- (NSString *) titleImage;

- (void)setNavBarViewBackgroundColor:(UIColor *)color;
/**
 *  移除控制器
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (void)pushViewController:(UIViewController *) viewController Animated:(BOOL)animated;

- (UIView *)addBottomLineView:(UIView *)addLineView;
- (UIView *)addTopLineView:(UIView *)addLineView;

- (CGFloat)leftButtonW;

// 是否登录
- (BOOL)isLogin;
//是否显示搜索框
- (BOOL)isSearch;
@end
