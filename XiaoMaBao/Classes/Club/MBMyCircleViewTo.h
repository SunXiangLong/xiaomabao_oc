//
//  MBMyCircleViewTo.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBMyCircleViewTo : UIView
/**
 *  返回xib的view
 *
 *  @return view
 */
+ (instancetype)instanceView;

@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@end
