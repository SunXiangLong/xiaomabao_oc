//
//  MBSMCcategoryHomeVC.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBSMCategoryHomeVC : BkBaseViewController
@property (nonatomic,assign) BOOL isReturn;
@property (nonatomic,copy)  void (^backCatID)(NSString *caatID);
@end
