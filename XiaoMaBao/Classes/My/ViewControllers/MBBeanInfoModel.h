//
//  MBBeanInfoModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MBRecordsModel : NSObject
@property (nonatomic,strong) NSString *record_desc;
@property (nonatomic,strong) NSString *record_time;
@property (nonatomic,strong) NSString *record_val;
@property (nonatomic,strong) NSString *record_type;

@end
@interface MBBeanInfoModel : NSObject
@property (nonatomic,strong) NSString *number;
@property (nonatomic,strong) NSMutableArray<MBRecordsModel *> *record;
@end
