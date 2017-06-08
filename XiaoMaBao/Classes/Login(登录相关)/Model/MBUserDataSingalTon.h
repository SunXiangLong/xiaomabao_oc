//
//  MBUserDataSingalTon.h
//  XiaoMaBao
//
//  Created by 余朋飞 on 15/7/19.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MBUserBabyInfo : NSObject
@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSURL *photo;
@property (copy, nonatomic) NSString *overdue_date;
@end
@interface MBUserDataSingalTon : NSObject
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *sid;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *mobile_phone;
@property (copy, nonatomic) NSString *nick_name;
@property (copy, nonatomic) NSString *rank_name;
@property (copy, nonatomic) NSString *header_img;
@property (copy, nonatomic) UIImage *headerImg;
@property (copy, nonatomic) NSString *parent_sex;
@property (copy, nonatomic) NSString *identity_card;
@property (copy, nonatomic) NSString *collection_num;
@property (assign, nonatomic) BOOL is_baby_add;
@property (strong, nonatomic) MBUserBabyInfo *user_baby_info;
@property (copy, nonatomic) NSDictionary *sessiondict;


// 清除所有值
- (void)clearUserInfo;
@end
