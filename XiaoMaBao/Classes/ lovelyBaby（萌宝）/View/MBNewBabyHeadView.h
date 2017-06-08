//
//  MBNewBabyHeadView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBDayInfoModel;

/**
 block对应事件

 - theJumpPage: 跳转到对应网页
 - recordTheBaby: 记录宝宝日志
 - setHead: 宝宝已出生，设置头像
 - setThePregnancy: 设置备孕日期
  - setTheDueDate: 设置预产期
 */
typedef NS_OPTIONS(NSUInteger, MBBlockState) {
    
    theJumpPage                 = 0,
    recordTheBaby               = 1,
    setHead                     = 2,
    setThePregnancy             = 3,
    setTheDueDate
    
};
@interface MBNewBabyHeadView : UIView
@property (nonatomic,copy)  void (^sortingOptionsEvent)(NSDictionary *dic,MBBlockState type);
+ (instancetype)instanceView;

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) MBDayInfoModel *model;

@property (weak, nonatomic) IBOutlet UIView *preparePregnantView;
@property (weak, nonatomic) IBOutlet UIView *functionalClassificationView;
@end
