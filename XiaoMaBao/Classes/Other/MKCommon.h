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
    static NSString *BASE_URL =        @"http://api.xiaomabao.com/mobile/?url=/";
    static NSString *BASE_URL_root =   @"http://api.xiaomabao.com";
    static NSString *BASE_PHP_test =   @"http://api.xiaomabao.com/babyInfo/inforecord";
//




/***  军哥后台 */
//   static NSString *BASE_URL =      @"http://172.16.1.122/mobile/?url=/";
//   static NSString *BASE_URL_root = @"http://172.16.1.122";
//   static NSString *BASE_URL_ROOT = @"http://172.16.1.122/";
//   static NSString *BASE_PHP =      @"http://172.16.1.122/discovery";
//   static NSString *BASE_PHP_test = @"http://172.16.1.122/babyinfo/inforecord";

/***  辉哥后台 */
//static NSString  *BASE_PHP =       @"http://192.168.1.189/discovery";
//static NSString  *BASE_URL_ROOT =  @"http://192.168.1.189/";
//static NSString *BASE_URL =        @"http://192.168.1.189/mobile/?url=/";
//static NSString *BASE_URL_root =   @"http://192.168.1.189";
//static NSString *BASE_PHP_test =   @"http://192.168.1.189/babyInfo/inforecord";




#define NOTIFICATION_TIME_CELL  @"NotificationTimeCell"
#endif

#define DEBUG_LOG 1
/** Log*/
#if DEBUG_LOG
#define MKLOG(fmt, ...) NSLog((@"[LOG] " fmt), ##__VA_ARGS__);
#else
#define MKLOG(fmt, ...)
#endif


/***** 云客服APPKEY和客服id */
#define UNICALL_APPKEY  @"985DC5D9-E6A2-4B82-8673-404B47CC4A19"
#define UNICALL_TENANID  @"xiaomabao.yunkefu.com"
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
#define RPM_TO_PULEES 11718.75L
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
#define VERSION @"2.9"
/**
 *  宽度与高度
 */

#define UISCREEN_Bounds [UIScreen mainScreen].bounds
#define UISCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define UISCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define UISCREEN_KeyWindow [UIApplication sharedApplication].keyWindow
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
/**
 *  把当前视图控制器的self在block回调里的强饮用变成弱引用（避免循环引用）
 *
 *  @param weakSelf 当前视图控制器
 *
 *  @return 弱应用的视图控制器
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
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



// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)


#define RECT_CHANGE_x(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_height(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)     CGRectMake(X(v), Y(v), w, h)

#pragma mark - Funtion Method (宏 方法)

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define kImg(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

#define V_IMAGE(imgName) [UIImage imageNamed:imgName]


#define URL(url) [NSURL URLWithString:url]
#define string(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2]
#define s_str(str1) [NSString stringWithFormat:@"%@",str1]
#define s_Num(num1) [NSString stringWithFormat:@"%d",num1]
#define s_Integer(num1) [NSString stringWithFormat:@"%ld",num1]


// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


/***  微软雅黑 *****/
#define YC_YAHEI_FONT(FONTSIZE) [UIFont fontWithName:@"MicrosoftYaHei" size:(FONTSIZE)]

/***  英文和数字 *****/
#define YC_ENGLISH_FONT(FONTSIZE) [UIFont fontWithName:@"Helvetica Light" size:(FONTSIZE)]
/***  造字工房字体悦圆常规体 *****/
#define YC_RTWSYueRoud_FONT(FONTSIZE) [UIFont fontWithName:@"RTWSYueRoudGoG0v1-Regular" size:(FONTSIZE)]
// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define UIcolor(string)  [UIColor colorWithHexString:string] 
//number转String
#define IntTranslateStr(int_str) [NSString stringWithFormat:@"%d",int_str];
#define FloatTranslateStr(float_str) [NSString stringWithFormat:@"%.2d",float_str];

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#endif
