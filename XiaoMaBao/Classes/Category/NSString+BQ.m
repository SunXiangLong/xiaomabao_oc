//
//  NSString+BQ.m
//  BQCommunity
//
//  Created by JQ on 14-7-26.
//  Copyright (c) 2014年 beiqing. All rights reserved.
//

#import "NSString+BQ.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (BQ)
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (CGSize) sizeWithFont:(UIFont *)font withMaxSize:(CGSize)size {
    if (iOS_7) {
        return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    }else{
        return [self sizeWithFont:font constrainedToSize:size];
    }
}

- (NSString *)md5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
-(NSString *)isNSString{
    NSString *str = @"";
    if (self) {
      
        if ([self isKindOfClass:[NSString class]]) {
            
            return self;
        }
        
        str = [NSString stringWithFormat:@"%@",self];
    }
    
    return str;
    

}
@end
