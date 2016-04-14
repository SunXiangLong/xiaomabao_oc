//
//  MBServiceRefundFootView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBServiceRefundFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
+ (instancetype)instanceView;


@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end
