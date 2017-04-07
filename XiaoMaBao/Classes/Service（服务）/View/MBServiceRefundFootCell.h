//
//  MBServiceRefundFootCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBServiceRefundFootCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mabaoquan;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end
