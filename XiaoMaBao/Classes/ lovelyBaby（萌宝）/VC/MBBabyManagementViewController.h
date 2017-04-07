//
//  MBBabyManagementViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
typedef void(^Block)(NSIndexPath *indexPath);
@interface MBBabyManagementViewController : BkBaseViewController
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSArray  *photoArray;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *addtime;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic, copy) Block block;
@property (nonatomic,strong) id image;

@end
