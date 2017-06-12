//
//  MBNewBabyFourTableCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNewBabyFourTableCell : UITableViewCell
@property(strong,nonatomic)NSArray *dataArr;
@property (nonatomic,copy)  void (^recommendCommodities)(NSInteger row,BOOL isGoods);
@end
