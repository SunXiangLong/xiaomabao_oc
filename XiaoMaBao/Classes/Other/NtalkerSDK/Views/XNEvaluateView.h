//
//  XNEvaluateView.h
//  TestEvaluateView
//
//  Created by Ntalker on 15/9/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const EVALUATEVALUE = @"XNEVALUATEVALUE";
static NSString *const EVALUATECONTENT = @"XNEVALUATECONTENT";
static NSString *const EVALUATESTATUS = @"XNEVALUATESTATUS";
static NSString *const EVALUATESUGGEST = @"XNEVALUATESUGGEST";

@class XNEvaluateView;

@protocol XNEvaluateDelagate <NSObject>

@optional

- (void)cancel:(XNEvaluateView *)evaluateView;
- (void)submitMessage:(NSDictionary *)dict evaluateView:(XNEvaluateView *)evaluateView;

@end

@interface XNEvaluateView : UIView

+ (XNEvaluateView *)addEvaluateViewWithFrame:(CGRect)frame delegate:(id<XNEvaluateDelagate>)delegate;

@end
