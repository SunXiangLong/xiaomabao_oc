//
//  MBBaseCollectionView.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/23.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBBaseCollectionView.h"

@implementation MBBaseCollectionView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [RACObserve(self, contentOffset) subscribeNext:^(id x) {
        
        CGPoint point = [x CGPointValue];
        if (point.x<0) {
            self.scrollEnabled = false;
        }else{
            self.scrollEnabled = true;
        }
        
    }];
}
-(instancetype)init{
    
    return [super init];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // iOS横向滚动的scrollView和系统pop手势返回冲突的解决办法:     http://blog.csdn.net/hjaycee/article/details/49279951
    
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //MARK: UITableViewCell 自定义手势可能要在此处自行定义
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        
        return YES;
    }
    
    return NO;
}

@end
