//
//  XNChatBasicUserModel.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/3.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNChatBasicUserModel : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *usericon;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int sex;
@property (nonatomic, assign) int hasConnTchat;
@property (nonatomic, assign) int num;
//

@end
