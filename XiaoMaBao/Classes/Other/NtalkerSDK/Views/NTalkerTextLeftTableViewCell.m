//
//  NSTextLeftTableViewCell.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerTextLeftTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XNTextMessage.h"
#import "XNUtilityHelper.h"

#define SpecalString     @"baidu"  //app内传的特殊域名跳转
#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

@interface NTalkerTextLeftTableViewCell()
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}
@end
@implementation NTalkerTextLeftTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        autoSizeScaleX=kFWFullScreenWidth>320?kFWFullScreenWidth/320:1.0;
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
        [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
        headIcon.layer.masksToBounds=YES;
        headIcon.layer.cornerRadius=5.0;
        [self addSubview:headIcon];
        
        contentBg = [[UIImageView alloc] init];
        [contentBg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentBg];
        
        emojiLabel = [MLEmojiLabel new];
        //        emojiLabel.lineSpace=2;
        //15
        emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        emojiLabel.customEmojiPlistName = @"expressionImage_custom";
        emojiLabel.font = [UIFont systemFontOfSize:16.0];
        //        [emojiLabel setTextColor:ntalker_textColor];
        [emojiLabel setBackgroundColor:[UIColor clearColor]];
        
#pragma mark - 添加手势（长按复制 点击跳转）
        UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressLeftCopy:)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLink:)];
        [emojiLabel addGestureRecognizer:longpressGesture];
        [emojiLabel addGestureRecognizer:tapGesture];
        
        [self addSubview:emojiLabel];
        
#pragma mark - 修改内容开始
#pragma mark - 添加点击手势 用于取消 Button
        //        UITapGestureRecognizer *screenTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenButton)];
        //        //文本 和 其父控件 均添加手势
        //        [emojiLabel addGestureRecognizer:screenTapGesture];
        //        [emojiLabel.superview addGestureRecognizer:screenTapGesture];
        
    }
    return self;
}
- (void)longpressLeftCopy:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        //        NSLog(@"长按了左边");
        //设置复制按钮属性
        float textfieldX = emojiLabel.frame.origin.x;
        float textfieldY = emojiLabel.frame.origin.y;
        float textfieldWidth = emojiLabel.frame.size.width;
        //        float textfieldHeight = emojiLabel.frame.size.height;
        //view中的尺寸
        UIButton *copyBtn = [[UIButton alloc]initWithFrame:CGRectMake(textfieldX+textfieldWidth/2-30, (textfieldY-38), 60*autoSizeScaleX, 35*autoSizeScaleY)];
        [copyBtn setAlpha:1];//
        
        [copyBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/copy.png"] forState:UIControlStateNormal];
        [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        copyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [copyBtn becomeFirstResponder];
        [copyBtn setHidden:NO];
        [copyBtn addTarget:self action:@selector(copyContent:) forControlEvents:UIControlEventTouchUpInside];
        
        [copyBtn becomeFirstResponder];
        [copyBtn setHidden:NO];
        [emojiLabel.superview addSubview:copyBtn];
        self.publicButton = copyBtn;
        
        //        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenButton) userInfo:nil repeats:NO];
    }
}
//复制文本到剪切版
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
    [self.publicButton removeFromSuperview];
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
                                        
                                        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToWebViewByLink:)]) {
                                            [self.delegate jumpToWebViewByLink:newUrl];
                                        }
                                    }else{
                                        
                                        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToWebViewByLink:)]) {
                                            [self.delegate jumpToWebViewByLink:newUrl];
                                        }
                                    }
                                }else{
                                    //                                    NSLog(@"没有链接");
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
        [content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
    
    if ([content rangeOfString:@"&lt;"].location != NSNotFound) {
        [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    }
    
    if ([content rangeOfString:@"&gt;"].location != NSNotFound) {
        [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
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
    //    NSMutableAttributedString *contentAttributed = [self attributedStringFromStingWithFont:[UIFont systemFontOfSize:15] withLineSpacing:2 content:emojiLabel.text];
    //    CGRect contentRect = [contentAttributed boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    //    CGSize contentSize=contentRect.size;
    CGSize contentSize = [emojiLabel preferredSizeWithMaxWidth:width];
    float addHeight=0;
    if (contentSize.height<30) {
        addHeight = 30-contentSize.height;
    }
    
    [headIcon setFrame:CGRectMake(10, (15+offHeight)*autoSizeScaleY, 45, 45)];
    if (dto.usericon && ![dto.usericon isEqualToString:@""]) {
        NSString *headImageUrl =[dto.usericon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([headIcon respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [headIcon sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
        }
    }
    [emojiLabel setFrame:CGRectMake(64 + 15 * autoSizeScaleX, (21+offHeight+addHeight/2)*autoSizeScaleY, contentSize.width, contentSize.height)];
    UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left.png"];
    [contentBg setImage:[contentBgImage stretchableImageWithLeftCapWidth:33 topCapHeight:30]];//18  20
    contentBg.frame = CGRectMake(64, (15+offHeight)*autoSizeScaleY, contentSize.width+27*autoSizeScaleX, contentSize.height+(15+addHeight));
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,(contentBg.frame.size.height+16)>61?contentBg.frame.size.height+(16+offHeight)*autoSizeScaleY:(61+offHeight)*autoSizeScaleY)];
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
