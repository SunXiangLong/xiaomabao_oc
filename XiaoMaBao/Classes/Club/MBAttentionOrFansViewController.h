//
//  MBAttentionOrFansViewController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"
typedef enum : NSUInteger {
    MBAttentionType = 0,
    MBFansType,

} MBAttentionOrFansType;
@interface MBAttentionOrFansViewController : BkBaseViewController
@property (nonatomic,assign) MBAttentionOrFansType type;
@property (nonatomic,strong) NSString *user_id;

@end
