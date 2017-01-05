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

static NSDictionary *requestParams = nil;
static NSString *url = nil;

@implementation MBNetworking

static AFHTTPSessionManager *mgr = nil;
+ (AFHTTPSessionManager *)mgr{
    if (!mgr) {
        mgr = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *response = [[AFJSONResponseSerializer alloc] init];
        /**
         *  删除json中  <null> 类型的字段  同时也会把key删除
         */
        response.removesKeysWithNullValues = YES;
        mgr.responseSerializer = response;
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    }
    return mgr;
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(void(^)(NSProgress *progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    url = URLString;
    
    
    requestParams = [self stitchingParameter:parameters];
    [self logURL];
    
    
    return [self.mgr POST:URLString parameters:requestParams constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:failure];
    
    
    
}


+ (NSURLSessionDataTask *)POSTOrigin:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    url = URLString;
    
    requestParams = [self stitchingParameter:parameters];
    [self logURL];
    
    return   [self.mgr POST:URLString parameters:requestParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *operation, MBModel *responseObject))success failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    url = URLString;
    requestParams = [self stitchingParameter:parameters];
    [self logURL];
   
    return   [self.mgr POST:URLString parameters:requestParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        MBModel *model = [MBModel objectWithKeyValues:responseObject];
        success(task,model);
    } failure:failure];
    
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, MBModel *responseObject))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    url = URLString;
    requestParams = [self stitchingParameter:parameters];
    [self logURL];
    
    return  [self.mgr GET:URLString parameters:requestParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MBModel *model = [MBModel objectWithKeyValues:responseObject];
        success(task,model);
    } failure:failure];
    
}

+ (NSURLSessionDataTask *)newGET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id responseObject))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    url = URLString;
    requestParams = [self stitchingParameter:parameters];
    [self logURL];
    
    return  [self.mgr GET:URLString parameters:requestParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task,responseObject);
    } failure:failure];
}
/**
 *  增加参数 version:版本号 channel:app下载来源  device:操作系统
 *
 *
 *
 *  @return 增加参数后的字典
 */
+ (NSDictionary *)stitchingParameter:(NSDictionary *)parameters{
    
    NSDictionary *dic = @{@"version":VERSION_1,@"channel":@"APPStore",@"device":@"ios"};
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:parameters];
    [dict addEntriesFromDictionary:dic];
    
    return dict;
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
    MMLog(@"完整的是：  %@", getURL);
    
    
}

@end
