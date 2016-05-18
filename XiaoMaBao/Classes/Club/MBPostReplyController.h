//
//  MBPostReplyController.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "BkBaseViewController.h"

@interface MBPostReplyController : BkBaseViewController
/**
 *  回复的ID
 */
@property (strong, nonatomic) NSString *comment_reply_id;
/**
 *  帖子ID
 */
@property (nonatomic,strong) NSString *post_id;
@end
