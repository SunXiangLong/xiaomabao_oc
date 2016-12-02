//
//  MBServiceShopsTableHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBServiceShopsTableHeadView : UIView
@property (weak, nonatomic) IBOutlet YYLabel *name;
@property (weak, nonatomic) IBOutlet YYLabel *number;

+ (instancetype)instanceView;
@end
