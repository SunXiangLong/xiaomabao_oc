//
//  MBServiceOrderFootView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface MBServiceOrderFootView : UIView
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,weak) BkBaseViewController *vc;
@property(strong,nonatomic)NSDictionary *dataDic;

+ (instancetype)instanceView;
@end
