//
//  MBMyTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/6.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBMyItem;
@interface MBMyTableViewCell : UITableViewCell
@property (strong,nonatomic) MBMyItem *item;
@end
