//
//  MBUserDataSingalTon.h
//  XiaoMaBao
//
//  Created by 余朋飞 on 15/7/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBUserDataSingalTon : NSObject
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *sid;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *mobile_phone;
@property (copy, nonatomic) NSString *nick_name;
@property (copy, nonatomic) NSString *rank_name;
@property (copy, nonatomic) NSString *header_img;
@property (copy, nonatomic) NSString *parent_sex;
@property (copy, nonatomic) NSString *identity_card;
@property (copy, nonatomic) NSString *collection_num;
@property (copy, nonatomic) NSString *is_baby_add;
@property (copy, nonatomic) NSDictionary *user_baby_info;
// 清除所有值
- (void)clearUserInfo;
@end
