//
//  MBMyCircleView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBMyCircleView : UIView
/**
 *  返回xib的view
 *
 *  @return view
 */
+ (instancetype)instanceView;

@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@end
