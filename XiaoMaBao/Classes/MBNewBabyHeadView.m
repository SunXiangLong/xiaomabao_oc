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
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    if (dataDic) {
        
        self.view_height.constant = 88+[dataDic[@"content"] sizeWithFont:SYSTEMFONT(15) withMaxSize:CGSizeMake(UISCREEN_WIDTH -50, MAXFLOAT)].height;
    }else{
        
        self.view_height.constant = 0;
        self.cenView.hidden = YES;
        
        
    }
 
    
    self.baby_length.text = dataDic[@"baby_length"];
    self.baby_weight.text = dataDic[@"baby_weight"];
    self.baby_date.text = dataDic[@"overdue_daynum"];
    if (!dataDic[@"overdue_daynum"]) {
        self.view_weith.constant = self.view1_weith.constant = (UISCREEN_WIDTH -1)/2;
        self.view2_weith.constant =  0;
    }else{
     self.view_weith.constant = self.view2_weith.constant =self.view1_weith.constant = (UISCREEN_WIDTH -2)/3;
    
    }
    self.babyDate.text  =   self.baby_date.text.length>0?@"距离预产期":@"";
    
    self.baby_content.text = dataDic[@"content"];
}
@end
