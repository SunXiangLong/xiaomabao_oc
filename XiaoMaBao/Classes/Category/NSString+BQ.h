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
 *  根据字符串来获取长度
 *
 *  @return 长度
 */
- (CGSize)sizeWithFont:(UIFont *)font withMaxSize:(CGSize)size;
/**
 *  md5加密
 *
 *  @return 返回加密后的字符串
 */
- (NSString *)md5;

- (NSString *)isNSString;
@end
