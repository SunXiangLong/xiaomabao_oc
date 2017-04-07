//
//  MBPostDetailsFooterTwo.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/7/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPostDetailsFooterTwo : UIView
+ (instancetype)instanceView;
@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
