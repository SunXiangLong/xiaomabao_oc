//
//  MBInviteFriendsModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/30.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBInviteFriendsModel.h"

@implementation MBInviteFriendsModel
-(NSMutableArray<MBCounponModel *> *)counponArray{
    if (!_counponArray) {
        _counponArray  = [NSMutableArray array];
    }
    return _counponArray;
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
   [self.counponArray addObjectsFromArray: [NSArray modelDictionary:dic modelKey:@"friends" modelClassName:@"MBCounponModel"]];
    return YES;
}
@end
@implementation MBShareModel

@end
@implementation MBCounponModel

@end
