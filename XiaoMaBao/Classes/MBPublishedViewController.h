//
//  MBPublishedViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
typedef void(^bbllock)();
@interface MBPublishedViewController : BkBaseViewController
 @property (nonatomic, copy) bbllock block;
/**
 *  精度
 */
@property (nonatomic,strong) NSString *longitude;
/**
 *   纬度
 */
@property (nonatomic,strong) NSString *latitude;
@end
