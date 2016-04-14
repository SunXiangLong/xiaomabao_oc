//
//  RightChatVoiceTableViewCell.m
//  CustomerServerSDK2
//
//  Created by zhangwei on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerVoiceRightTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XNVoiceMessage.h"
#import "XNUtilityHelper.h"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

@interface NTalkerVoiceRightTableViewCell()
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}

@property (nonatomic, strong) NSMutableArray *sendFailedArray;

@end

@implementation NTalkerVoiceRightTableViewCell
@synthesize headIcon;
@synthesize tapControl;
//@synthesize contentBg;
@synthesize timeLabel;
@synthesize longLabel;
@synthesize tipView;
@synthesize indicatorView;
@synthesize contentImage;
@synthesize failedBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.sendFailedArray = [[NSMutableArray alloc] init];
        
        autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
        autoSizeScaleY=kFWFullScreenHeight>480?kFWFullScreenHeight/568:1.0;
        iphone6P=CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
        iphone6=CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
        
        // Initialization code
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120*autoSizeScaleX, 28*autoSizeScaleY, 80*autoSizeScaleX, 13*autoSizeScaleY)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextColor:ntalker_textColor2];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [timeLabel setFont:[UIFont systemFontOfSize:11*autoSizeScaleY]];
        [self addSubview:timeLabel];
        
        _lineView1=[[UIView alloc] initWithFrame:CGRectMake(30*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [_lineView1 setBackgroundColor:chatItemTimeLine];
        _lineView1.hidden=YES;
        [self addSubview:_lineView1];
        
        _lineView2=[[UIView alloc] initWithFrame:CGRectMake(200*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [_lineView2 setBackgroundColor:chatItemTimeLine];
        _lineView2.hidden=YES;
        [self addSubview:_lineView2];
        
        headIcon = [[UIImageView alloc] init];
        headIcon.layer.masksToBounds=YES;
        headIcon.layer.cornerRadius=5.0;
        [self addSubview:headIcon];
        
        //        contentBg = [[UIImageView alloc] init];
        //        [self addSubview:contentBg];
        
        tapControl = [[UIButton alloc] init];
        [self addSubview:tapControl];
        
        contentImage = [[UIImageView alloc] init];
        [tapControl addSubview:contentImage];
        
        longLabel = [[UILabel alloc] init];
        [longLabel setBackgroundColor:[UIColor clearColor]];
        [longLabel setTextColor:ntalker_textColor];
        [longLabel setFont:[UIFont systemFontOfSize:11.0*autoSizeScaleY]];
        [self addSubview:longLabel];
        
        tipView = [[UIView alloc] initWithFrame:CGRectMake(52*autoSizeScaleX, 32*autoSizeScaleY, 8*autoSizeScaleX, 8*autoSizeScaleX)];
        tipView.layer.cornerRadius = 4*autoSizeScaleX;
        tipView.layer.masksToBounds = YES;
        [tipView setBackgroundColor:[UIColor redColor]];
        [self addSubview:tipView];
        
        indicatorView = [[UIActivityIndicatorView alloc] init];
        indicatorView.color = ntalker_textColor;
        [self addSubview:indicatorView];
        
        failedBtn = [[UIButton alloc] init];
        [failedBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_msg_failed.png"] forState:UIControlStateNormal];
        [failedBtn addTarget:self action:@selector(resendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:failedBtn];
    }
    return self;
}
- (void)setChatVoiceMessageCell:(XNBaseMessage *)dto  hidden:(BOOL)hide{
    //    NSLog(@"打印了：dto.msgStatus isEqualToString:%@",dto.msgStatus);
    timeLabel.text = [XNUtilityHelper getFormatTimeString:[NSString stringWithFormat:@"%lld",dto.msgtime]];
    timeLabel.hidden=hide;
    _lineView1.hidden=hide;
    _lineView2.hidden=hide;
    float offHeight=hide?0:40;
    XNVoiceMessage *voiceMessage = (XNVoiceMessage *)dto;//修改
    //0708
    //    longLabel.text = [NSString stringWithFormat:@"%@''",voiceMessage.sound_length];//注意
    
    if (dto.msgType == 6) {
        [headIcon setFrame:CGRectMake(kFWFullScreenWidth - 45 - 10, (15+offHeight)*autoSizeScaleY, 45, 45)];
        [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_FK_icon.png"]];
        
        float length=75;
        if (voiceMessage.voiceLength <5) {
            length=75;//注意
        } else {
            //注意
            length=75+(voiceMessage.voiceLength -5)*2;
        }
        
        UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_right.png"];
        UIImage *contentBgImageS = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_right_selected.png"];
        
        [contentImage setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_sound0.png"]];//0702
//        [contentImage setFrame:CGRectMake(219*autoSizeScaleX, (37+offHeight), 16, 16)];
        
        [tapControl setBackgroundImage:[contentBgImage stretchableImageWithLeftCapWidth:17 topCapHeight:33] forState:UIControlStateNormal];//12 18
        [tapControl setBackgroundImage:[contentBgImageS stretchableImageWithLeftCapWidth:17 topCapHeight:33] forState:UIControlStateHighlighted];//20  26
        [tapControl setFrame:CGRectMake(kFWFullScreenWidth - 45 - 10 - 10 -length, (15+offHeight)*autoSizeScaleY, length, 45)];
        
        contentImage.frame = CGRectMake((CGRectGetWidth(tapControl.frame) - 16 - 10), (CGRectGetHeight(tapControl.frame) - 16)/2, 16, 16);
        
        tipView.hidden = YES;
        indicatorView.hidden=YES;
        failedBtn.hidden=YES;
        longLabel.hidden = YES;
        //注意||[dto.msgStatus isEqualToString:@"sended"]
        if (dto.sendStatus == SS_SENDSUCCESS || dto.sendStatus == SS_RECEIVESUCCESS) {
            //
            [indicatorView stopAnimating];
            longLabel.hidden=NO;
            longLabel.text = [NSString stringWithFormat:@"%ld''",(long)voiceMessage.voiceLength];//注意
            [longLabel sizeToFit];
            CGRect longFrame = longLabel.frame;
            longFrame.origin.x = CGRectGetMinX(tapControl.frame)-longFrame.size.width-3;
            longFrame.origin.y = (31+offHeight)*autoSizeScaleY;
            [longLabel setFrame:longFrame];
            //send--->unsend
        } else if(dto.sendStatus == SS_SENDING || dto.sendStatus == SS_TOSEND){
            //             NSLog(@"打印了：dto.msgStatus isEqualToString:%@",dto.msgStatus);
            //正在发送
            indicatorView.hidden=NO;
            [indicatorView setFrame:CGRectMake(CGRectGetMinX(tapControl.frame)-25*autoSizeScaleX, (25+offHeight)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
            [indicatorView startAnimating];
            [self.sendFailedArray removeObject:dto];
        }
        else if (dto.sendStatus == SS_SENDFAILED){
            [indicatorView stopAnimating];
            indicatorView.hidden=YES;//(offHeight+10)*autoSizeScaleY+contentSize.height
            [failedBtn setFrame:CGRectMake(CGRectGetMinX(tapControl.frame)-25 - 3, (25+offHeight)*autoSizeScaleY, 25, 25)];
            failedBtn.hidden=NO;
            [self.sendFailedArray addObject:dto];
            failedBtn.tag = [[dto.msgid substringWithRange:NSMakeRange(5, dto.msgid.length - 6)] integerValue];
        }
    }
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth, (61+offHeight)*autoSizeScaleY)];
}

- (void)resendMessage:(UIButton *)sender
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(resendVoiceMsg:)]) {
        return;
    }
    
    XNVoiceMessage *textMessage = nil;
    for (XNVoiceMessage *message in _sendFailedArray) {
        if ([message isKindOfClass:[XNVoiceMessage class]]) {
            
            if (!message.msgid.length) continue;
            
            NSInteger msgIdTag = [[message.msgid substringWithRange:NSMakeRange(5, message.msgid.length - 6)] integerValue];
            if (sender.tag == msgIdTag) {
                textMessage = message;
                break;
            }
        }
    }
    
    if (!textMessage) {
        return;
    }
    
    [self.delegate resendVoiceMsg:textMessage];
}

- (void)dealloc
{
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
