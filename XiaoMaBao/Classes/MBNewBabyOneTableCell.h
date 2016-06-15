//
//  MBNewBabyOneTableCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNewBabyOneTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (copy, nonatomic) NSDictionary *dataDic;
@end
