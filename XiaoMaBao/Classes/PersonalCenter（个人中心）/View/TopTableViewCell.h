//
//  TopTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/26.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *GoodsNumber;

@end
