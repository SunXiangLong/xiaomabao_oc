//
//  MBMyCircleViewTo.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyCircleViewTo.h"

@implementation MBMyCircleViewTo

-(void)awakeFromNib{
    
    
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBMyCircleViewTo" owner:nil options:nil] lastObject];
}

- (IBAction)touch:(UIButton *)sender {
    [self.myCircleViewSubject  sendNext:@(sender.tag)];
}
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}

@end
