//
//  UIXNLeaveMsgViewController.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/5/1.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTalkerLeaveMsgViewController : UIViewController
@property (nonatomic, strong) NSString *siteId;
@property (nonatomic, strong) NSString *settingId;

@property (nonatomic, copy) NSString *userName;

//责任客服
@property (nonatomic, strong) NSString *responseKefu;

//发起页标题
@property (nonatomic, strong) NSString *pageTitle;

//发起页URL
@property (nonatomic, strong) NSString *pageURLString;

@end
