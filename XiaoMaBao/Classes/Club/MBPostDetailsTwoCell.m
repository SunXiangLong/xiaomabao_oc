//
//  MBPostDetailsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsTwoCell.h"
#import "MBPostDetailsViewCell.h"
@interface MBPostDetailsTwoCell ()
/**
 *  存放cell高度的数组
 */

@end
@implementation MBPostDetailsTwoCell

- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (IBAction)reply:(UIButton *)sender {
    [self.myCircleViewSubject  sendNext:self.indexPath];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
