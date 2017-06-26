//
//  MBUserDataSingalTon.m
//  XiaoMaBao
//
//  Created by 余朋飞 on 15/7/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBUserDataSingalTon.h"

@implementation MBUserDataSingalTon
@synthesize sid;
@synthesize uid;
@synthesize phoneNumber;

- (void)clearUserInfo{
    self.sid = nil;
    self.uid = nil;
    self.phoneNumber = nil;
    self.mobile_phone = nil;
    self.nick_name = nil;
    self.rank_name = nil;
    self.header_img = nil;
    self.parent_sex = nil;
    self.identity_card = nil;
    self.collection_num = nil;
    self.user_baby_info = nil;
    self.is_baby_add = false;
    self.headerImg = nil;
    self.sessiondict  = nil;
    self.courseModel = nil;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    
    self.phoneNumber = dic[@"user_name"];
    return YES;
}
@end
@implementation MBUserBabyInfo
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    
    self.Id = dic[@"id"];
    return YES;
}
@end
@implementation MBCourseModel

@end
