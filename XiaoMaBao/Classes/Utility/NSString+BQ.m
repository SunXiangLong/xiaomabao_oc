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
- (CGSize) sizeWithFont:(UIFont *)font   withMaxSize:(CGSize)size {
   
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    
}
- (CGFloat) sizeWithFont:(UIFont *)font lineSpacing:(CGFloat)line  withMax:(CGFloat)size{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = line;
    
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(size, MAXFLOAT) options:options context:nil];
    
    if ((rect.size.height - font.lineHeight) <= style.lineSpacing) {
        if ([self containChinese]) {
             rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-style.lineSpacing);
        }
       
    }
    
    return rect.size.height;
 

}
//判断如果包含中文
- (BOOL)containChinese{
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}
- (NSString *)md5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned)strlen(cStr), result); // This is the md5 call
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

- (NSString *)SHA256
{
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}
- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
- (BOOL)isValidWithIdentityNum{
    //先正则匹配
    //......
    if (self && [self isEqualToString:@""]) {
        
        return false;
    }
    
    //计算最后一位余数
    NSArray *arrExp = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSArray *arrVaild = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    
    long sum = 0;
    for (int i = 0; i < (self.length -1); i++) {
        NSString * str = [self substringWithRange:NSMakeRange(i, 1)];
        sum += [str intValue] * [arrExp[i] intValue];
    }
    
    int idx = (sum % 11);
    if ([arrVaild[idx] isEqualToString:[self substringWithRange:NSMakeRange(self.length - 1, 1)]]) {
        return YES;
    }else{
        return NO;
    }
    
    
    
    return YES;
}
- (BOOL)isValidPhone{
    if (self.length != 11) {
        return NO;
    }else{
    
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        
        if (isMatch1 || isMatch2 || isMatch3) {  
            return YES;  
        }else{  
            return NO;  
        }
    
    }


}

+(NSString*)UUID{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
+ (NSArray *)htmlString:(NSString *)str AspectRatio:(NSArray *)array{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSArray *strArr = [str componentsSeparatedByString:@"<div>"];
    
    for (NSString *string in strArr) {
        if ([string containsString:@"<img src=\""]) {
            NSArray *stringArr = [string componentsSeparatedByString:@"<img src=\""];
            if (stringArr.count == 1) {
                NSDictionary *dic = @{@"text":@"",@"imageUrl":[stringArr.lastObject componentsSeparatedByString:@"\""].firstObject};
                [arr addObject:dic];
            }else{
//                MMLog(@"%@",string);
                
                if ([string containsString:@"</div>"]) {
                    NSDictionary *dic = @{@"text":[stringArr.firstObject componentsSeparatedByString:@"</div>"].firstObject,@"imageUrl":[stringArr.lastObject componentsSeparatedByString:@"\""].firstObject};
                    [arr addObject:dic];
                }else{
                    
                    
                    
                    NSDictionary *dic = @{@"text":[stringArr.firstObject componentsSeparatedByString:@"<br>"].firstObject,@"imageUrl":[stringArr.lastObject componentsSeparatedByString:@"\""].firstObject};
                    [arr addObject:dic];
                }
                
            }
        }else{
            
            NSDictionary *dic = @{@"text":[string componentsSeparatedByString:@"</div>"].firstObject,@"imageUrl":@"",@"aspectRatio":@""};
            [arr addObject:dic];
        }
        
    }
    

    return arr;
}
+ (BOOL )htmlImgString:(NSString *)str{
    NSInteger coun = 0;
    NSArray *strArr = [str componentsSeparatedByString:@"<div>"];
    for (NSString *string in strArr) {
        if ([string containsString:@"<img src=\""]) {
        
            coun++;
        }

        
    }
    if (coun != 1) {
        return YES;
    }
    return NO;
}
+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@"" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    temp = [temp stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    return temp;
}
+ (NSString *)filterHTML:(NSString *)html

{
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
        
    {
        
        //找到标签的起始位置
        
        [scanner scanUpToString:@"<" intoString:nil];
        
        //找到标签的结束位置
        
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
    }
    
    return html;
    
}
+ (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    
    NSMutableArray *results = [NSMutableArray array];
    
    
    
    NSRange searchRange = NSMakeRange(0, [str length]);
    
    
    
    NSRange range;
    
    
    
    while ((range = [str rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
        
        [results addObject:[NSValue valueWithRange:range]];
        
        
        
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
        
        
        
    }
    
    
    
    return results;
    
    
    
}

+ (NSInteger)getAppearCount:(NSString *)withStr{
    NSString *searchStr = @"<br>";
    int count=0;
    
    for (int i = 0; i < withStr.length - searchStr.length + 1; i++)
    {
        if ([[withStr substringWithRange:NSMakeRange(i, searchStr.length)] isEqualToString:searchStr])
        {
            count++;
        }
    }
    return count;
}

/**
 *  根据字符串时间获取时间戳
 *
 *  @param dateStr 字符串时间
 *
 *  @return NSTimeInterval
 */
- (NSDate *)stringConversionDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
   
    NSDate *date = [formatter  dateFromString:self];
    return date;
}

+ (NSString *)dateConversionString:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  
   
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    return  [formatter stringFromDate:date];
    
    
}
@end
