//
//  MBServiceCollCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBServiceCollCell.h"
@interface MBServiceCollCell()
@property (weak, nonatomic) IBOutlet UIImageView *cat_icon;
@end
@implementation MBServiceCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(ServiceCategoryModel *)model{
    _model = model;
    [self.cat_icon sd_setImageWithURL:model.cat_icon placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}
@end
