//
//  MBMBSMCategoryOneVC.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBSMCategoryDataModel,catListsModel;
@interface MBSMCategoryOneVC : UIViewController
@property(nonatomic,strong) MBSMCategoryDataModel *model;
@property (nonatomic,copy)  void (^selectRow)(NSArray<catListsModel *> *cat_lists);
@end
