//
//  MBShoppingCartTableViewCell.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBShoppingCartModel.h"
@protocol MBShoppingCartTableViewdelegate<NSObject>
- (void)click:(NSInteger)row;
- (void)addShop:(NSDictionary *)dic;
- (void)reduceShop:(NSDictionary *)dic;
@end
@interface MBShoppingCartTableViewCell : UITableViewCell
@property(weak,nonatomic)id<MBShoppingCartTableViewdelegate>delegate;
@property(assign,nonatomic)NSInteger row;
@property(strong,nonatomic)MBGood_ListModel * model;
@end
