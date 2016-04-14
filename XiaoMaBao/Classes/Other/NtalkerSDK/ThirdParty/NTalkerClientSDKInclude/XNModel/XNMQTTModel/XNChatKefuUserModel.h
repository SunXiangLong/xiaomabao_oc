//
//  XNChatKefuUserModel.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/3.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "XNChatBasicUserModel.h"

@interface XNChatKefuUserModel : XNChatBasicUserModel

@property (nonatomic, strong) NSString *externalname;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *sessionid;

+ (XNChatKefuUserModel *)dataFromJsonStr:(NSDictionary *)dict;

- (XNChatKefuUserModel *)clone:(XNChatKefuUserModel *)data;

- (BOOL)mergeUser:(XNChatKefuUserModel *)user WithAnotherUser:(XNChatKefuUserModel *)anotherUser;

@end
