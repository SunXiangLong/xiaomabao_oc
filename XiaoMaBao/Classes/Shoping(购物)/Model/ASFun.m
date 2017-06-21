//
//  ASFun.m
//  ASPlayerDemo
//
//  Created by Steven on 2017/6/14.
//  Copyright © 2017年 Ablesky. All rights reserved.
//

#import "ASFun.h"
#import <CommonCrypto/CommonHMAC.h>
@implementation ASFun

+ (id)sharedInstance {
    static ASFun *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)fetchStamping
{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", timeInterval];
    NSArray *array = [timeString componentsSeparatedByString:@"."];
    timeString = array[0];
    return timeString;
}


-(NSString*)stringToJson:(NSDictionary *)dic
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}


-(NSString*)tokenWithString:(NSString *)string
{
    NSString *token = @"";
    token = [NSString stringWithFormat:@"%@",string];
    token = [self stringMD5WithString:token];
    return token;
}

- (NSString *)stringMD5WithString:(NSString *)orgString {
    if (!orgString) {
        return @"";
    }
    const char *str = [orgString UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}


@end
