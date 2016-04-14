//
//  NSTextRightTableViewCell.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerTextRightTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XNTextMessage.h"
#import "XNUtilityHelper.h"

#define SpecalString     @"baidu"
#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

@interface NTalkerTextRightTableViewCell()<MLEmojiLabelDelegate>
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}

@property (nonatomic, strong) NSMutableArray *sendFailedArray;

@end



@implementation NTalkerTextRightTableViewCell
@synthesize failedBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.sendFailedArray = [[NSMutableArray alloc] init];
        
        autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
        autoSizeScaleY=kFWFullScreenHeight>480?kFWFullScreenHeight/568:1.0;
        iphone6P=CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
        iphone6=CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120*autoSizeScaleX, 28*autoSizeScaleY, 80*autoSizeScaleX, 13*autoSizeScaleY)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextColor:ntalker_textColor2];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [timeLabel setFont:[UIFont systemFontOfSize:11*autoSizeScaleY]];
        [self addSubview:timeLabel];
        
        lineView1=[[UIView alloc] initWithFrame:CGRectMake(30*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [lineView1 setBackgroundColor:chatItemTimeLine];
        lineView1.hidden=YES;
        [self addSubview:lineView1];
        
        lineView2=[[UIView alloc] initWithFrame:CGRectMake(200*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [lineView2 setBackgroundColor:chatItemTimeLine];
        lineView2.hidden=YES;
        [self addSubview:lineView2];
        
        headIcon = [[UIImageView alloc] init];
        [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_FK_icon.png"]];
        headIcon.layer.masksToBounds=YES;
        headIcon.layer.cornerRadius=5.0;
        [self addSubview:headIcon];
        
        contentBg = [[UIImageView alloc] init];
        [contentBg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentBg];
        
        emojiLabel = [MLEmojiLabel new];
        emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        emojiLabel.customEmojiPlistName = @"expressionImage_custom";
        emojiLabel.font = [UIFont systemFontOfSize:16.0];
        emojiLabel.delegate = self;
        //        textView.lineSpace=2;
        //        textView.font = [UIFont systemFontOfSize:15];
        //        [textView setTextColor:ntalker_textColor];
        [emojiLabel setBackgroundColor:[UIColor clearColor]];
        
#pragma mark - 添加手势（长按复制 点击跳转）
        UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressRightCopy:)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLink:)];
        [emojiLabel addGestureRecognizer:longpressGesture];
        [emojiLabel addGestureRecognizer:tapGesture];
        
        [self addSubview:emojiLabel];
        indicatorView = [[UIActivityIndicatorView alloc] init];
        indicatorView.color=ntalker_textColor;
        [self addSubview:indicatorView];
        
        failedBtn = [[UIButton alloc] init];
        //        failedBtn.userInteractionEnabled=NO;
        [failedBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_msg_failed.png"] forState:UIControlStateNormal];
        [failedBtn addTarget:self action:@selector(resendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:failedBtn];
        
        
#pragma mark - 修改内容开始
#pragma mark - 添加点击手势 用于取消 Button
        UITapGestureRecognizer *screenTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenButton)];
        //文本 和 其父控件 均添加手势
        [emojiLabel addGestureRecognizer:screenTapGesture];
        [emojiLabel.superview addGestureRecognizer:screenTapGesture];
        
    }
    return self;
}
- (void)longpressRightCopy:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        //        NSLog(@"长按了右边");
        float textfieldX = emojiLabel.frame.origin.x;
        float textfieldY = emojiLabel.frame.origin.y;
        float textfieldWidth = emojiLabel.frame.size.width;
        //float textfieldHeight = textView.frame.size.height;
        
        UIButton *copyBtn = [[UIButton alloc]initWithFrame:CGRectMake(textfieldX+textfieldWidth/2-30, (textfieldY-38), 60*autoSizeScaleX, 35*autoSizeScaleY)];
        [copyBtn setAlpha:1];//
        [copyBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/copy.png"] forState:UIControlStateNormal];
        [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        copyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        //        btn.contentHorizontalAlignment = UIControlContentVerticalAlignmentTop;
        //        btn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        [emojiLabel.superview addSubview:copyBtn];
        [copyBtn addTarget:self action:@selector(copyContent:) forControlEvents:UIControlEventTouchUpInside];
        //        [copyBtn becomeFirstResponder];
        //        [copyBtn setHidden:NO];
        self.publicButton = copyBtn;
        //        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenButton) userInfo:nil repeats:NO];
    }
}

