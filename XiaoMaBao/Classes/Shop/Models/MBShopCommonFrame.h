//
//  MBShopCommonFrame.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/6.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBShopCommon;
@interface MBShopCommonFrame : NSObject
@property (assign,nonatomic) CGRect authorF;
@property (assign,nonatomic) CGRect levelF;
@property (assign,nonatomic) CGRect contentF;
@property (assign,nonatomic) CGRect figureF;
@property (assign,nonatomic) CGRect lineBottomF;
@property (assign,nonatomic) CGFloat cellHeight;
@property (strong,nonatomic) MBShopCommon *shopCommon;
@end
