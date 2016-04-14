//
//  MBMyItem.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/7.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBMyItem : NSObject
@property (copy,nonatomic) NSString *itemName;
@property (copy,nonatomic) NSString *itemIcon;
@property (copy,nonatomic) NSString *itemDesc;
@property (strong,nonatomic) UIViewController *vc;
@property (copy,nonatomic) NSString * isPhone;

@end
