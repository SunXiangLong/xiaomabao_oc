//
//  MBNewBabyHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyHeadView.h"

@implementation MBNewBabyHeadView
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBNewBabyHeadView" owner:nil options:nil]  firstObject];
}
- (IBAction)touch:(UITapGestureRecognizer *)sender {
    
    [self.myCircleViewSubject sendNext:@(sender.view.tag)];
}
@end
