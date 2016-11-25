//
//  MBInvoiceViewController.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBInvoiceViewController : BkBaseViewController
@property (nonatomic,copy) void(^block)(NSString *inv_payee,NSString *inv_type,NSString *inv_content);
@end
