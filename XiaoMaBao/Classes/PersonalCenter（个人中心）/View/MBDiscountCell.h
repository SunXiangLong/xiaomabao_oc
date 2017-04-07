//
//  MBDiscountCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/1.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBDiscountCell : UITableViewCell
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) BOOL isnext;
@property (nonatomic,assign) BOOL isnote;
@property (nonatomic,strong) UITextField *textField;

@end
