//
//  KSNoNetView.m
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import "KSNoNetView.h"

@implementation KSNoNetView

+ (instancetype) instanceNoNetView
{
    static KSNoNetView* noNetView = nil;

    NSArray* array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    noNetView = [array firstObject];
    noNetView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    return noNetView;
}

- (IBAction)reloadNetworkDataSource:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadNetworkDataSource:)]) {
        [self.delegate performSelector:@selector(reloadNetworkDataSource:) withObject:sender];
    }
}
@end
