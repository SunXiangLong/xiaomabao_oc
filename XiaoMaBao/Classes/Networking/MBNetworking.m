//
//  MBNetworking.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/7/17.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBNetworking.h"
#import "MBModel.h"
#import "MJExtension.h"

static NSMutableDictionary *requestParams = nil;
static NSString *url = nil;

@implementation MBNetworking

static AFHTTPRequestOperationManager *mgr = nil;
+ (AFHTTPRequestOperationManager *)mgr{
    if (!mgr) {
        mgr = [AFHTTPRequestOperationManager manager];
    }
    return mgr;
}
//+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
//                      parameters:(id)parameters
//       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
//                         success:(void (^)(AFHTTPRequestOperation *operation, MBModel *responseObject))success
//                         progress:(void(^)(NSProgress * _Nonnull uploadProgress)Progress
//                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
//
//
//}
+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, MBModel *responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    url = URLString;
    NSDictionary *dic = @{@"version":VERSION,@"channel":@"APPStore",@"device":@"ios"};
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:parameters];
    [dict addEntriesFromDictionary:dic];
    
    requestParams = dict;
    [self logURL];
    

                             
    return [self.mgr POST:URLString parameters:requestParams constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        MBModel *model = [MBModel objectWithKeyValues:responseObject];
        success(operation,model);
    } failure:failure];
}


+ (AFHTTPRequestOperation *)POSTOrigin:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    url = URLString;
    NSDictionary *dic = @{@"version":VERSION,@"channel":@"APPStore",@"device":@"ios"};
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:parameters];
    [dict addEntriesFromDictionary:dic];
    
    requestParams = dict;
    [self logURL];
    return [self.mgr POST:URLString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:failure];
}
+ (AFHTTPRequestOperation *)POSTAPPStore:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    url = URLString;
       requestParams = parameters;
    [self logURL];
    return [self.mgr POST:URLString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:failure];

}
+ (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, MBModel *responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    url = URLString;
    NSDictionary *dic = @{@"version":VERSION,@"channel":@"APPStore",@"device":@"ios"};
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:parameters];
    [dict addEntriesFromDictionary:dic];
    
    requestParams = dict;
    
    [self logURL];
    
    
    
    return [self.mgr POST:URLString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//   NSLog(@"%@",responseObject);
        
        
        MBModel *model = [MBModel objectWithKeyValues:responseObject];
        
        
        success(operation,model);
    } failure:failure];
}

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, MBModel *responseObject))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    url = URLString;
    requestParams = parameters;
    [self logURL];
    return [self.mgr GET:URLString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        MBModel *model = [MBModel objectWithKeyValues:responseObject];
        success(operation,model);
    } failure:failure];
}
+ (AFHTTPRequestOperation *)newGET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    url = URLString;
    requestParams = parameters;
    [self logURL];
    return [self.mgr GET:URLString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        success(operation,responseObject);
    } failure:failure];
}
/**
 *  测试用，显示拼接参数后的url
 */
+ (void)logURL{
    NSMutableString *getURL = [NSMutableString stringWithString:url];
    NSMutableString *paramStr = [NSMutableString stringWithString:@"?"];
    
    [requestParams enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *obj, BOOL *stop) {
        [paramStr appendString:[NSString stringWithFormat:@"%@=%@&", key, obj]];
    }];
    
    paramStr = (NSMutableString *)[paramStr substringToIndex:(paramStr.length-1)];
    
    [getURL appendString:paramStr];
    NSLog(@"完整的是：  %@", getURL);
    
    
}

@end
