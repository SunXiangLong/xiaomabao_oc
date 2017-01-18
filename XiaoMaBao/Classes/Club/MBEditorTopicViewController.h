//
//  MBEditorTopicViewController.h
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/13.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WordPressEditor/WPEditorViewController.h>
@interface MBEditorTopicViewController : WPEditorViewController<WPEditorViewControllerDelegate>
/**
 *  回复楼主ID
 */
@property (nonatomic,strong) NSString *circle_id;
//@property (nonatomic,strong) NSString *htmlStr;
/**
 *  回复的ID
 */
@property (strong, nonatomic) NSString *comment_reply_id;
/**
 *  帖子ID
 */
@property (nonatomic,strong) NSString *post_id;

@property (nonatomic,copy) void(^releaseSuccess)();
@end
