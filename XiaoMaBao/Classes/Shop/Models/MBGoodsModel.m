//
//  MBGoodsModel.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBGoodsModel.h"

@implementation MBGoodsModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    
    return YES;
}
@end
@implementation MBGoodCommentListModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    _ID = dic[@"id"];
    return YES;
}
@end
@implementation MBGoodCommentModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    _commentsList = [[NSArray modelDictionary:dic modelKey:@"comments_list" modelClassName:@"MBGoodCommentListModel"] mutableCopy];
    return YES;
}


@end
@implementation MBGoodsPropertyModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    
    return YES;
}
@end
@implementation MBGoodsAttrListModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    
    return YES;
}
@end
@implementation MBGoodsSpecsModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    _goodsAttrList = [NSArray modelDictionary:dic modelKey:@"goods_attr_list" modelClassName:@"MBGoodsAttrListModel"];
    return YES;
}
@end
@implementation MBGoodsSpecsRootModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    _goodsModel = [MBGoodsModel yy_modelWithDictionary:dic];
    _goodsSpecs = [NSArray modelDictionary:dic modelKey:@"goods_specs" modelClassName:@"MBGoodsSpecsModel"];
    return YES;
}
@end
