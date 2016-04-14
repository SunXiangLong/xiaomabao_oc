//
//  UIXNChatViewController.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/3.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//


#import <UIKit/UIKit.h>

@class XNGoodsInfoModel;
@interface NTalkerChatViewController : UIViewController

@property (nonatomic, strong) NSString *settingid;//客服配置id【必填】

@property (nonatomic, assign) BOOL pushOrPresent;//进入咨询界面的方式（YES:自下向上弹出  NO:自右向左弹出）
@property (nonatomic, strong) NSString *kefuId;//请求固定的客服(不建议使用)
@property (nonatomic, strong) XNGoodsInfoModel *productInfo;//商品信息
@property (nonatomic, strong) NSString *erpParams;//erp信息
@property (nonatomic, strong) NSString *pageTitle;//咨询发起页标题
@property (nonatomic, strong) NSString *pageURLString;//咨询发起页URL;
//***************H5交互加的参数********************//
@property (nonatomic, strong) NSString *sdkKey;
@property (nonatomic, strong) NSString *flashServerUrl;
@property (nonatomic, strong) NSString *siteid;
@property (nonatomic, strong) NSString *sellerID;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *pcid;
@property (nonatomic, strong) NSString *vip;
@property (nonatomic, strong) NSString *userlevel;
@property (nonatomic, strong) NSString *isSingle;

@end
