//
//  NSImageLeftTableViewCell.m
//  CustomerServerSDK2
//
//  Created by zhangwei on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerImageLeftTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XNImageMessage.h"
#import "XNUtilityHelper.h"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

@interface NTalkerImageLeftTableViewCell() {
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}
@end

@implementation NTalkerImageLeftTableViewCell
@synthesize contentBtn,contentImage,failedBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
        autoSizeScaleY=kFWFullScreenHeight>480?kFWFullScreenHeight/568:1.0;
        iphone6P=CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
        iphone6=CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
        
        // Initialization code
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120*autoSizeScaleX, 28*autoSizeScaleY, 80*autoSizeScaleX, 15*autoSizeScaleY)];
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
        _headIcon.layer.cornerRadius=5.0*autoSizeScaleX;
        [self addSubview:_headIcon];
        
#pragma mark - 添加手势
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
        failedBtn.userInteractionEnabled=NO;
        [failedBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_msg_failed.png"] forState:UIControlStateNormal];
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
    
    if (dto.msgType == 2) {
        
        [_headIcon setFrame:CGRectMake(10, (15+offHeight)*autoSizeScaleY, 45 ,45)];
        [_headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
        if (dto.usericon && ![dto.usericon isEqualToString:@""]) {
            NSString *headImageUrl =[dto.usericon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_headIcon sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
        }
        
        UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_image_chat_left.png"];
        [contentBg setImage:[contentBgImage stretchableImageWithLeftCapWidth:18 topCapHeight:38]];//30 20  易到的
        [contentImage setImage:[contentBgImage stretchableImageWithLeftCapWidth:18 topCapHeight:38]];//30 20
        contentBg.frame = CGRectMake(65, (15+offHeight)*autoSizeScaleY, 140*autoSizeScaleX, 140*autoSizeScaleX);
        contentImage.frame = CGRectMake(65, (15+offHeight)*autoSizeScaleY, 140*autoSizeScaleX, 140*autoSizeScaleX);
        [contentBtn setFrame:CGRectMake(65, (15+offHeight)*autoSizeScaleY, 140*autoSizeScaleX, 140*autoSizeScaleX)];
    }
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,(offHeight+156)*autoSizeScaleY)];
    [self handleContentImage:dto];
}
- (void)handleContentImage:(XNBaseMessage *)dto{
    
    NSString *path = [XNUtilityHelper getConfigFile:[NSString stringWithFormat:@"%@.jpg",dto.msgid]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //从沙盒中取图
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
            if (newImageSize.height<45) {
                newImageSize.height=45;
            }
            
            CGRect frame= contentBg.frame;
            
            contentBg.frame = CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
            contentImage.frame = CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
            contentBtn.frame=CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
            
            [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,frame.origin.y+(newImageSize.height+1)*autoSizeScaleY)];
            
        } else {
            CGSize newImageSize;
            
            newImageSize = image.size;
            
            if (image.size.width > 140) {
                newImageSize = CGSizeMake(140, 140);
            }
            if (image.size.width <= 45) {
                newImageSize = CGSizeMake(45, 45);
            }
            
            CGRect frame= contentBg.frame;
            
            contentBg.frame = CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
            contentImage.frame = CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
            contentBtn.frame=CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
            
            [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,frame.origin.y+(newImageSize.height+1)*autoSizeScaleY)];
            
        }
    } else {
        // 从网上取图
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        NSTextChatMessage *imageMessage = dto.messageBody;//gai  text_add--->img_extension--》img_oldfile
        XNImageMessage *imageMessage = (XNImageMessage *)dto;
        
        if (![imageMessage.pictureThumb isEqualToString:@""] && imageMessage.pictureThumb!=nil) {
            NSError *error;
            //地址中：“&amp;”转“&”
            NSString *paths =[imageMessage.pictureThumb stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            
            //NSString-->NSData
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[paths stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:NSDataReadingUncached error:&error];
            if (error) {
                //                DLog(@"error  :%@",error);
                
            } else if(imageData){
                //归档
                [imageData writeToFile:path atomically:YES];
                //NSData-->UIImage 获取图片
                UIImage *image = [UIImage imageWithData:imageData];
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //图片添加到容器中
                [contentImage setImage:image];
                CGSize imageSize = image.size;
                //调节图片尺寸
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
                    //设置左边尺寸
                    CGRect frame= contentBg.frame;
                    //                    if ([dto.userid rangeOfString:@"guest"].location !=NSNotFound){
                    contentBg.frame = CGRectMake((256-newImageSize.width)*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    contentImage.frame = CGRectMake((256-newImageSize.width)*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    CGRect indicatorFrame = indicatorView.frame;
                    indicatorFrame.origin.x = (226-newImageSize.width)*autoSizeScaleX;
                    indicatorFrame.origin.y = (newImageSize.height-25)/2*autoSizeScaleX+frame.origin.y;
                    [indicatorView setFrame:indicatorFrame];
                    contentBtn.frame=CGRectMake((256-newImageSize.width)*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX,newImageSize.height*autoSizeScaleX);
                    
                    
                    float offHeight=lineView2.hidden?0:40;
                    failedBtn.hidden=YES;
                    indicatorView.hidden=YES;
                    if (dto.sendStatus == SS_TOSEND || dto.sendStatus == SS_SENDING) {
                        [indicatorView setFrame:CGRectMake((226-newImageSize.width)*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
                        [indicatorView startAnimating];
                        indicatorView.hidden=NO;
                    } else if (dto.sendStatus == SS_SENDFAILED){
                        [failedBtn setFrame:CGRectMake((226-newImageSize.width)*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
                        failedBtn.hidden=NO;
                        [indicatorView stopAnimating];
                    } else {
                        [indicatorView stopAnimating];
                    }
                    
                    //                    }else{
                    //                        contentBg.frame = CGRectMake(64*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    //                        contentImage.frame = CGRectMake(64*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    //                        contentBtn.frame=CGRectMake(64*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    //                    }
                    if (newImageSize.height<=45) {
                        newImageSize.height=45;
                    }
                    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,frame.origin.y+(newImageSize.height+1)*autoSizeScaleY)];
                }  else {
                    CGSize newImageSize;
                    
                    if (image.size.width > 140) {
                        newImageSize = CGSizeMake(140, 140);
                    }
                    if (image.size.width <= 45) {
                        newImageSize = CGSizeMake(45, 45);
                    }
                    CGRect frame= contentBg.frame;
                    
                    contentBg.frame = CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    contentImage.frame = CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    contentBtn.frame=CGRectMake(65, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
                    
                    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,frame.origin.y+(newImageSize.height+1)*autoSizeScaleY)];
                    
                }
                //                });
            }
            //        });
        }
        
    }
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
