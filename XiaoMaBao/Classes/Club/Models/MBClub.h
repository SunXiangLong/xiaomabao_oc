//
//  MBClub.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/14.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBClubCommon;
@interface MBClub : NSObject
@property (copy,nonatomic) NSString *pic;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *tag;
@property (copy,nonatomic) NSString *praise_num;//赞数
@property (copy,nonatomic) NSString *Bigpic;
@property (copy,nonatomic) NSString *comment_num;//评论数
@property (copy,nonatomic) NSString *post_id;
@property (strong,nonatomic) MBClubCommon *common;
@property (copy,nonatomic) NSString *nick_name;
@property (copy,nonatomic) NSString *follow_id;


@end
