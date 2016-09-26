//
//  MBAddIDCardView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"

typedef void(^AddIDCard)(BOOL isbool);
@interface MBAddIDCardView : UIView

@property (nonatomic,weak) BkBaseViewController *VC;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,copy)  NSMutableArray    *photoArray;
@property (nonatomic, copy) AddIDCard block;

+ (instancetype)instanceView;
@end
