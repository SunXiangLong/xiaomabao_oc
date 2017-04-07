//
//  MBFireOrderViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"
#import "MBConfirmModel.h"
@interface MBFireOrderViewController : BkBaseViewController
@property(strong,nonatomic)MBConfirmModel * orderShopModel;
@property(copy,nonatomic) void(^isRefresh)();
@end
