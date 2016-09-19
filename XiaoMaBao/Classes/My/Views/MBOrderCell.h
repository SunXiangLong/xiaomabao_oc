//
//  MBOrderCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/17.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BkBaseViewController.h"
@interface MBOrderCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property(nonatomic,strong)NSArray *goods_listArray;
@property(nonatomic,strong)NSString *order_sn;
@property(nonatomic,strong)NSString *order_status;

@property (nonatomic,weak) BkBaseViewController *VC;
@end
