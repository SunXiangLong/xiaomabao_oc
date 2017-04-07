//
//  MBPostDetailsHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsHeadView.h"
@interface MBPostDetailsHeadView ()
{
    UIButton *_lastButton;
}
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@end
@implementation MBPostDetailsHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    _lastButton = _allButton;
    
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBPostDetailsHeadView" owner:nil options:nil] lastObject];
}

- (IBAction)touch:(UIButton *)sender {
    
    if (!sender.selected) {
        _lastButton.alpha = 1;
        _lastButton.selected = !_lastButton.selected;
        sender.selected = YES;
        sender.alpha = 0.9;
        _lastButton = sender;
        [self.myCircleViewSubject  sendNext:@(sender.tag)];
    }
   
}
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
@end
