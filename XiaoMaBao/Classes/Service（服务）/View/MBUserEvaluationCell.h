//
//  MBUserEvaluationCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface MBUserEvaluationCell : UITableViewCell
@property(copy,nonatomic)NSDictionary *dataDic;
@property (nonatomic,weak) BkBaseViewController *VC;
@end
