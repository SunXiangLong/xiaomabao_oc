//
//  MBPostDetailsFooterTwo.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/7/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsFooterTwo.h"

@implementation MBPostDetailsFooterTwo

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBPostDetailsFooterTwo" owner:nil options:nil] lastObject];
}
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (IBAction)button:(id)sender {
    [self.myCircleViewSubject sendNext:_indexPath];
}
@end
