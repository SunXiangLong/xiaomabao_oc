//
//  MBGiveFriendsViewController.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBGiveFriendsViewController : BkBaseViewController
@property (nonatomic,strong) NSString *num;
@property (copy, nonatomic)  void (^block)();
@end