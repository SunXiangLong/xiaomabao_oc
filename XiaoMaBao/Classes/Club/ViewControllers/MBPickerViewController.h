//
//  MBPickerViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
typedef enum {
    back =10,
    back_Yes =0,//可以返回
    back_No =1,//不可以返回
   
} Enum_back;
 typedef void(^Blo)(UIImage *image);
@interface MBPickerViewController : BkBaseViewController
@property (nonatomic,assign) Enum_back  isBack;
@property (nonatomic, copy)  Blo block;
@end
