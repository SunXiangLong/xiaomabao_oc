//
//  MBMyServiceChilderViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
typedef enum {
   
    Topayment = 0,
    Toused,
    Toevaluate,
    ToafterSales
    
} serviceType;
@interface MBMyServiceChilderViewController : BkBaseViewController
@property (nonatomic,assign) serviceType type;
@property (nonatomic,strong) NSString *strType;

@end
