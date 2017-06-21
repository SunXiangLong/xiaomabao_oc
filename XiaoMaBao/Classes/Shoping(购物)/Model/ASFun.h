//
//  ASFun.h
//  ASPlayerDemo
//
//  Created by Steven on 2017/6/14.
//  Copyright © 2017年 Ablesky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASFun : NSObject

+ (id)sharedInstance;

-(NSString *)stringToJson:(NSDictionary*)dic;

-(NSString *)fetchStamping;

-(NSString *)tokenWithString:(NSString *)string;

@end
