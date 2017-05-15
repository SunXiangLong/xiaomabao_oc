//
//  MBShopAddresViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
#import "MBConfirmModel.h"
@interface MBShopAddresViewController : BkBaseViewController
@property (nonatomic,assign) BOOL isPersonalCenter;
@property (nonatomic,copy)  void (^changeAddress)(MBConsigneeModel *model);
@end
