//
//  NSImageLeftTableViewCell.h
//  CustomerServerSDK2
//
//  Created by zhangwei on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//
#import <UIKit/UIKit.h>

@class XNBaseMessage;
@interface NTalkerImageLeftTableViewCell : UITableViewCell
{
    UILabel *timeLabel;
    UIView *lineView1;
    UIView *lineView2;
    UIActivityIndicatorView *indicatorView;
    UIImageView *contentBg;
}
@property (nonatomic, strong)UIButton *contentBtn;
@property (nonatomic, strong)UIImageView *contentImage;
@property (nonatomic, strong)UIButton *failedBtn;
@property (nonatomic, strong) UIImageView *headIcon;
- (void)setChatImageMessageInfo:(XNBaseMessage *)dto  hidden:(BOOL)hide;
@end

