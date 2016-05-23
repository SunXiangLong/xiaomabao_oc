//
//  NSString+BQ.h
//  BQCommunity
//
//  Created by JQ on 14-7-26.
//  Copyright (c) 2014年 beiqing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TimeYear = 0,
    TimeMonth
} kTimeType;

@interface NSString (BQ)
/**
 *  根据字符串来获取长度或宽度 字号 行距 求宽度或长度
 *
 *  @param font 字号
 *  @param line 行数
 *  @param size 宽度或长度
 *
 *  @return 长度或宽度
 */
- (CGFloat) sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)line  withMax:(CGFloat)size;
/**
 *  根据字符串来获取长度
 *
 *  @return 长度
 */
- (CGSize)sizeWithFont:(UIFont *)font   withMaxSize:(CGSize)size;

/**
 *  md5加密
 *
 *  @return 返回加密后的字符串
 */
- (NSString *)md5;
/**
 *  SHA256加密
 *
 *  @return SHA256加密字符串
 */
- (NSString *)SHA256;
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;

- (NSString *)isNSString;
@end
