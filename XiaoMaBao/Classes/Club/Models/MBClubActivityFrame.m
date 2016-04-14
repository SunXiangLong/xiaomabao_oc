//
//  MBClubActivityFrame.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/16.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBClubActivityFrame.h"
#import "NSString+BQ.h"

@implementation MBClubActivityFrame

- (void)setActivity:(MBClubActivity *)activity{
    _activity = activity;
    
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
    self.authorF = CGRectMake(0, 0, mainSize.width, 32);
    
    self.picImgF = CGRectMake(0, CGRectGetMaxY(self.authorF), mainSize.width, 185);
    
    // titleF
    CGSize titleSize = [activity.act_name sizeWithFont:[UIFont systemFontOfSize:18] withMaxSize:CGSizeMake(mainSize.width - MARGIN_8 * 2, MAXFLOAT)];
    
    self.titleLblF = CGRectMake(MARGIN_8, CGRectGetMaxY(self.picImgF) + MARGIN_10, mainSize.width - MARGIN_8 * 2, titleSize.height);
    
    // contentSize
    CGSize contentSize = [activity.act_content sizeWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(mainSize.width - MARGIN_8 * 2, MAXFLOAT)];
    
    self.contentF = CGRectMake(MARGIN_8, CGRectGetMaxY(self.titleLblF) + MARGIN_10, mainSize.width - MARGIN_8 * 2, contentSize.height);
    
    self.buttonF = CGRectMake(mainSize.width - 108, CGRectGetMaxY(self.contentF) + MARGIN_20, 100, 26);
    
    self.cellHeight = CGRectGetMaxY(self.buttonF) + MARGIN_5;
}

@end
