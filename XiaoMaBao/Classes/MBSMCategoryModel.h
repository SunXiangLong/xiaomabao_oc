//
//  MBSMCategoryModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBSMCategoryModel,catListsModel;
@interface  MBSMCategoryDataModel: NSObject<NSCoding>
@property (nonatomic, strong) NSArray<MBSMCategoryModel *> *data;
@end
@interface  MBSMCategoryModel: NSObject<NSCoding>

@property (nonatomic, strong) NSURL *secondary_icon;

@property (nonatomic, copy) NSString *cat_name;

@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, strong) NSArray<catListsModel *> *cat_lists;

@end

@interface catListsModel : NSObject<NSCoding>

@property (nonatomic, strong) NSURL *secondary_icon;

@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, copy) NSString *cat_name;

@end

