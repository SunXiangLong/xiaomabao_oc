//
//  MBShopCommonFrame.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/6.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBShopCommonFrame.h"
#import "MBShopCommon.h"
#import "NSString+BQ.h"

@implementation MBShopCommonFrame

- (void)setShopCommon:(MBShopCommon *)shopCommon{
    _shopCommon = shopCommon;
    
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
    // author
    CGSize authorSize = [shopCommon.author sizeWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(mainSize.width - 16, 15)];
    self.authorF = CGRectMake(MARGIN_8, MARGIN_10, authorSize.width, 15);
    
    // levelF
    self.levelF = CGRectMake(self.authorF.origin.x + 10, MARGIN_10, 35, 8);
    
    // contentF
    CGSize contentSize = [shopCommon.content sizeWithFont:[UIFont systemFontOfSize:11] withMaxSize:CGSizeMake(mainSize.width - MARGIN_8 * 2, MAXFLOAT)];
    self.contentF = CGRectMake(MARGIN_8, CGRectGetMaxY(self.authorF) + MARGIN_8, mainSize.width - MARGIN_8 * 2, contentSize.height);
    
    if (shopCommon.figures.count) {
        // figureF
        NSInteger figuresCount = shopCommon.figures.count;
        NSInteger row = figuresCount / ((mainSize.width) / 60);
        CGFloat figureHeight = (row * (60 + MARGIN_5) + 65);
        self.figureF = CGRectMake(MARGIN_8, CGRectGetMaxY(self.contentF), mainSize.width - MARGIN_8 * 2, figureHeight);
        
        self.cellHeight = CGRectGetMaxY(self.figureF) + MARGIN_5;
    }else{
        self.cellHeight = CGRectGetMaxY(self.contentF) + MARGIN_5;
    }
    
    self.lineBottomF = CGRectMake(0, self.cellHeight - PX_ONE, mainSize.width, PX_ONE);
}

@end
