//
//  MBVaccineViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBVaccineViewController : BkBaseViewController
/**
 *  web的网址
 */
@property (nonatomic,strong) NSURL  *url;
/**
 *  是否有搜索
 */
@property (nonatomic,assign) BOOL isSearch;

@end