- (void)copyContent:(UIButton *)sender
{
    //NSLog(@"拷贝标签");
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if ([emojiLabel.emojiText isKindOfClass:[NSAttributedString class]]) {
        NSAttributedString *attributStr = emojiLabel.emojiText;
        pasteBoard.string = attributStr.string;
    } else {
        pasteBoard.string = emojiLabel.emojiText;
    }
    [self sendSubviewToBack:sender];//
    [self.publicButton setHidden:YES];
}

- (void)hiddenButton
{
    [self.publicButton resignFirstResponder];
    [self.publicButton setHidden:YES];
}
#pragma mark - 跳转链接
//跳转链接（app内跳转与链接跳转）
- (void)tapToLink:(UITapGestureRecognizer *)sender
{
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink  error:&error];
    
    NSString *textString = emojiLabel.text;
    //  NSLog(@"131243343string:%@",string);
    //    NSString *baseUrl = @"baidu";
    NSString *baseUrl =SpecalString;
    
    if (self.publicButton.hidden == NO) {
        [self hiddenButton];
    }
    
    NSString *checkNum = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",checkNum];
    if ([predicate evaluateWithObject:emojiLabel.text]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",emojiLabel.text]]];
    }
    
    [detector enumerateMatchesInString:textString options:kNilOptions range:NSMakeRange(0, [textString length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                
                                if ([result resultType] == NSTextCheckingTypeLink) {
                                    
                                    NSString *newUrl = [NSString stringWithFormat:@"%@",result.URL];
                                    
                                    if ([newUrl rangeOfString:baseUrl].location != NSNotFound) {
                                        
                                        if (self.delegate && [self.delegate respondsToSelector:@selector(toWebViewBySuperLink:)]) {
                                            [self.delegate toWebViewBySuperLink:newUrl];
                                        }
                                    }else{
                                        
                                        if (self.delegate && [self.delegate respondsToSelector:@selector(toWebViewBySuperLink:)]) {
                                            [self.delegate toWebViewBySuperLink:newUrl];
                                        }
                                    }
                                }else{
                                    //                                    DLog(@"没有链接");
                                }
                            }];
}


- (void)setChatTextMessageInfo:(XNBaseMessage *)dto hidden:(BOOL)hide{
    timeLabel.text = [XNUtilityHelper getFormatTimeString:[NSString stringWithFormat:@"%lld",dto.msgtime]];
    timeLabel.hidden=hide;
    lineView1.hidden=hide;
    lineView2.hidden=hide;
    float offHeight=hide?0:40;
    float maxWidth=0;
    //发送text的信息
    if (dto.msgType != MSG_TYPE_TEXT) {
        return;
    }
    
    XNTextMessage *textMessage = (XNTextMessage *)dto;
    NSString *content = textMessage.textMsg;
    
    if ([content rangeOfString:@"&amp;"].location != NSNotFound) {
        content = [content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
    
    if ([content rangeOfString:@"&lt;"].location != NSNotFound) {
        content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    }
    
    if ([content rangeOfString:@"&gt;"].location != NSNotFound) {
        content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    }
    
    id obj = [self isHaveLink:textMessage.textMsg];
    
    if (obj) {
        emojiLabel.text = obj;
    } else {
        emojiLabel.text = content;
    }
    
    float width=190*autoSizeScaleX;
    if (maxWidth<190*autoSizeScaleX && maxWidth>0) {
        width = maxWidth;
    }
    //    NSMutableAttributedString *contentAttributed = [self attributedStringFromStingWithFont:[UIFont systemFontOfSize:15] withLineSpacing:2 content:textView.text];
    //    CGRect contentRect = [contentAttributed boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize contentSize = [emojiLabel preferredSizeWithMaxWidth:width];
    
    //    CGSize contentSize=rect.size;
    float addHeight=0;
    if (contentSize.height<30) {
        addHeight = 30-contentSize.height;
    }
    //当前访客
    [headIcon setFrame:CGRectMake(kFWFullScreenWidth - 45 - 10, (15+offHeight)*autoSizeScaleY, 45, 45)];
    [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_FK_icon.png"]];
    [emojiLabel setFrame:CGRectMake(kFWFullScreenWidth - 45 - 10 -(contentSize.width+27*autoSizeScaleX) - 10 + 15*(kFWFullScreenWidth/414), (21+offHeight+addHeight/2)*autoSizeScaleY, contentSize.width, contentSize.height)];
    
    //    NSLog(@"textview的高度kkkkk%f",contentSize.height);//
    //    NSLog(@"textview的高度kkkkk%f",self->textView.frame.size.height);
    UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_right.png"];
    [contentBg setImage:[contentBgImage stretchableImageWithLeftCapWidth:33 topCapHeight:29]];//12  18
    contentBg.frame = CGRectMake(kFWFullScreenWidth - 45 - 10-(contentSize.width+27*autoSizeScaleX) - 10, (15+offHeight)*autoSizeScaleY, contentSize.width+27*autoSizeScaleX, contentSize.height+(15+addHeight));
    
    //调整cell的间距
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,(contentBg.frame.size.height+16)>61?contentBg.frame.size.height+(16+offHeight)*autoSizeScaleY:(61+offHeight)*autoSizeScaleY)];
    
    //    float offHeight=lineView2.hidden?0:40;
    indicatorView.hidden=YES;
    failedBtn.hidden=YES;//0703
    
    
    if (dto.sendStatus == SS_TOSEND || dto.sendStatus == SS_SENDING) {
        [indicatorView setFrame:CGRectMake(CGRectGetMinX(contentBg.frame) - 25*autoSizeScaleX, (15+offHeight)*autoSizeScaleY+(contentSize.height+addHeight*autoSizeScaleX-5*autoSizeScaleX)/2, 25*autoSizeScaleX, 25*autoSizeScaleX)];
        [indicatorView startAnimating];
        indicatorView.hidden=NO;
        [self.sendFailedArray removeObject:dto];
    } else if (dto.sendStatus == SS_SENDFAILED){
        [indicatorView stopAnimating];
        [failedBtn setFrame:CGRectMake(CGRectGetMinX(contentBg.frame) - 25 - 3, (15+offHeight)*autoSizeScaleY+(contentSize.height+addHeight*autoSizeScaleX-5*autoSizeScaleX)/2, 25, 25)];
        failedBtn.hidden=NO;
        failedBtn.tag = [[dto.msgid substringWithRange:NSMakeRange(5, dto.msgid.length - 6)] integerValue];
        [self.sendFailedArray addObject:dto];
    } else {
        [indicatorView stopAnimating];
    }
}

- (id)isHaveLink:(NSString *)text
{
    if (!text.length) return nil;
    
    
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink  error:&error];
    
    __block id obj = nil;
    
    [detector enumerateMatchesInString:text
                               options:kNilOptions
                                 range:NSMakeRange(0, text.length)
                            usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                if (result.resultType == NSTextCheckingTypeLink) {
                                    
                                    if ([result.URL.absoluteString componentsSeparatedByString:@"//"].count > 1) {
                                        
                                        NSString *URLString = [result.URL.absoluteString componentsSeparatedByString:@"//"][1];
                                        
                                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
                                        
                                        NSRange range = [text rangeOfString:URLString];
                                        
                                        [str addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"391cd8"] range:range];
                                        obj = str;
                                    }
                                    
                                }
                            }];
    return obj;
}

