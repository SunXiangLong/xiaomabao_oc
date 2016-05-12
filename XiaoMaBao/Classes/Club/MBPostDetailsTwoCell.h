//
//  MBPostDetailsTwoCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPostDetailsTwoCell : UITableViewCell

@property (nonatomic, strong) RACSubject *myCircleViewSubject;
@property (nonatomic,strong) NSArray *imagUrlStrArray;
@property (weak, nonatomic) IBOutlet UIImageView *user_head;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *comment_time;
@property (weak, nonatomic) IBOutlet UILabel *comment_floor;

@property (weak, nonatomic) IBOutlet UILabel *comment_content;
@property (weak, nonatomic) IBOutlet UIImageView *user_head_user_head;
@property (weak, nonatomic) IBOutlet UILabel *comment_reply_comment_content;
@property (weak, nonatomic) IBOutlet UILabel *comment_reply_user_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comment_reply_height;
@property (nonatomic, strong)NSIndexPath *rootIndexPath;
/**
 *  存放cell高度的数组
 */
@property (copy, nonatomic) NSArray *heightArray;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@end
