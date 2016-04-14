//
//  XNFirstHttpService.h
//  XNChatCore
//
//  Created by Ntalker on 15/8/19.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNFirstHttpService : NSObject

- (void)sendGetflashserverRequest:(NSString *)URLStr andParam:(id)param;

- (void)postTrailInfo:(NSString *)URLStr andParam:(id)param;

- (void)sendAppChatGetflashserverRequest:(NSString *)URLStr andParam:(id)param;

- (void)sendT2dServerConnectionRequest:(NSString *)URLStr andParam:(id)param;

- (void)sendTchatConnectionRequest:(NSString *)URLStr andParam:(id)param;

- (void)postImageFileUpRequest:(NSString *)URLStr andParam:(id)param andFilePath:(NSString *)path andType:(NSString *)type andBackResponse:(void(^)(id response))backResponse;

- (void)postVoiceFileUpRequest:(NSString *)URLStr andParam:(id)param andFilePath:(NSString *)path andType:(NSString *)type andBackResponse:(void(^)(id response))backResponse;

- (void)postLeaveMessageWithURL:(NSString *)URLStr andParam:(id)param withBlock:(void(^)(id response))block;

- (void)sendProductInfoWithURL:(NSString *)URLStr andParam:(id)param andBlock:(void(^)(id response))block;


- (void)cancelRequest;

@end
