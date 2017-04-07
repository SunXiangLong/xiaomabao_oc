//
//  MBCollectionHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBCollectionHeadView : UIView
+ (instancetype)instanceView;

@property (weak, nonatomic) IBOutlet UILabel *tishi;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end
