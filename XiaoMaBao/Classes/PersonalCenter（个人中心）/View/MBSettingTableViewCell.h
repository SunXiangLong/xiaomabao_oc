//
//  MBSettingTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/7.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;

@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
@end
