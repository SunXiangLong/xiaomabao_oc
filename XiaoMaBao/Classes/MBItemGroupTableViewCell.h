//
//  MBItemGroupTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBItemGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNamelable;
@property (weak, nonatomic) IBOutlet UILabel *shopIntroductionLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *presentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLable;
@property (weak, nonatomic) IBOutlet UIView *soldLable;
@property (weak, nonatomic) IBOutlet UILabel *salesnumLabel;

- (void)loadData:(id)data indexPath:(NSIndexPath*)indexPath;
@end
