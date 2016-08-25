//
//  MBCollectionHeadViewTo.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCollectionHeadViewTo.h"

@implementation MBCollectionHeadViewTo

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBCollectionHeadViewTo" owner:nil options:nil] lastObject];
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
