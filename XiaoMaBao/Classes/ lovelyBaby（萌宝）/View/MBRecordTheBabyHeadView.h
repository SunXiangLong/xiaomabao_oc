//
//  MBRecordTheBabyHeadView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/9.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBRecordTheBabyHeadView : UIView
+ (instancetype)instanceView;
@property (strong, nonatomic) NSMutableArray *photoWallimageArr;
@property(copy,nonatomic) NSArray<UIButton *> *buttonArray;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (nonatomic,copy)  void (^blcok)(NSInteger tag);
@end
