//
//  MBTopView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/11.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBServiceModel.h"
#import "MBServiceSearchCell.h"
@interface MBTopView : UIView
@property (weak, nonatomic) IBOutlet UITableView * _Nullable tableView;
@property (weak, nonatomic) IBOutlet UIView * _Nullable sortView;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable defaultBtn;
@property (weak, nonatomic) IBOutlet UIView * _Nullable serviceViewNull;
@property (nonatomic,copy)NSMutableArray <ServiceProductsModel *> * _Nullable productModelArray;
@property (copy, nonnull) void (^block)(id _Nullable value);
+ (instancetype _Nullable )instanceView;
@end
