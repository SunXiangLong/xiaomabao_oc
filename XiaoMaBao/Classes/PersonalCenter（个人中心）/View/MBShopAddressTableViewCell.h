//
//  MBShopAddressTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBConfirmModel.h"
typedef NS_ENUM(NSInteger, MBEditTheAddressType) {
    MBModifyTheAddress = 0,
    MBDeleteTheAddress   = 1,
    MBSetTheDefaultAddress  = 2,
};
@interface MBShopAddressTableViewCell : UITableViewCell
@property(strong,nonatomic)MBConsigneeModel *model;
@property (nonatomic,copy)  void (^editAddress)(MBConsigneeModel *model,MBEditTheAddressType type);
@end
