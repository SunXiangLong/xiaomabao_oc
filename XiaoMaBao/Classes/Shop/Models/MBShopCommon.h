//
//  MBShop.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/6.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBShopCommon : NSObject
/** 作者 */
@property (copy,nonatomic) NSString *author;
/** 内容 */
@property (copy,nonatomic) NSString *content;
/** 等级 */
@property (assign,nonatomic) NSInteger level;
/** 配图 */
@property (strong,nonatomic) NSArray *figures;
/** 创建时间 */
@property (strong,nonatomic) NSString *create_time;
/** id */
@property (strong,nonatomic) NSString *authorid;
/** id */
@property (strong,nonatomic) NSString *img_path;
@end
