//
//  MBMallItemCategoryTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/26.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBMallItemCategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zheKou;
@property (weak, nonatomic) IBOutlet UILabel *decribe;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *LeavesTime;
@property (weak, nonatomic) IBOutlet UILabel *startTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *view;

@end
