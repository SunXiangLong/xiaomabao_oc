//
//  MBLovelyBabyModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/7.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 我的状态
 
 - readyToPregnantBaby: 我在备孕中
 - isPregnantBaby: 我在怀孕中
 - theBabyIsBorn: 宝宝已出生
 */
typedef NS_OPTIONS(NSUInteger, MBStateOfTheBaby) {
    
    readyToPregnantBaby                 = 0,
    isPregnantBaby                      = 1,
    theBabyIsBorn                       = 2,
    
};
@interface MBToolkitDetailModel : NSObject
@property (nonatomic, copy) NSString *t2;

@property (nonatomic, copy) NSString *t1;

@end
@interface MBMyToolModel : NSObject
@property (nonatomic, copy) NSURL *toolkit_url;

@property (nonatomic, copy) NSString *toolkit_remind_time;

@property (nonatomic, copy) NSString *toolkit_name;

@property (nonatomic, copy) NSURL *toolkit_icon;

@property (nonatomic, strong) NSArray<MBToolkitDetailModel *> *toolkit_detail;

@property (nonatomic, copy) NSString *toolkit_desc;

@end
@interface MBRecommendPostsModel : NSObject
@property (nonatomic, copy) NSString *post_content;

@property (nonatomic, copy) NSString *view_cnt;

@property (nonatomic, copy) NSString *post_id;

@property (nonatomic, copy) NSString *post_title;

@property (nonatomic, copy) NSString *reply_cnt;

@property (nonatomic, strong) NSArray *post_imgs;
@end
@interface MBRecommendTopicsModel : NSObject
@property (nonatomic, copy) NSString *ad_name;

@property (nonatomic, copy) NSString *ad_type;

@property (nonatomic, copy) NSURL *ad_img;

@property (nonatomic, copy) NSString *act_id;


@end

@interface MBDayInfoModel : NSObject
@property (nonatomic, strong) NSString *baby_weight;

@property (nonatomic, strong) NSString *baby_length;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSURL    *images;

@property (nonatomic, strong) NSString *content_type;

@property (nonatomic, strong) NSString *overdue_daynum;

@property (nonatomic, strong) NSString *day_num;

@property (nonatomic, assign) MBStateOfTheBaby stateBabyType;
@end
@interface MBRemindModel : NSObject

@property (nonatomic, copy) NSURL *url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *content_type;

@property (nonatomic, copy) NSURL *icon;


@end
@interface MBRecommend_goodsModel : NSObject

@property (nonatomic, copy) NSURL *goods_thumb;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *market_price;

@property (nonatomic, copy) NSString *goods_price;

@property (nonatomic, copy) NSString *goods_name;
@end
@interface MBLovelyBabyModel : NSObject

@property (nonatomic, assign) MBStateOfTheBaby stateBabyType;


@property (nonatomic, strong) NSArray<MBRemindModel *> *remind;
@property (nonatomic, strong) NSArray<MBMyToolModel *> *toolArr;
@property (nonatomic, strong) NSArray<MBRecommendTopicsModel *> *recommend_topics;

@property (nonatomic, strong) MBDayInfoModel *day_info;

@property (nonatomic, copy) NSDate *startDate;

@property (nonatomic, strong) NSArray<MBRecommendPostsModel *> *recommend_goods;

@property (nonatomic, copy) NSDate *currentDate;

@property (nonatomic, strong) NSArray<MBRecommend_goodsModel *> *recommend_posts;

@property (nonatomic, copy) NSDate *endDate;

@property (nonatomic, assign) BOOL isHiddenTool;

@end
