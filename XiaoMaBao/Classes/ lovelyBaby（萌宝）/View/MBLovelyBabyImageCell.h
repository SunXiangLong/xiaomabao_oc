//
//  MBLovelyBabyImageCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBLovelyBabyImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bandImageView;
@property (nonatomic,copy) void (^btnBlock)(void);
@end
