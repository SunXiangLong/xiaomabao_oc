//
//  MBAffordablePlanetViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface MBAffordablePlanetViewCell : UICollectionViewCell
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) BkBaseViewController *VC;
@property (nonatomic,strong) NSString *act_name;
@property (nonatomic,strong) NSString *act_id;


@end



/** 5.24工作总结   技术部－－孙祥龙
 *  1.修复app服务详情中用户评价点击查看其他评价为空的bug
    2.完成改版购物界面实惠星球界面的UI
    3.完成改版购物界面全球闪购界面的UI
 */