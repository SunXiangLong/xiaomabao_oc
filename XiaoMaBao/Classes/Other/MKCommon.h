//
//  MKCommon.h
//  MakeBolo
//
//  Created by 张磊 on 14-11-29.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#ifndef MakeBolo_MKCommon_h
#define MakeBolo_MKCommon_h

#define IS_TEST 0
//  服务器地址
#if IS_TEST
    static NSString *BASE_URL_ROOT = @"http://115.29.250.136:8087/";
    static NSString *BASE_URL = @"http://115.29.250.136:8087/mobile/?url=/";
    static NSString *BASE_URL_QUANZI = @"http://115.29.250.136:8088/mobile/?url=/";
#else
/***  线上后台 */
    static NSString  *BASE_PHP =       @"http://api.xiaomabao.com/discovery";
    static NSString  *BASE_URL_ROOT =  @"http://api.xiaomabao.com/";
    static NSString *BASE_URL =       @"http://api.xiaomabao.com/mobile/?url=/";
    static NSString *BASE_URL_root =  @"http://api.xiaomabao.com";
    static NSString *BASE_PHP_test =  @"http://api.xiaomabao.com/babyInfo/inforecord";
   static NSString *BASE_URL_SHERVICE = @"http://api.xiaomabao.com/";
/***  军哥后台 */
//   static NSString *BASE_URL =      @"http://172.16.1.122/mobile/?url=/";
//   static NSString *BASE_URL_root = @"http://172.16.1.122";
//   static NSString *BASE_URL_ROOT = @"http://172.16.1.122/";
//   static NSString *BASE_PHP =      @"http://172.16.1.122/discovery";
//   static NSString *BASE_PHP_test = @"http://172.16.1.122/babyinfo/inforecord";

/***  辉哥后台 */
//     static NSString *BASE_URL = @"http://123.57.173.254/mobile/?url=/";
//     static NSString *BASE_URL = @"http://172.16.1.182/mobile/mobile/?url=/";
    static NSString *BASE_URL_QUANZI = @"http://115.29.250.136:8088/mobile/?url=/";
//     static NSString *BASE_URL_SHARE = @"http://172.16.1.182/mobile/index.php/Discovery";
//      static NSString *BASE_URL_SHERVICE = @"http://172.16.1.182/mobile/index.php/";
//     static NSString *BASE_PHP =       @"http://172.16.1.182/Discovery";

//    #define BASE_URL @"http://121.41.129.109"

#define NOTIFICATION_TIME_CELL  @"NotificationTimeCell"
#endif

#define DEBUG_LOG 1
/** Log*/
#if DEBUG_LOG
#define MKLOG(fmt, ...) NSLog((@"[LOG] " fmt), ##__VA_ARGS__);
#else
#define MKLOG(fmt, ...)
#endif

/*****  友盟ios－－APPKEY */
#define UMENG_APPKEY @"561f3d13e0f55ae1c60026cf"
/** 所有的Font */
/** 首页Cell的Font*/
#define MKFontHomeContent [UIFont systemFontOfSize:14]
#define MKFontHomeTime [UIFont systemFontOfSize:15]
#define MKFontHomePicNumber [UIFont systemFontOfSize:35]

/*
 所有 界面 背景色
 */
#define BACKColor [UIColor colorWithHexString:@"ecedf1"]
#define BG_COLOR [UIColor colorWithHexString:@"d7d7d7"]
#define NavBar_Color [UIColor colorWithHexString:@"d66263"]
#define LINE_COLOR [UIColor colorWithHexString:@"e2e2e2"]
#define TEXT_COLOR [UIColor whiteColor]
#define iOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS_8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f)
#define iOS_9 ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
/**
 *  默认占为图
 */
#define PLACEHOLDER_DEFAULT_IMG [UIImage imageNamed:@"placeholder_num2"]
#define VERSION @"2.2"
/**
 *  宽度与高度
 */
#define UISCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define UISCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define NAV_H 44
#define TOP_Y (iOS_7 ? 64 : NAV_H)
#define TOP_TABLE_VIEW_H ((iOS_7 ? 64 : NAV_H) + NAV_H)

#define NAV_BAR_HEIGHT 44
#define NAV_BAR_Y 20
#define NAV_BAR_W 55
/**
 *  间距
 */
#define WIDTH_5 5
#define WIDTH_8 8
#define WIDTH_20 20
#define WIDTH_10 10

#define MARGIN_5 WIDTH_5
#define MARGIN_8 WIDTH_8
#define MARGIN_10 WIDTH_10
#define MARGIN_20 WIDTH_20

#define HEIGHT_5 WIDTH_5
#define HEIGHT_10 WIDTH_10
#define HEIGHT_20 WIDTH_20
#define HEIGHT_44 NAV_H

#define APPLICATION ([UIApplication sharedApplication])
#define WINDOW ([[UIApplication sharedApplication].windows lastObject])

#define PX_ONE (1 / [UIScreen mainScreen].scale)
//麻包圈菜单栏和广告位高度
#define lunboHeight  33*UISCREEN_WIDTH/75
#define XWCatergoryViewHeight 40
//随机色
#define MBColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

#ifdef DEBUG
#define XBLog(...) NSLog(__VA_ARGS__)
#else
#define XBLog(...)
#endif
/**
 *  用户沙盒信息
 */
#define USERINFO_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject]  stringByAppendingPathComponent:@"user.info"]
#define User_Defaults  [NSUserDefaults standardUserDefaults]
typedef void(^successBlock)(id successObj);
typedef void(^failureBlock)(NSError *error);

#endif
