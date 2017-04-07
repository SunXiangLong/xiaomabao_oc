//
//  MBShoppingCartCell.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBShoppingCartModel.h"
@protocol MBShoppingCartTableViewdelegate<NSObject>
- (void)click:(MBGood_ListModel *)model;
- (void)goodsNumberChange:(NSDictionary *)dic;
@end
@interface MBShoppingCartCell : UITableViewCell
@property(weak,nonatomic)id<MBShoppingCartTableViewdelegate>delegate;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(MBGood_ListModel *)model;
@property (nonatomic,strong)MBGood_ListModel *goodsModel;
@end
