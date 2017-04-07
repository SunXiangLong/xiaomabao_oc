//
//  MBGoodsCollectionModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/4/5.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBGoodsCollectionModel.h"

@implementation MBGoodsCollectionModel
-(NSMutableArray<MBGoodsModel *> *)dataModel{
    if (!_dataModel) {
        _dataModel  = [NSMutableArray array];
    }
    return _dataModel;
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    [self.dataModel addObjectsFromArray: [NSArray modelDictionary:dic modelKey:@"data" modelClassName:@"MBGoodsModel"]];
    return YES;
}
@end
