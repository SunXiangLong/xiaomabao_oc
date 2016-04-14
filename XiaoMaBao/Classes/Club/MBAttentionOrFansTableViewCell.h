//
//  MBAttentionOrFansTableViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MBAttentionOrFansTableViewdelegate<NSObject>
- (void)touxiangdianji:(NSIndexPath *)indexPath;
@end
@interface MBAttentionOrFansTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSString *is_attention;
@property (nonatomic,assign) id<MBAttentionOrFansTableViewdelegate>delegate;
@end