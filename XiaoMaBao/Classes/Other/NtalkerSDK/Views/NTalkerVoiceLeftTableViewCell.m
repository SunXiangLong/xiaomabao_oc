//
//  NSVoiceLeftTableViewCell.m
//  CustomerServerSDK2
//
//  Created by zhangwei on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerVoiceLeftTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XNVoiceMessage.h"
#import "XNUtilityHelper.h"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

@interface NTalkerVoiceLeftTableViewCell()
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}
@end

@implementation NTalkerVoiceLeftTableViewCell
@synthesize headIcon;
@synthesize tapControl;
//@synthesize contentBg;
@synthesize timeLabel;
@synthesize longLabel;
@synthesize tipView;
@synthesize indicatorView;
@synthesize contentImage;
//@synthesize failedBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
        [self addSubview:contentImage];
        
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
        
        //        failedBtn = [[UIButton alloc] init];
        //        failedBtn.userInteractionEnabled=NO;
        //        [failedBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_msg_failed.png"] forState:UIControlStateNormal];
        //        [self addSubview:failedBtn];
    }
    return self;
}
- (void)setChatVoiceMessageCell:(XNBaseMessage *)dto  hidden:(BOOL)hide{
    timeLabel.text = [XNUtilityHelper getFormatTimeString:[NSString stringWithFormat:@"%lld",dto.msgtime]];
    timeLabel.hidden=hide;
    _lineView1.hidden=hide;
    _lineView2.hidden=hide;
    float offHeight=hide?0:40;
    //    NSTextChatMessage *voiceMessage = dto.messageBody;/下移
    //注意
    //    if (dto.type == 6) {
    //        NSTextChatMessage *voiceMessage = dto.messageBody;//
    XNVoiceMessage *voiceMessage = (XNVoiceMessage *)dto;//
    //当前客服
    [headIcon setFrame:CGRectMake(10, (15+offHeight)*autoSizeScaleY, 45, 45)];
    [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
    if (dto.usericon && ![dto.usericon isEqualToString:@""]) {
        NSString *headImageUrl =[dto.usericon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [headIcon sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
    }
    
    float length=75;
    
    if (voiceMessage.voiceLength <5) {
        length=75;//注意
    } else {
        length=75+(voiceMessage.voiceLength-5)*2;//注意
    }
    
    UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left.png"];
    UIImage *contentBgImageS = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left_selected.png"];
    
    //        [contentImage setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_left_sound0.png"]];
    contentImage.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_left_sound0.png"];
    
    [tapControl setBackgroundImage:[contentBgImage stretchableImageWithLeftCapWidth:22 topCapHeight:16] forState:UIControlStateNormal];//18 20
    [tapControl setBackgroundImage:[contentBgImageS stretchableImageWithLeftCapWidth:22 topCapHeight:16] forState:UIControlStateHighlighted];//20 26
    [tapControl setFrame:CGRectMake(65, (15+offHeight)*autoSizeScaleY, length*autoSizeScaleX, 45)];
    
    contentImage.frame = CGRectMake(CGRectGetMinX(tapControl.frame) + 10,CGRectGetMinY(tapControl.frame) + (CGRectGetHeight(tapControl.frame) - 16.0)/2.0, 16, 16);
    
    [tipView setFrame:CGRectMake((65+length), (12+offHeight)*autoSizeScaleY, 8*autoSizeScaleX, 8*autoSizeScaleX)];
    tipView.hidden = [[NSString stringWithFormat:@"%lu",dto.sendStatus] boolValue];
    
    longLabel.text = [NSString stringWithFormat:@"%ld''",voiceMessage.voiceLength];//注意
    //          longLabel.text = [NSString stringWithFormat:@"%@''",voiceMessage.text_add];
    longLabel.hidden = NO;
    [longLabel sizeToFit];
    CGRect longFrame = longLabel.frame;
    longFrame.origin.x = (68+length)*autoSizeScaleX;
    longFrame.origin.y = (31+offHeight)*autoSizeScaleY;
    [longLabel setFrame:longFrame];
    
    indicatorView.hidden=YES;
    //    }
    
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth, (61+offHeight)*autoSizeScaleY)];
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
