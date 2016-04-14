//
//  MBClubFrame.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/15.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBClubFrame.h"
#import "MBClub.h"
#import "NSString+BQ.h"
#import "MBClubCommon.h"

@implementation MBClubFrame

- (void)setClub:(MBClub *)club{
    _club = club;
    
    
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
    self.picF = CGRectMake(0, 0, mainSize.width, 220);
    
    self.authorF = CGRectMake(0, 0, mainSize.width, 32);
    
    // titleF
    
    if (club.content) {
        CGSize titleSize = [club.title sizeWithFont:[UIFont systemFontOfSize:18] withMaxSize:CGSizeMake(mainSize.width - MARGIN_8 * 2, MAXFLOAT)];
        self.titleF = CGRectMake(MARGIN_8, CGRectGetMaxY(self.picF) + MARGIN_8, mainSize.width - MARGIN_8 * 2, titleSize.height);
        
        CGFloat contentH = [club.content sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(mainSize.width - MARGIN_8 * 2, MAXFLOAT)].height;

        self.contentF = CGRectMake(MARGIN_8, CGRectGetMaxY(self.titleF) + MARGIN_8, mainSize.width - MARGIN_8 * 2, contentH);
    }else{
        CGSize titleSize = [club.title sizeWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(mainSize.width - MARGIN_8 * 2, MAXFLOAT)];
        
        self.titleF = CGRectMake(MARGIN_8, CGRectGetMaxY(self.picF) + MARGIN_8, mainSize.width - MARGIN_8 * 2, titleSize.height);
    }
    
    if (club.common) {
        // figureF
        CGFloat commonHeight = 50;
        CGSize commonContentLblSize = [club.common.content sizeWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(mainSize.width - 94, 50)];
        if (commonContentLblSize.height > 20) {
            commonHeight += commonContentLblSize.height;
        }
        self.commonF = CGRectMake(40, CGRectGetMaxY(self.titleF), mainSize.width - 44, commonHeight);
        self.bottomF = CGRectMake(0, CGRectGetMaxY(self.commonF), mainSize.width, 25);
    }else{
        self.bottomF = CGRectMake(0, CGRectGetMaxY(self.titleF), mainSize.width, 25);
    }
    
    self.cellHeight = CGRectGetMaxY(self.bottomF) + MARGIN_5;
    
//    self.lineBottomF = CGRectMake(0, self.cellHeight - PX_ONE, mainSize.width, PX_ONE);
}

@end
