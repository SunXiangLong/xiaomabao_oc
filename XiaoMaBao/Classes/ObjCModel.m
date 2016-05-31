//
//  ObjCModel.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "ObjCModel.h"

@implementation ObjCModel
- (void)showLogin{
 NSLog(@"Js调用了OC的方法，参数为：%@", @"000");
   [self.myCircleViewSubject sendNext:@{@"type":@"showLogin"}];
}

- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}

// 通过JSON传过来
- (void)showGood:(NSString *)params{
 NSLog(@"Js调用了OC的方法，参数为：%@", params);
    [self.myCircleViewSubject sendNext:@{@"params":params,@"type":@"showGood"}];

}
- (void)showTopic:(NSString *)params{
 NSLog(@"Js调用了OC的方法，参数为：%@", params);
    [self.myCircleViewSubject sendNext:@{@"params":params,@"type":@"showTopic"}];
 
}
- (void)showGroup:(NSString *)params{
    NSLog(@"Js调用了OC的方法，参数为：%@", params);
    [self.myCircleViewSubject sendNext:@{@"params":params,@"type":@"showGroup"}];

}
- (void)showWebView:(NSString *)params :(NSString *)topId{
 NSLog(@"Js调用了OC的方法，参数为：%@ %@", params,topId);

}
@end
