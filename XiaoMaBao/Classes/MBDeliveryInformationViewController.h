//
//  MBDeliveryInformationViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/2.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
#import "MBOrderModel.h"
@interface MBDeliveryInformationViewController : BkBaseViewController
@property (nonatomic,strong) id back_tax;
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *order_sn;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,strong) MBOrderModel *orderModel;
@end
