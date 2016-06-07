//
//  MBabyRecordOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBabyRecordOneCell.h"


@interface MBabyRecordOneCell ()
{
    
}

@end
@implementation MBabyRecordOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
- (IBAction)touch:(UITapGestureRecognizer *)sender {
    
    
    [self.myCircleViewSubject sendNext:@(sender.view.tag)];
    
}



@end
