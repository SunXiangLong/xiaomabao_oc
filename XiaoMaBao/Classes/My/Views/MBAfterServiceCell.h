//
//  MBAfterServiceCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/10/28.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBAfterServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bakecoloc;
@property (weak, nonatomic) IBOutlet UIImageView *ShopImage;

@property (weak, nonatomic) IBOutlet UILabel *ShopName;
@property (weak, nonatomic) IBOutlet UILabel *ShopPrice;


@property (weak, nonatomic) IBOutlet UILabel *ChildrenOrderNumber;
@end
