//
//  MBNetworking.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/7/17.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBModel.h"

@class NSURLSessionDataTask;

@interface MBNetworking : NSObject
/**
 *  post  请求数据  获取数据经过MBModel对象封装，
 *
 *  @param URLString  服务器地址
 *  @param parameters 参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *operation, MBModel *responseObject))success failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;
/**
 *  post  请求数据  获取数据不经过MBModel对象封装，
 *
 *  @param URLString  服务器地址
 *  @param parameters 参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)POSTOrigin:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;
/**
 *  post 上传图片
 *
 *  @param URLString      服务器地址
 *  @param parameters     参数
 *  @param block          上传回调
 *  @param uploadProgress 上传进度
 *  @param success        上传成功的回调
 *  @param failure        上传失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(void(^)(NSProgress *progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 *  get  请求获取数据 获取数据经过MBModel对象封装
 *
 *  @param URLString  服务器地址
 *  @param parameters 参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *operation, MBModel *responseObject))success failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;
/**
 *  get  请求获取数据 获取数据不经过MBModel对象封装
 *
 *  @param URLString  服务器地址
 *  @param parameters 参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)newGET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id responseObject))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
