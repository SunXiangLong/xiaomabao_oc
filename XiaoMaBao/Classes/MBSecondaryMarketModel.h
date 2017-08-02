//
//  MBSecondaryMarketModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class todayRecommendTopModel,secondaryMarketGoodsListModel,uinfoModel,galleryModel;
@interface MBSecondaryMarketModel : NSObject

@property (nonatomic, strong) NSArray<todayRecommendTopModel *> *today_recommend_top;

@property (nonatomic, strong) NSArray<secondaryMarketGoodsListModel *> *goods_list;

@end
@interface todayRecommendTopModel : NSObject

@property (nonatomic, copy) NSString *act_id;

@property (nonatomic, copy) NSString *ad_img;

@property (nonatomic, copy) NSString *ad_type;

@property (nonatomic, copy) NSString *act_name;

@property (nonatomic, copy) NSString *ad_name;

@property (nonatomic, copy) NSString *ad_end_time;

@property (nonatomic, copy) NSString *ad_start_time;

@property (nonatomic, copy) NSString *ad_goods_ids;

@property (nonatomic, copy) NSString *act_img;

@end

@interface secondaryMarketGoodsListModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) BOOL is_praise;

@property (nonatomic, strong) NSArray<galleryModel *> *gallery;

@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *views;

@property (nonatomic, copy) NSString *is_on_sale;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) BOOL  is_show;

@property (nonatomic, copy) NSString *praise;

@property (nonatomic, copy) NSString *cat_info;

@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *original_price;

@property (nonatomic, strong) uinfoModel *uinfo;

@end

@interface uinfoModel : NSObject

@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic, strong) NSURL *header_img;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *user_name;

@end

@interface galleryModel : NSObject

@property (nonatomic, copy) NSString *gallery_id;

@property (nonatomic, strong) NSURL *original_img;


@property (nonatomic, strong) NSURL *thumb_img;
@end

