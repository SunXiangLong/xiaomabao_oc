//
//  MBDetailedViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBDetailedViewController : BkBaseViewController
/**
 *   yes表示从国家管界面来的
 */
@property (nonatomic,assign) BOOL countries;

@property (nonatomic,strong) NSString *cat_id;


@end
