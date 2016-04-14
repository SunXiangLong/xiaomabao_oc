//
//  MBClubFrame.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/15.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBClub;
@interface MBClubFrame : NSObject
@property (strong,nonatomic) MBClub *club;

@property (assign,nonatomic) CGRect authorF;
@property (assign,nonatomic) CGRect picF;
@property (assign,nonatomic) CGRect titleF;
@property (assign,nonatomic) CGRect contentF;
@property (assign,nonatomic) CGRect commonF;
@property (assign,nonatomic) CGRect bottomF;
@property (assign,nonatomic) CGFloat cellHeight;

@end