-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing
                                                        content:(NSString*)content
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [content length])];
    return attributedStr;
}
- (NSString *)analaysString:(NSString *)string{
    NSString *markL = @"[";
    NSString *markR = @"]";
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:string.length+500];
    
    NSArray *_emojiArr = [NSArray arrayWithObjects:@"[wx]",@"[tx]",@"[hx]",@"[dy]",@"[ll]",@"[sj]",@"[dk]",@"[jy]",@"[zj]",@"[gg]",@"[kx]",@"[zb]",@"[yw]",@"[dn]",@"[sh]",@"[ku]",@"[fn]",@"[ws]",@"[ok]",@"[xh]",nil];
    for (int i = 0; i < string.length; i++) {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL])) {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL])) {
                for (NSString *c in stack) {
                    [newString appendString:c];
                }
                [stack removeAllObjects];
            }
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == string.length - 1)) {
                NSMutableString *emojiStr = [[NSMutableString alloc] init];
                for (NSString *c in stack) {
                    [emojiStr appendString:c];
                }
                if ([_emojiArr containsObject:emojiStr])
                {
                    [newString appendString:[NSString stringWithFormat:@" %@",emojiStr]];
                }  else  {
                    [newString appendString:emojiStr];
                }
                [stack removeAllObjects];
            }
        } else {
            [newString appendString:s];
        }
    }
    return newString;
}
- (CGRect)canculateFrame:(NSString *)content{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [content length])];
    CGRect contentRect = [attributedStr boundingRectWithSize:CGSizeMake(169*autoSizeScaleX, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return contentRect;
}

#pragma mark ======================重发消息===================

- (void)resendMessage:(UIButton *)sender
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(resendTextMsg:)]) {
        return;
    }
    
    XNTextMessage *textMessage = nil;
    for (XNTextMessage *message in _sendFailedArray) {
        if ([message isKindOfClass:[XNTextMessage class]]) {
            
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
    
    [self.delegate resendTextMsg:textMessage];
}

- (void)dealloc
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    
}

- (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    //if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(1.0)];
}

@end
