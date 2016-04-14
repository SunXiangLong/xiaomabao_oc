//
//  MBCanulaCircleDetailsViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/4.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

typedef void(^backBlock) (NSIndexPath *indexPath);
@interface MBCanulaCircleDetailsViewController : BkBaseViewController
@property (nonatomic,strong) NSString *tid;
@property (nonatomic,copy) backBlock block;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) BOOL isdelete;
@property (nonatomic,strong) NSString *pusMessages;

@end

