//
//  MBPostDetailsOneCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPostDetailsOneCell : UITableViewCell
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@property (nonatomic,strong) NSArray *imagUrlStrArray;
@end
