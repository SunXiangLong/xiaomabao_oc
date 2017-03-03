//
//  MBModel.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/7/16.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBModel : NSObject
@property (strong,nonatomic) id data;
@property (strong,nonatomic) NSDictionary *status;
@property (strong,nonatomic) NSDictionary *msg;
@property (strong,nonatomic) NSString *img;
@property (strong,nonatomic) NSString *is_black;
@end
