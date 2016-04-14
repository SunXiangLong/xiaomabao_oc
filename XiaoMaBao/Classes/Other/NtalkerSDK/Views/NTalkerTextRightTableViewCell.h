//
//  NSTextRightTableViewCell.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@class XNTextMessage;
@protocol XNResendTextMsgDelegate <NSObject>

- (void)toWebViewBySuperLink:(NSString *)link;
- (void)resendTextMsg:(XNTextMessage *)textMessage;

@end

@class XNBaseMessage;
@interface NTalkerTextRightTableViewCell : UITableViewCell
{
    UIImageView *headIcon;
    UIImageView *contentBg;
    UILabel *timeLabel;
    UIView *lineView1;
    UIView *lineView2;
    MLEmojiLabel *emojiLabel;
    UIActivityIndicatorView *indicatorView;
    
}

@property (nonatomic, strong)UIButton *failedBtn;
@property (nonatomic, strong)UIButton *publicButton;
@property (nonatomic, weak) id<XNResendTextMsgDelegate> delegate;
- (void)setChatTextMessageInfo:(XNBaseMessage *)dto hidden:(BOOL)hide;
@end
