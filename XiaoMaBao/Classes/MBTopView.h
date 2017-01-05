//
//  MBTopView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/5.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBServiceSearchCell.h"
#import "MBServiceModel.h"
@interface MBTopView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIView *serviceViewNull;
@property (nonatomic,copy)NSMutableArray <ServiceProductsModel *> *productModelArray;
@property (copy, nonnull) void (^block)(id value);
+ (instancetype)instanceView;
@end