//
//  MBabyRecordFourCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBabyRecordFourCell.h"

@implementation MBabyRecordFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic =dataDic;
    self.content.text = dataDic[@"content"];
    self.position.text    =  dataDic[@"position"];
    self.weekAddtime.text = string(dataDic[@"week"], string(@"   ", dataDic[@"addtime"]));
    self.day.text         = dataDic[@"day"];
    self.year_month.text  = string(dataDic[@"year"], string(@".", dataDic[@"month"]));
}

@end
