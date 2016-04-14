//
//  NSImageRightTableViewCell.h
//  CustomerServerSDK2
//
//  Created by zhangwei on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//
#import <UIKit/UIKit.h>

@class XNImageMessage;
@protocol XNResendImageMsgDelegate <NSObject>

- (void)resendImageMsg:(XNImageMessage *)imageMessage;

@end

@class XNBaseMessage;
@interface NTalkerImageRightTableViewCell : UITableViewCell{
    UILabel *timeLabel;
    UIView *lineView1;
    UIView *lineView2;
    UIActivityIndicatorView *indicatorView;
    UIImageView *contentBg;
    UIButton *failedBtn;
}
@property (nonatomic, strong)UIButton *contentBtn;
@property (nonatomic, strong)UIImageView *contentImage;
@property (nonatomic, strong)UIButton *failedBtn;
@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, weak) id<XNResendImageMsgDelegate> delegate;
- (void)setChatImageMessageInfo:(XNBaseMessage *)dto  hidden:(BOOL)hide;
@end
