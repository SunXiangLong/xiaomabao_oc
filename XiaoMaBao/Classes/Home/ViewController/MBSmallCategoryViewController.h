//
//  MBSmallCategoryViewController.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBSmallCategoryViewController : BkBaseViewController
/**
 *  首页点击 品牌列表/分类 传进来的dict
 */
@property (strong,nonatomic) NSDictionary *categoryDict;
@property (strong,nonatomic)NSMutableArray *goodsDicts;
@property (strong,nonatomic)NSMutableArray *shop_price;
@property (strong,nonatomic)NSMutableArray *shop_price_formatted;
@property (strong,nonatomic)NSMutableArray *market_price_formatted;
@property (strong,nonatomic)NSMutableArray *market_price;
@property (strong,nonatomic)NSMutableArray *promote_price;
@property (strong,nonatomic)NSMutableArray *short_name;
@property (strong,nonatomic)NSMutableArray *goods_thumb;
@property (strong,nonatomic)NSMutableArray *goods_id;
@property (strong,nonatomic)NSMutableArray *salesnum;
@property (copy,nonatomic)NSString *urlName;
@property (copy,nonatomic)NSString *act_id;
@property (copy,nonatomic)NSString *type;
@property (copy,nonatomic)NSString *act_img;
@property (copy,nonatomic)NSString *act_name;
@property (copy,nonatomic)NSString *favourable_name;
@property (copy,nonatomic)NSString *current_server_time;
@property (copy,nonatomic)NSString *end_time;
@property (copy,nonatomic)NSString *isble;

@property(copy,nonatomic)NSString *topButton;
/**
 *
 */
@property (copy,nonatomic) NSString *ID;
@property (strong,nonatomic)NSMutableArray *SearchArray;
@end
