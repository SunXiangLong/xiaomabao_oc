//
//  MBBabyCardCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyCardCell.h"

@implementation MBBabyCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showImage .contentMode =  UIViewContentModeScaleAspectFill;
    self.showImage .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.showImage .clipsToBounds  = YES;
    
}
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)choose:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_myCircleViewSubject sendNext:@[_indexPath,@(sender.selected)]];
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _babyCard.text = string(@"卡号：", dataDic[@"card_no"]);
    _babyCardPrice.text = string(@"抵用金额", dataDic[@"card_surplus_money"]);
    _babyCardDate.text = dataDic[@"use_end_time"];
    
    if ([_dataDic[@"over_date"]  integerValue] == 1) {
        self.showImage.hidden = NO;
        _seleButton.enabled = NO;
    }

}
@end
