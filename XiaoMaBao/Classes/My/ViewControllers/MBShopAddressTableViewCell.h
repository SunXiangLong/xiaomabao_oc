//
//  MBShopAddressTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@protocol MBShopAddressTableViewDelgate <NSObject>
- (void)MBShopAddressTableView;
@end
@interface MBShopAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *photo;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *is_default;
@property (nonatomic,weak) BkBaseViewController *VC;
@property (nonatomic,assign) BOOL isDefault;
@property(strong,nonatomic)NSDictionary *addressDic;
@property (nonatomic, weak) id<MBShopAddressTableViewDelgate> delagate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@end
