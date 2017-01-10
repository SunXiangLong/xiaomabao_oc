//
//  MBPostDetailsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsOneCell.h"

@interface MBPostDetailsOneCell ()
{
    NSString *_inHtmlString;
    NSInteger _allImageHeight;
    NSString *_postContent;
    BOOL _isImage;
}
@property (weak, nonatomic) IBOutlet UILabel *post_title;
@property (weak, nonatomic) IBOutlet UILabel *author_name;
@property (weak, nonatomic) IBOutlet UIImageView *author_userhead;
@property (weak, nonatomic) IBOutlet UILabel *post_content;
@property (strong, nonatomic)   UIImageView *oldimageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
@implementation MBPostDetailsOneCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _isImage = NO;
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    for (UIView *view in self.webView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrView =   (UIScrollView *)view;
            scrView.scrollEnabled = NO;
            return;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
   
    self.post_title.text = dataDic[@"post_title"];
    self.author_name.text = dataDic[@"author_name"];
    [self.author_userhead  sd_setImageWithURL:URL(dataDic[@"author_userhead"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
    _inHtmlString =  dataDic[@"post_content"] ;
    NSURL *indexFileURL = [[NSBundle mainBundle] URLForResource:@"richTextEditor" withExtension:@"html"];
    //    NSArray *htmlArr =  [NSString htmlString:dataDic[@"post_content"] AspectRatio:dataDic[@"post_imgs_scale"]];
    NSArray *brArr = [NSString rangesOfString:@"<br>" inString:dataDic[@"post_content"]];
    
    _allImageHeight = brArr.count*20;
    _webView.hidden = NO;
    
    if ([dataDic[@"post_content"] containsString:@"<div>"]) {
        
        for (NSString *scale in dataDic[@"post_imgs_scale"]) {
            _allImageHeight += 20;
            _allImageHeight += (UISCREEN_WIDTH-20)/[scale floatValue];
            
        }
        _allImageHeight += [[NSString filterHTML:dataDic[@"post_content"]] sizeWithFont:SYSTEMFONT(18) withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height;
        _allImageHeight+= 150;
        
    }else{
        
        _webView.hidden = YES;
        
         self.post_content.text = [dataDic[@"post_content"] componentsSeparatedByString:@"<img src=\""].firstObject;
    
        _allImageHeight+= [self.dataDic[@"post_content"] sizeWithFont:SYSTEMFONT(16) lineSpacing:6 withMax:UISCREEN_WIDTH-20];
        [self.post_content rowSpace:6];
        [self.post_title rowSpace:2];
        _allImageHeight+= 65;
       
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    
    
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    MMLog(@"%@",[NSString removeSpaceAndNewline:_inHtmlString]);
    NSString *place = [NSString stringWithFormat:@"window.placeHTMLToEditor('%@')",[NSString removeSpaceAndNewline:_inHtmlString]];
    [webView stringByEvaluatingJavaScriptFromString:place];
    
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    MMLog(@"%f",height);
    
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight+= [self.post_title sizeThatFits:size].height;
    totalHeight+= _allImageHeight;
    return CGSizeMake(size.width, totalHeight);
}
@end
