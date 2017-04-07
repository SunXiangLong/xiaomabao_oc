//
//  NSArray+Model.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "NSArray+Model.h"

@implementation NSArray (Model)
+ (NSArray *)modelDictionary:(NSDictionary *)dic modelKey:(NSString *)key modelClassName:(NSString *)name{

    if (dic[key]&&[dic[key] isKindOfClass:[NSArray class]]) {
        
        NSArray *array = dic[key];
        NSMutableArray * modelMuarray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          
            id model = [NSClassFromString(name) yy_modelWithDictionary:obj];
            
            [modelMuarray addObject:model];
        
        }];
        
        return modelMuarray;
    }


    return nil;

}
@end
@implementation NSDictionary (Model)
-(id)keyForvalue:(id)value{
   __block id objectEightId;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key = %@ and obj = %@", key, obj);
        if ([obj isEqualToString: value]) {
            objectEightId = key;
            
        }
    }];
    return objectEightId;
}
@end
