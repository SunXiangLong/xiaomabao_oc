//
//  XNGoodsInfoModel.h
//  NTalkerUIKitSDK
//
//  Created by Ntalker on 15/12/14.
//  Copyright © 2015年 NTalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNGoodsInfoModel : NSObject

//商品id
@property (strong, nonatomic) NSString *goods_id;
//app端跳转的URL
@property (strong, nonatomic) NSString *goods_URL;
//商品扩展参数
@property (strong, nonatomic) NSString *itemparam;
/*
 app端展示规则
 0:不展示
 1:传goodsid方式展示
 2:webview方式:goods_showURL
 3:数据方式展示:goods_imageURL;goodsTitle;goodsPrice;
 */
@property (strong, nonatomic) NSString *appGoods_type;

@property (strong, nonatomic) NSString *goods_imageURL;
@property (strong, nonatomic) NSString *goodsTitle;
@property (strong, nonatomic) NSString *goodsPrice;

/*
 客户端展示规则
 0:不展示
 1:传goodsid方式展示
 2:传goods_showURL客服端直接展示(不推荐,此方法会影响客服端性能)
 */
@property (strong, nonatomic) NSString *clientGoods_Type;

@property (strong, nonatomic) NSString *goods_showURL;

@end
