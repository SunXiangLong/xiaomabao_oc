//
//  MBMycircleTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMycircleTableViewCell.h"

@implementation MBMycircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.noLable.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touch:(id)sender {
    
        [self.myCircleCellSubject  sendNext:_indexPath];
}
- (RACSubject *)myCircleCellSubject {
    
    if (!_myCircleCellSubject) {
        
        _myCircleCellSubject = [RACSubject subject];
    }
    
    return _myCircleCellSubject;
}
@end
