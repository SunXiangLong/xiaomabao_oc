//
//  MBGoodsModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MBGoodCommentListModel : NSObject
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * comment_rank;
@property (nonatomic, strong) NSString * create_time;
@property (nonatomic, strong) NSArray * img_path;
@end
@interface MBGoodCommentModel : NSObject
@property (nonatomic, strong) NSNumber * comment_num;
@property (nonatomic, strong) NSString * good_comment_rate;
@property (nonatomic, strong) NSMutableArray<MBGoodCommentListModel *> * commentsList;
@end
@interface MBGoodsPropertyModel : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * value;
@end
@interface MBGoodsModel : NSObject
@property (nonatomic, strong) NSString * shop_price;
@property (nonatomic, strong) NSURL    * goods_thumb;
@property (nonatomic, strong) NSString * goods_shop_pricename;
@property (nonatomic, strong) NSString * market_price;
@property (nonatomic, strong) NSString * watermark_img;
@property (nonatomic, strong) NSArray  * goods_specs;
@property (nonatomic, strong) NSString * goods_id;
@property (nonatomic, strong) NSString * goods_name;
@property (nonatomic, strong) NSString * shop_price_formatted;
@property (nonatomic, strong) NSString * market_price_formatted;
@property (nonatomic, strong) NSNumber * zhekou;
@property (nonatomic, strong) NSString * is_promote;
@property (nonatomic, strong) NSString * is_shipping;
@property (nonatomic, strong) NSString * goods_number;
@property (nonatomic, assign)  BOOL  is_collect;
@property (nonatomic, strong) NSString * active_remainder_time;
@property (nonatomic, strong) NSArray *goods_desc;
@property (nonatomic, strong) NSArray *goods_gallery;
/**商品介绍图片的宽高比 */
@property (nonatomic, copy) NSArray *imageScale;

@end

/**商品规格相关model*/
@interface MBGoodsAttrListModel : NSObject
@property (nonatomic, strong) NSString * goods_attr_price;
@property (nonatomic, strong) NSString * goods_attr_id;
@property (nonatomic, strong) NSString * goods_attr_name;
@end

@interface MBGoodsSpecsModel : NSObject
@property (nonatomic, strong) NSString * attr_id;
@property (nonatomic, strong) NSString * attr_name;
@property (nonatomic, strong) NSArray<MBGoodsAttrListModel *>  *goodsAttrList;
@end
@interface MBGoodsSpecsRootModel : NSObject
@property (nonatomic, strong)MBGoodsModel *goodsModel;
@property (nonatomic, strong) NSArray<MBGoodsSpecsModel *>  *goodsSpecs;
@end
