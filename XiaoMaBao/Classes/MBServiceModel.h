//
//  MBServiceModel.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ServiceProductsModel : NSObject
@property (nonatomic, strong) NSString * product_id;
@property (nonatomic, strong) NSURL    * product_img;
@property (nonatomic, strong) NSString * product_name;
@property (nonatomic, strong) NSString * product_shop_price;
@property (nonatomic, strong) NSString * product_market_price;
@end
@interface ServiceCategoryModel : NSObject
@property (nonatomic, strong) NSString * cat_id;
@property (nonatomic, strong) NSString * cat_name;
@property (nonatomic, strong) NSURL * cat_icon;
@end
@interface ServiceShopModel : NSObject
@property (nonatomic, strong) NSString * shop_id;
@property (nonatomic, strong) NSURL * shop_logo;
@property (nonatomic, strong) NSString * shop_name;
@property (nonatomic, strong) NSString * shop_nearby_subway;
@property (nonatomic, strong) NSString * shop_city;
@property (nonatomic, assign) NSInteger  shop_products_num;
@property (nonatomic, assign) BOOL isMoreService;

@property (nonatomic, copy) NSArray<ServiceProductsModel *> * productArray;
@end

@interface MBServiceModel : NSObject
@property (nonatomic, copy) NSMutableArray <ServiceShopModel *> * shopsArray;
@property (nonatomic, copy) NSArray<ServiceCategoryModel *> * categoryArray;
@end
