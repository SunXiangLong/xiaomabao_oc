//
//  NSImageRightTableViewCell.m
//  CustomerServerSDK2
//
//  Created by zhangwei on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerImageRightTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XNImageMessage.h"
#import "XNUtilityHelper.h"
#import "SDWebImageManager.h"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

//#define dispatch_main_async_safe(block)\
//if ([NSThread isMainThread]) {\
//block();\
//} else {\
//dispatch_async(dispatch_get_main_queue(), block);\
//}
@interface NTalkerImageRightTableViewCell() {
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}

@property (nonatomic, strong) NSMutableArray *sendFailedArray;

@end

@implementation NTalkerImageRightTableViewCell
@synthesize contentBtn,contentImage,failedBtn;
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
        
        lineView1=[[UIView alloc] initWithFrame:CGRectMake(30*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [lineView1 setBackgroundColor:chatItemTimeLine];
        lineView1.hidden=YES;
        [self addSubview:lineView1];
        
        lineView2=[[UIView alloc] initWithFrame:CGRectMake(200*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [lineView2 setBackgroundColor:chatItemTimeLine];
        lineView2.hidden=YES;
        [self addSubview:lineView2];
        
        _headIcon = [[UIImageView alloc] init];
        _headIcon.layer.masksToBounds=YES;
        _headIcon.layer.cornerRadius=5.0;
        [self addSubview:_headIcon];
        
        contentImage=[[UIImageView alloc] init];
        [self addSubview:contentImage];
        
        contentBg = [[UIImageView alloc] init];
        [self addSubview:contentBg];
        
        contentBtn=[[UIButton alloc] init];
        [contentBtn setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentBtn];
        
        indicatorView  = [[UIActivityIndicatorView alloc] init];
        indicatorView.color=ntalker_textColor;
        [self addSubview:indicatorView];
        
        failedBtn = [[UIButton alloc] init];
        [failedBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_msg_failed.png"] forState:UIControlStateNormal];
        [failedBtn addTarget:self action:@selector(resendFailedMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:failedBtn];
    }
    return self;
}
- (void)setChatImageMessageInfo:(XNBaseMessage *)dto  hidden:(BOOL)hide{
    timeLabel.text = [XNUtilityHelper getFormatTimeString:[NSString stringWithFormat:@"%lld",dto.msgtime]];
    timeLabel.hidden=hide;
    lineView1.hidden=hide;
    lineView2.hidden=hide;
    float offHeight=hide?0:40;
    //当前访客
    if (dto.msgType == 2) {
        
        [_headIcon setFrame:CGRectMake(kFWFullScreenWidth - 10 - 45, (15+offHeight)*autoSizeScaleY, 45, 45)];
        [_headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_FK_icon.png"]];
        
        UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_image_chat_right.png"];
        [contentBg setImage:[contentBgImage stretchableImageWithLeftCapWidth:18 topCapHeight:38]];//30 20
        [contentImage setImage:[contentBgImage stretchableImageWithLeftCapWidth:18 topCapHeight:38]];//30 20
        contentBg.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - 140*autoSizeScaleX, (15+offHeight)*autoSizeScaleY, 140*autoSizeScaleX, 140*autoSizeScaleX);
        contentImage.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - 140*autoSizeScaleX, (15+offHeight)*autoSizeScaleY, 140*autoSizeScaleX, 140*autoSizeScaleX);
        [contentBtn setFrame:CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - 140*autoSizeScaleX, (15+offHeight)*autoSizeScaleY, 140*autoSizeScaleX, 140*autoSizeScaleX)];
        [indicatorView stopAnimating];
        failedBtn.hidden=YES;
        indicatorView.hidden=YES;
        //        if ([dto.msgStatus isEqualToString:@"sending"] || [dto.msgStatus isEqualToString:@"send"]) {
        //            [indicatorView setFrame:CGRectMake(86*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
        //            [indicatorView startAnimating];
        //            indicatorView.hidden=NO;
        //        } else if ([dto.msgStatus isEqualToString:@"failed"]){
        //            [failedBtn setFrame:CGRectMake(86*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
        //            failedBtn.hidden=NO;
        //            [indicatorView stopAnimating];
        //        } else {
        //            [indicatorView stopAnimating];
        //        }
    }
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,(offHeight+156)*autoSizeScaleY)];
    [self handleContentImage:dto andOffHeight:offHeight];
}
- (void)handleContentImage:(XNBaseMessage *)dto andOffHeight:(CGFloat)offHeight{
    NSString *path = [XNUtilityHelper getConfigFile:[NSString stringWithFormat:@"%@.jpg",dto.msgid]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [contentImage setImage:image];
        CGSize imageSize = image.size;
        if (imageSize.height!=imageSize.width) {
            CGSize newImageSize;
            if (imageSize.height>imageSize.width) {
                CGFloat scale = 140/imageSize.height;
                if (scale>1) {
                    scale = 1.0;
                }
                newImageSize=CGSizeMake(imageSize.width*scale, 140);
            } else {
                CGFloat scale = 140/imageSize.width;
                if (scale>1) {
                    scale = 1.0;
                }
                newImageSize=CGSizeMake(140, imageSize.height*scale);
            }
            CGRect frame= contentBg.frame;
            
            contentBg.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - newImageSize.width*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
            contentImage.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - newImageSize.width*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
            CGRect indicatorFrame = indicatorView.frame;
            indicatorFrame.origin.x = (226-newImageSize.width)*autoSizeScaleX;
            indicatorFrame.origin.y = (newImageSize.height-25)/2*autoSizeScaleX+frame.origin.y;
            [indicatorView setFrame:indicatorFrame];
            
            contentBtn.frame=CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - newImageSize.width*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX,newImageSize.height*autoSizeScaleX);
            
            CGRect otherFrame = indicatorView.frame;
            otherFrame.origin.x=(140-newImageSize.width)*autoSizeScaleX;
            
            float offHeight=lineView2.hidden?0:40;
            failedBtn.hidden=YES;
            indicatorView.hidden=YES;
            if (dto.sendStatus == SS_SENDING || dto.sendStatus == SS_TOSEND) {
                [indicatorView setFrame:CGRectMake(CGRectGetMinX(contentImage.frame) - 25*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
                [indicatorView startAnimating];
                indicatorView.hidden=NO;
                [self.sendFailedArray removeObject:dto];
            } else if (dto.sendStatus == SS_SENDFAILED){
                [failedBtn setFrame:CGRectMake(CGRectGetMinX(contentImage.frame) - 25, (15+offHeight+57)*autoSizeScaleY, 25, 25)];
                failedBtn.hidden=NO;
                [self.sendFailedArray addObject:dto];
                failedBtn.tag = [[dto.msgid substringWithRange:NSMakeRange(5, dto.msgid.length - 6)] integerValue];
                [indicatorView stopAnimating];
            } else {
                [indicatorView stopAnimating];
            }
            
            if (newImageSize.height<45) {
                newImageSize.height=45;
            }
            [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,frame.origin.y+(newImageSize.height+1)*autoSizeScaleY)];
        } else {
            if (dto.sendStatus == SS_SENDING || dto.sendStatus == SS_TOSEND) {
                [indicatorView setFrame:CGRectMake(CGRectGetMinX(contentImage.frame) - 25*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
                [indicatorView startAnimating];
                indicatorView.hidden=NO;
                [self.sendFailedArray removeObject:dto];
            } else if (dto.sendStatus == SS_SENDFAILED){
                [failedBtn setFrame:CGRectMake(CGRectGetMinX(contentImage.frame) - 25 - 3, (15+offHeight+57)*autoSizeScaleY, 25, 25)];
                failedBtn.hidden=NO;
                [self.sendFailedArray addObject:dto];
                failedBtn.tag = [[dto.msgid substringWithRange:NSMakeRange(0, dto.msgid.length - 1)] integerValue];
                [indicatorView stopAnimating];
            } else {
                [indicatorView stopAnimating];
            }
        }
    } else {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //        NSTextChatMessage *imageMessage = dto.messageBody;//gai  text_add--->img_extension--》img_oldfile
        
        XNImageMessage *imageMessage = (XNImageMessage *)dto;
        
        if (![imageMessage.pictureSource isEqualToString:@""] && imageMessage.pictureSource!=nil) {
            NSError *error;
            
//            [[SDWebImageManager sharedManager] downloadImageWithURL:<#(NSURL *)#> options:<#(SDWebImageOptions)#> progress:<#^(NSInteger receivedSize, NSInteger expectedSize)progressBlock#> completed:<#^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)completedBlock#>];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[imageMessage.pictureName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:NSDataReadingUncached error:&error];
            
//            if (error) {
//            } else if(imageData){
                [imageData writeToFile:path atomically:YES];
                UIImage *image = [UIImage imageWithData:imageData];
                //                dispatch_async(dispatch_get_main_queue(), ^{
                [contentImage sd_setImageWithURL:[NSURL URLWithString:imageMessage.pictureSource] placeholderImage:nil];
                CGSize imageSize = image.size;
                if (imageSize.height!=imageSize.width) {
                    CGSize newImageSize;
                    if (imageSize.height>imageSize.width) {
                        CGFloat scale = 140/imageSize.height;
                        if (scale>1) {
                            scale = 1.0;
                        }
                        newImageSize=CGSizeMake(imageSize.width*scale, 140);
                    } else {
                        CGFloat scale = 140/imageSize.width;
                        if (scale>1) {
                            scale = 1.0;
                        }
                        newImageSize=CGSizeMake(140, imageSize.height*scale);
                    }
                    CGRect frame= contentBg.frame;
                    //                    if ([dto.userid rangeOfString:@"guest"].location !=NSNotFound){
                    //                        contentBg.frame = CGRectMake((256-newImageSize.width)*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    //                        contentImage.frame = CGRectMake((256-newImageSize.width)*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    //                        CGRect indicatorFrame = indicatorView.frame;
                    //                        indicatorFrame.origin.x = (226-newImageSize.width)*autoSizeScaleX;
                    //                        indicatorFrame.origin.y = (newImageSize.height-25)/2*autoSizeScaleX+frame.origin.y;
                    //                        [indicatorView setFrame:indicatorFrame];
                    //                        contentBtn.frame=CGRectMake((256-newImageSize.width)*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX,newImageSize.height*autoSizeScaleX);
                    //
                    //
                    //                        float offHeight=lineView2.hidden?0:40;
                    //                        failedBtn.hidden=YES;
                    //                        indicatorView.hidden=YES;
                    //                        if ([dto.msgStatus isEqualToString:@"sending"] || [dto.msgStatus isEqualToString:@"send"]) {
                    //                            [indicatorView setFrame:CGRectMake((226-newImageSize.width)*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
                    //                            [indicatorView startAnimating];
                    //                            indicatorView.hidden=NO;
                    //                        } else if ([dto.msgStatus isEqualToString:@"failed"]){
                    //                            [failedBtn setFrame:CGRectMake((226-newImageSize.width)*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
                    //                            failedBtn.hidden=NO;
                    //                            [indicatorView stopAnimating];
                    //                        } else {
                    //                            [indicatorView stopAnimating];
                    //                        }
                    //
                    //                    }else{
                    contentBg.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - newImageSize.width*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    contentImage.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - newImageSize.width*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    contentBtn.frame=CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - newImageSize.width*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    //                    }
                    if (newImageSize.height<45) {
                        newImageSize.height=45;
                    }
                    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,frame.origin.y+(newImageSize.height+1)*autoSizeScaleY)];
                }
                //                });
//            }
            //        });
        }
        
    }
}

#pragma mark ==================重发消息====================

- (void)resendFailedMessage:(UIButton *)sender
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(resendImageMsg:)]) {
        return;
    }
    
    XNImageMessage *imageMessage = nil;
    for (XNImageMessage *message in _sendFailedArray) {
        if ([message isKindOfClass:[XNImageMessage class]]) {
            
            if (!message.msgid.length) continue;
            
            NSInteger msgIdTag = [[message.msgid substringWithRange:NSMakeRange(5, message.msgid.length - 6)] integerValue];
            
            if (sender.tag == msgIdTag) {
                imageMessage = message;
                break;
            }
        }
    }
    
    if (!imageMessage) {
        return;
    }
    
    [self.delegate resendImageMsg:imageMessage];
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

@end
