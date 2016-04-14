//
//  MBUpdateBabyInforViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
typedef void(^QQBlock)(NSString *name,NSString *xingbie,NSString *daty,UIImage *imageUrl);
@interface MBUpdateBabyInforViewController : BkBaseViewController
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSString *daty;
@property (nonatomic,strong) NSString *xingbie;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *ID;

 @property (nonatomic, copy) QQBlock block;
@end
