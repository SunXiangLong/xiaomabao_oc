//
//  MBNavigationViewController.h
//  xiaomabao
//
//  Created by 张磊 on 15/4/28.
//  Copyright (c) 2015年 com.xiaomabao.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNavigationViewController : UINavigationController
/**
 *  滑动手势，覆盖系统边缘右滑返回上一界面，实现整个界面右滑返回
 */
@property (nonatomic,strong)  UIPanGestureRecognizer *pan;

@end
