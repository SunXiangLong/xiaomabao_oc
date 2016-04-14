//
//  XNGoodsInfoView.h
//  XNChatCore
//
//  Created by Ntalker on 15/10/26.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNJumpProductDelegate <NSObject>

- (void)jumpByProductURL;

- (void)productInfoShowFailed;

- (void)productInfoSuccess;

@end

@class XNGoodsInfoModel;
@interface XNGoodsInfoView : UIView

- (instancetype)initWithFrame:(CGRect)frame andGoodsInfoModel:(XNGoodsInfoModel *)goodsInfo andDelegate:(id<XNJumpProductDelegate>)delegate;

@end
