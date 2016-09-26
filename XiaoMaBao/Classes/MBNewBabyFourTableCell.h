//
//  MBNewBabyFourTableCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"

@interface MBNewBabyFourTableCell : UITableViewCell
@property (strong, nonatomic) BkBaseViewController *VC;
@property(strong,nonatomic)NSArray *dataArr;


@property (weak, nonatomic) IBOutlet UIImageView *image0;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;

@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (weak, nonatomic) IBOutlet UILabel *goods_name0;

@property (weak, nonatomic) IBOutlet UILabel *goods_name1;
@property (weak, nonatomic) IBOutlet UILabel *goods_name2;
@property (weak, nonatomic) IBOutlet UILabel *goods_name3;
@property (weak, nonatomic) IBOutlet UILabel *goods_price0;

@property (weak, nonatomic) IBOutlet UILabel *goods_price1;
@property (weak, nonatomic) IBOutlet UILabel *goods_price2;
@property (weak, nonatomic) IBOutlet UILabel *goods_price3;
@property (weak, nonatomic) IBOutlet UILabel *market_price0;
@property (weak, nonatomic) IBOutlet UILabel *market_price1;
@property (weak, nonatomic) IBOutlet UILabel *market_price3;

@property (weak, nonatomic) IBOutlet UILabel *market_price2;
@end
