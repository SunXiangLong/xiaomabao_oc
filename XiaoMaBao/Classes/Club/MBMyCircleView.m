//
//  MBMyCircleView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMyCircleView.h"

@implementation MBMyCircleView
-(void)awakeFromNib{


}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBMyCircleView" owner:nil options:nil] lastObject];
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
