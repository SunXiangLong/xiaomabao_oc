//
//  MBServiceHomeHeadView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBServiceModel.h"
@interface MBServiceHomeHeadView : UIView
@property(strong,nonatomic) ServiceShopModel *model;
+ (instancetype)instanceView;
@end
