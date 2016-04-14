//
//  XNChatVisitUserModel.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/3.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "XNChatBasicUserModel.h"

@interface XNChatVisitUserModel : XNChatBasicUserModel

@property (nonatomic, assign) int level;

+ (XNChatVisitUserModel *)dataFromJsonStr:(NSDictionary *)dict;

- (XNChatVisitUserModel *)clone:(XNChatVisitUserModel *)data;

- (BOOL)mergeUser:(XNChatVisitUserModel *)user WithAnotherUser:(XNChatVisitUserModel *)anotherUser;

@end
