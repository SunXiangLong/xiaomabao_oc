//
//  UITableViewCell+MBBottomLine.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "UITableViewCell+MBBottomLine.h"

@implementation UITableViewCell (MBBottomLine)
-(void)uiedgeInsetsZero{
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins  = NO;
}

-(void)removeUIEdgeInsetsZero{

    self.separatorInset = UIEdgeInsetsMake(0, 100000, 0, 0);
    self.layoutMargins = UIEdgeInsetsMake(0, 100000, 0, 0);
}
@end
@implementation UITableView (foot)

- (void)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{

    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.automaticallyHidden = YES;
    footer.refreshingTitleHidden = NO;
    footer.stateLabel.textColor = UIcolor(@"555555");
    [footer setTitle:@"-the end-" forState:5];
    self.mj_footer =  footer;
}
@end
