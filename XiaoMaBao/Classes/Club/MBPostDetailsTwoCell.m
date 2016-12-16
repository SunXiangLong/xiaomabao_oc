//
//  MBPostDetailsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsTwoCell.h"
#import "YYWebImage.h"
@interface MBPostDetailsTwoCell ()
{
    NSString *_inHtmlString;
    NSInteger _allImageHeight;
    NSString *_postContent;
    NSInteger _webHeight;
    BOOL _isImage;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *user_head;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *comment_time;
@property (weak, nonatomic) IBOutlet UILabel *comment_floor;
@property (weak, nonatomic) IBOutlet UIImageView *user_head_user_head;
@property (weak, nonatomic) IBOutlet UILabel *comment_reply_comment_content;
@property (weak, nonatomic) IBOutlet UILabel *comment_reply_user_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comment_reply_height;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@end
@implementation MBPostDetailsTwoCell


- (void)awakeFromNib {
    [super awakeFromNib];
    for (UIView *view in self.webView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrView =   (UIScrollView *)view;
            scrView.scrollEnabled = NO;
            return;
        }
    }
    
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
   
    
    _inHtmlString = _dataDic[@"comment_content"];
    self.comment_time.text = dataDic[@"comment_time"];
    self.comment_floor.text = dataDic[@"comment_floor"];
//    self.comment_content.text = dataDic[@"comment_content"];
    self.user_name.text = dataDic[@"user_name"];
    [self.user_head sd_setImageWithURL:URL(dataDic[@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
    NSArray *htmlArr =  [NSString htmlString:dataDic[@"comment_content"] AspectRatio:dataDic[@"post_imgs_scale"]];
    
    _allImageHeight = 0;
    
    
    for (NSDictionary *dic in htmlArr) {
        
        if (![dic[@"text"] isEqualToString:@""]&&![dic[@"text"] isEqualToString:@"<br>"]) {
            _allImageHeight += 20;
            _allImageHeight += [dic[@"text"] sizeWithFont:SYSTEMFONT(16) withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height;
        }
        if ([dic[@"imageUrl"] containsString:@"http://"]) {
            _isImage = YES;
        }
        
    }
    
    if (_isImage) {
        for (NSString *scale in dataDic[@"comment_imgs_scale"]) {
            _allImageHeight += 20;
            _allImageHeight += (UISCREEN_WIDTH-20)/[scale floatValue];
        }
    }
    
    
    _webHeight =   [_postContent sizeWithFont:SYSTEMFONT(17) withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height + _allImageHeight;
   
    self.webViewHeight.constant = _webHeight;
    NSURL *indexFileURL = [[NSBundle mainBundle] URLForResource:@"richTextEditor" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    if (dataDic[@"comment_reply"]) {
        
        NSString *comment_reply_comment_content =  dataDic[@"comment_reply"][@"comment_content"];
        CGFloat comment_reply_user_name_height  =  [comment_reply_comment_content sizeWithFont: SYSTEMFONT(12) lineSpacing:2 withMax:UISCREEN_WIDTH -70];
        self.comment_reply_user_name.text = dataDic[@"comment_reply"][@"user_name"];
        self.comment_reply_comment_content.text = dataDic[@"comment_reply"][@"comment_content"];
        [self.user_head_user_head sd_setImageWithURL:URL(dataDic[@"comment_reply"][@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        self.comment_reply_height.constant  = comment_reply_user_name_height+40;
        self.commentView.hidden = NO;
        [self.comment_reply_comment_content rowSpace:2];
        [self.comment_reply_comment_content columnSpace:1];
    }else{
        self.comment_reply_height.constant  = 0;
        self.commentView.hidden = YES;
    }
    
   
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    NSString *place = [NSString stringWithFormat:@"window.placeHTMLToEditor('%@')",[NSString removeSpaceAndNewline:_inHtmlString]];
    [webView stringByEvaluatingJavaScriptFromString:place];
    
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight+=50;
    totalHeight+= _webHeight;
    totalHeight+=self.comment_reply_height.constant;
    if (self.dataDic[@"comment_reply"]) {
      totalHeight+=10;
    }
    return CGSizeMake(size.width, totalHeight);
}
@end
