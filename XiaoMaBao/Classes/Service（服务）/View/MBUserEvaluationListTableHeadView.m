//
//  MBUserEvaluationListTableHeadView.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBUserEvaluationListTableHeadView.h"

@implementation MBUserEvaluationListTableHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backImage .contentMode =  UIViewContentModeScaleAspectFill;
    self.backImage .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.backImage .clipsToBounds  = YES;
   
    self.showIageView .contentMode =  UIViewContentModeScaleAspectFill;
    self.showIageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.showIageView .clipsToBounds  = YES;
    
}
+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBUserEvaluationListTableHeadView" owner:nil options:nil] lastObject];
}

@end
