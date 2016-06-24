//
//  MBAffordablePlanetNewViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface MBAffordablePlanetNewViewCell : UICollectionViewCell


@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) BkBaseViewController *VC;
@property (nonatomic,strong) NSString *act_name;
@property (nonatomic,strong) NSString *act_id;
@end
