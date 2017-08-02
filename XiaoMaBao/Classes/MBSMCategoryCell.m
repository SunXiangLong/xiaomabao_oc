//
//  MBMBSMCategoryOneTabCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSMCategoryCell.h"
#import "MBSMCategoryModel.h"
@interface MBSMCategoryOneTabCell()
@property (weak, nonatomic) IBOutlet UIImageView *secondary_icon;
@property (weak, nonatomic) IBOutlet UILabel *cat_name;


@end
@implementation MBSMCategoryOneTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self uiedgeInsetsZero];
}
-(void)setModel:(MBSMCategoryModel *)model{
    _model = model;
    [_secondary_icon sd_setImageWithURL:model.secondary_icon ];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface MBSMCategoryTwoCollCell()
@property (weak, nonatomic) IBOutlet UIImageView *secondary_icon;
@end
@implementation MBSMCategoryTwoCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(catListsModel *)model{
    _model = model;
    [_secondary_icon sd_setImageWithURL:model.secondary_icon placeholderImage:PLACEHOLDER_DEFAULT_IMG];
    

}

@end
@interface MBSMPersonalCenterCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *number;


@end
@implementation MBSMPersonalCenterCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self uiedgeInsetsZero];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _icon.image = dataDic[@"image"];
    _typeName.text = dataDic[@"title"];
    _number.text = dataDic[@"number"];

}

@end
