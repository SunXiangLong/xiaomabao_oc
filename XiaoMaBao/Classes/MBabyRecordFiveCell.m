//
//  MBabyRecordFiveCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBabyRecordFiveCell.h"

@implementation MBabyRecordFiveCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _image1.contentMode = UIViewContentModeScaleAspectFill;
    _image1.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.position.text    =  dataDic[@"position"];
    self.weekAddtime.text = string(dataDic[@"week"], string(@"   ", dataDic[@"addtime"]));
    self.day.text         = dataDic[@"day"];
    self.year_month.text  = string(dataDic[@"year"], string(@".", dataDic[@"month"]));
    
    
    [self.image1 sd_setImageWithURL:URL([dataDic[@"photo"] objectAtIndex:0]) placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
}

@end