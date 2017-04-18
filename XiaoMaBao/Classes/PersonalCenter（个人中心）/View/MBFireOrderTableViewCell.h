//
//  MBFireOrderTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBShoppingCartModel.h"
@interface MBFireOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *discount_name;
@property (weak, nonatomic) IBOutlet UIImageView *showimageview;
@property (weak, nonatomic) IBOutlet UILabel *desribe;
@property (weak, nonatomic) IBOutlet UILabel *countprice;
@property (weak, nonatomic) IBOutlet UILabel *countNumber;
@property (nonatomic, strong)  MBGood_ListModel *model;
@end
