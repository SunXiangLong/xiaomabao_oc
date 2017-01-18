//
//  NSArray+Model.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Model)
// 模型转对象转换工具（配合YYModel）
+ (NSArray *)modelDictionary:(NSDictionary *)dic modelKey:(NSString *)key modelClassName:(NSString *)name;
@end
@interface NSDictionary (Model)
// 根据字典value求对呀key
- (id)keyForvalue:(id)value;
@end
