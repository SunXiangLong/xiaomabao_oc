//
//  ASResponseStatus.h
//  ASPlayerTest
//
//  Created by Steven on 2017/6/13.
//  Copyright © 2017年 Ablesky. All rights reserved.
//

#ifndef ASResponseStatus_h
#define ASResponseStatus_h

typedef NS_ENUM(NSInteger, ResponseState)  //登录返回状态码
{
    responseType_success = 0,              //操作成功
    responseType_failed  ,                 //操作失败
    responseType_outtime                   //操作超时
    
};

typedef enum {
    RESULT_NULL = 1001,     //返回结果为空
    CONN_TIMEOUT,    //连接超时
    CONN_EXCEPTON,    //检测网络异常
    URL_BAD,          //请求的 URL 错误
    URL_NULL,         //请求的 URL 为空
    API_PARAMS_ERROR, //API 请求的参数错误
    
    
    CODE_RESULT_OK = 2000,    //返回正确
    CODE_ERROR,
    CODE_ERROR_JSON,   //JSON格式错误
    
    CODE_REG_FAILED,
    CODE_REG_EXIST_USER,
    CODE_REG_EXIST_MAIL,
    
    CODE_AUTHOR_FAILED,
    CODE_PATH_FAILED,
    CODE_NOT_COURSE,
    
    CODE_CONVERT_DOING,               //正在转码
    CODE_CONVERT_ERROR,
    CODE_CONVERT_FAILED,             //转码失败
    CODE_IOS_BLOCK,                  //移动开关是否关闭
    CODE_LOGOUT,                     //未登录或被踢出
    CODE_NOTAUTHOR,                  //没有权限
    CODE_IS_EXIST,                  //课件已下载
    CODE_NOT_EXIST,                 //课件不存在
    CODE_NEEDPAY,                   //付费课程（不能观看的原因是，此课程是收费课程，用户需要购买）
    CODE_COURSE_OVERDUE,            //已购课程过期
    CODE_CLASS_OVERDUE              //班级过期，导致班级内的课程全部过期
    
}ASResultCode;

typedef void (^PlayerRequestCompleteBlock) (ASResultCode code, id result);


#endif /* ASResponseStatus_h */
