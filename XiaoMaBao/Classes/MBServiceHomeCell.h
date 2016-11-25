//
//  MBServiceHomeCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBServiceHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;
@property (weak, nonatomic) IBOutlet YYLabel *shopName;
@property (weak, nonatomic) IBOutlet YYLabel *shopCity;
@property (weak, nonatomic) IBOutlet YYLabel *shopAddress;
@property (weak, nonatomic) IBOutlet YYLabel *shopDesc;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
