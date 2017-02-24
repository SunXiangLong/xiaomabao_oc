//
//  MBGoodsSpecsView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/23.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBGoodsModel.h"
#import "BkBaseViewController.h"
@interface MBGoodsSpecsView : UIView
@property (nonatomic, weak) BkBaseViewController *VC;
- (instancetype)initWithModel:(MBGoodsSpecsRootModel *)model type:(NSInteger)num;


@property (nonatomic,copy) void(^getCarData)();
@end
