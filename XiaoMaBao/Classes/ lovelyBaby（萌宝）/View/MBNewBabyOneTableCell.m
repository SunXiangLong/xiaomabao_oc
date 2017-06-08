//
//  MBNewBabyOneTableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyOneTableCell.h"
#import "MBLovelyBabyModel.h"
@implementation MBNewBabyOneTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(MBRemindModel *)model{
    _model = model;
    _title.text = model.title;
    _summary.text = model.summary;
     [_showImage sd_setImageWithURL:model.url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _title.text = _dataDic[@"title"];
    _summary.text = _dataDic[@"summary"];
    if ([_dataDic[@"icon"] isKindOfClass:[UIImage class]]) {
        _showImage.image = _dataDic[@"icon"] ;
        _title.font = YC_RTWSYueRoud_FONT(15);
        _summary.font = YC_RTWSYueRoud_FONT(12);
        return;
    }
    
    [_showImage sd_setImageWithURL:URL(_dataDic[@"icon"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
 


}
@end
