//
//  GoodsTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/11/26.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *tuihuo;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumbei;
@property (nonatomic,strong) NSString *goodsNumber;
@property (nonatomic,assign) NSInteger row;

@end
