//
//  MBBeanInfoModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBeanInfoModel.h"

@implementation MBBeanInfoModel
-(NSMutableArray<MBRecordsModel *> *)record{
    if (!_record) {
        _record  = [NSMutableArray array];
    }
    return _record;
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    [self.record addObjectsFromArray: [NSArray modelDictionary:dic modelKey:@"records" modelClassName:@"MBRecordsModel"]];
    return YES;
}
@end
@implementation MBRecordsModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    return YES;
}
@end
