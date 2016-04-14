//
//  MBLogisticsViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBLogisticsViewController : BkBaseViewController
/***快递公司编码 */
@property (nonatomic,strong) NSString *type;
/***快递单号*/
@property (nonatomic,strong) NSString *postid;

@end
