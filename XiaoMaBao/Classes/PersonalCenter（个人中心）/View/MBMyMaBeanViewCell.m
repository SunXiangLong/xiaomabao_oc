//
//  MBMyMaBeanViewCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyMaBeanViewCell.h"

@implementation MBMyMaBeanViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(MBRecordsModel *)model{
    _model = model;
    
    _record_val.text =  model.record_val;
    _record_desc.text = model.record_desc;
    _record_time.text = model.record_time;
    
    
    if ([model.record_val containsString:@"-"]) {
        _record_desc.textColor = UIcolor(@"999999");
        _record_time.textColor = UIcolor(@"999999");
        _record_val.textColor = UIcolor(@"999999");
        
    }else{
        _record_desc.textColor = UIcolor(@"555555");
        _record_val.textColor = UIcolor(@"ff7162");
        
        
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
