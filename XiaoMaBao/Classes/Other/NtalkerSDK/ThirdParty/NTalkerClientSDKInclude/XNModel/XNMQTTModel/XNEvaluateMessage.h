//
//  XNEvaluateMessage.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/21.
//  Copyright © 2015年 Kevin. All rights reserved.
//  评价消息

#import "XNBaseMessage.h"

@interface XNEvaluateMessage : XNBaseMessage

@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, strong) NSString *evaluateContent;
@property (nonatomic, strong) NSString *proposal;
@property (nonatomic, strong) NSString *solveStatus;

+ (NSString *)XMLStrFromMessage:(XNEvaluateMessage *)message;

+ (XNEvaluateMessage *)evaluateMessageWithMsgTime:(long long)msgTime
                                  andUserid:(NSString *)userid
                                andUserInfo:(NSString *)userInfo
                                 andMsgInfo:(NSString *)msgInfo;

@end
