//
//  MBAdvert.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/7/16.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBModel.h"

@interface MBAdvert : MBModel
@property (copy,nonatomic) NSString *ad_code;
@property (copy,nonatomic) NSString *ad_link;
@property (copy,nonatomic) NSString *title;
@end
