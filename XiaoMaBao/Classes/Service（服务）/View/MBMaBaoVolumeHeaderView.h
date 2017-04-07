//
//  MBMaBaoVolumeHeaderView.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface MBMaBaoVolumeHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *store_image;
@property (weak, nonatomic) IBOutlet UILabel *store_name;
@property (weak, nonatomic) IBOutlet UILabel *store_adress;
@property (nonatomic,strong) NSString *shop_id;
@property (nonatomic,weak) BkBaseViewController *VC;
+ (instancetype)instanceView;
@end
