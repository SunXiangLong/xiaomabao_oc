//
//  BkTabBarView.h
//  背包客
//
//  Created by mac on 14-9-13.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BkTabBarView;
@protocol BkTabBarViewDelegate <NSObject>

@optional
- (void)tabBar:(BkTabBarView *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to;
- (void)tabBarDidClickPlusButton:(BkTabBarView *)tabBar;

@end

@interface BkTabBarView : UIView
/**
 *  添加一个选项卡按钮
 *
 *  @param item 选项卡按钮对应的模型数据(标题\图标\选中的图标)
 */
- (void)addTabBarButton:(UITabBarItem *)item;

@property (nonatomic, weak)id <BkTabBarViewDelegate> delegate;

@end
