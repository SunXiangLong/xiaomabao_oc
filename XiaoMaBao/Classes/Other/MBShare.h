//
//  MBShare.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@interface MBShare : NSObject
/**
 *  markshare第三方登陆分享注册
 */
+ (void)share;
/**
 *   微信支付注册
 */
+ (void)WXApi;
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
+ (void)onResp:(BaseResp*)resp;
@end
