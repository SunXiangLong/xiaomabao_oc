//
//  MBBabysDiaryModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/8.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data,Result;
@interface MBBabysDiaryModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) Data *data;

@end
@interface Data : NSObject

@property (nonatomic, assign) NSInteger max_page;

@property (nonatomic, strong) NSArray<Result *> *result;

@property (nonatomic, copy) NSString *list_nums;

@property (nonatomic, assign) NSInteger page;

@end

@interface Result : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) NSArray<NSString *> *photo_thumb;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, copy) NSString *mood;

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *group;

@property (nonatomic, copy) NSString *weather;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, copy) NSString *week;

@property (nonatomic, copy) NSString *month;

@property (nonatomic, strong) NSArray<NSString *> *photo;

@property (nonatomic, copy) NSString *content;

@end


