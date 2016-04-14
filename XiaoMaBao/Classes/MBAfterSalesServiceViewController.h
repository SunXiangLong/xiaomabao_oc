//
//  MBAfterSalesServiceViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/25.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBAfterSalesServiceViewController : BkBaseViewController
//@property(nonatomic,strong) NSDictionary *orderInformationDic;
@property(nonatomic,assign) NSInteger section;
@property (nonatomic,strong) NSString *order_id;//订单编号
@property (nonatomic,strong) NSString *order_sn;
@property (nonatomic,strong) NSString *type;//0重新申请 否则就是申请
@end
