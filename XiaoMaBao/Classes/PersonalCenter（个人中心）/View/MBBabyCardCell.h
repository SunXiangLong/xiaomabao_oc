//
//  MBBabyCardCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaBaoCardModel.h"
@interface MBBabyCardCell : UITableViewCell
@property (nonatomic,strong) MaBaoCardModel *model;
/**是否只是查看麻包卡*/
@property (nonatomic,assign) BOOL isJustLookAt;
@end
