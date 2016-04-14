//
//  KSNoNetView.h
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

/**
 *  这个View是无网络状态下的视图,可以实现自定义
 *
 *  
 */

#import <UIKit/UIKit.h>

@protocol KSNoNetViewDelegate  <NSObject>

- (void)reloadNetworkDataSource:(id)sender;

@end

@interface KSNoNetView : UIView

/**
 *  由代理控制器去执行刷新网络
 */
@property (nonatomic, strong) id<KSNoNetViewDelegate>delegate;

/**
 *  初始化方法,可以自定义,
 *
 *  @return KSNotNetView
 */
+ (instancetype) instanceNoNetView;

/**
 *  刷新网络的方法，当自定义视图的时候，刷新网络方法必须指向此方法
 *
 *  @param sender
 */
- (IBAction)reloadNetworkDataSource:(id)sender;

@end
