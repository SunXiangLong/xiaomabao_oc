//
//  MBEvaluationController.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/29.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
#import "MBOrderModel.h"
@interface MBEvaluationController : BkBaseViewController
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSMutableArray<MBGoodListModel *> *goodListArray;
@property (nonatomic,assign) NSInteger section;
@end
