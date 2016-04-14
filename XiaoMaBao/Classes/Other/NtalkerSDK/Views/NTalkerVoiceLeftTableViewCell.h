//
//  NSVoiceLeftTableViewCell.h
//  CustomerServerSDK2
//
//  Created by zhangwei on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//
#import <UIKit/UIKit.h>

@class XNBaseMessage;
@interface NTalkerVoiceLeftTableViewCell : UITableViewCell
@property (nonatomic, retain)UIImageView *headIcon;
@property (nonatomic, retain)UILabel *timeLabel;
@property (nonatomic, retain)UILabel *longLabel;
@property (nonatomic, retain)UIView *tipView;
@property (nonatomic, retain)UIButton *tapControl;
@property (nonatomic, retain)UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain)UIImageView *contentImage;
@property (nonatomic, retain)UIView *lineView1;
@property (nonatomic, retain)UIView *lineView2;
- (void)setChatVoiceMessageCell:(XNBaseMessage *)dto hidden:(BOOL)hide;
@end
