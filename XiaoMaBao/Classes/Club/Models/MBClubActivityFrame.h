//
//  MBClubActivityFrame.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/16.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBClubActivity.h"

@interface MBClubActivityFrame : NSObject
@property (strong,nonatomic) MBClubActivity *activity;
@property (assign, nonatomic) CGRect authorF;
@property (assign, nonatomic) CGRect picImgF;
@property (assign, nonatomic) CGRect titleLblF;
@property (assign, nonatomic) CGRect contentF;
@property (assign, nonatomic) CGRect buttonF;
@property (assign,nonatomic) CGFloat cellHeight;
@end
