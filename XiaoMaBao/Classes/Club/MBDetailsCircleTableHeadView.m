//
//  MBDetailsCircleTableHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBDetailsCircleTableHeadView.h"

@implementation MBDetailsCircleTableHeadView

-(void)awakeFromNib{
    
    [super awakeFromNib];
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBDetailsCircleTableHeadView" owner:nil options:nil] lastObject];
}

- (IBAction)button:(id)sender {
     [self.myCircleViewSubject  sendNext:@(1)];
}
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}


@end
