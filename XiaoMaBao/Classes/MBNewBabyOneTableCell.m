//
//  MBNewBabyOneTableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyOneTableCell.h"

@implementation MBNewBabyOneTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _title.text = _dataDic[@"title"];
    _summary.text = _dataDic[@"summary"];
    [_showImage sd_setImageWithURL:URL(_dataDic[@"icon"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];

}
@end
