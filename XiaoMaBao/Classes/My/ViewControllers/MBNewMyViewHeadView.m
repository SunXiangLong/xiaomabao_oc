//
//  MBNewMyViewHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewMyViewHeadView.h"

@implementation MBNewMyViewHeadView
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.height.constant = 0.5;
   
    
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBMyViewHeadView" owner:nil options:nil] lastObject];
}


- (IBAction)button:(UIButton *)sender {
    
     NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (!sid) {
   [self.myCircleViewSubject sendNext:@4];
        
        return;
    }
    [self.myCircleViewSubject sendNext:@(sender.tag)];
}

- (IBAction)login:(id)sender {
    
    [self.myCircleViewSubject sendNext:@4];
}

@end
