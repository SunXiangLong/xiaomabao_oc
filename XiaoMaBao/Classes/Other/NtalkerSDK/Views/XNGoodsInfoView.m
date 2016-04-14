//
//  XNGoodsInfoView.m
//  XNChatCore
//
//  Created by Ntalker on 15/10/26.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "XNGoodsInfoView.h"
#import "UIImageView+WebCache.h"
#import "XNGoodsInfoModel.h"
#import "XNUserBasicInfo.h"
#import "XNGetflashserverDataModel.h"
#import "XNUtilityHelper.h"
#import "XNHttpManager.h"
#import "XNFirstHttpService.h"

#define KHeightRatio (CGRectGetHeight(self.frame) / 90)
#define KWidthRatio (CGRectGetWidth(self.frame) / 407)

@interface XNGoodsInfoView ()<UIWebViewDelegate>

@property (strong, nonatomic) XNGoodsInfoModel *goodsInfo;
@property (weak, nonatomic) id<XNJumpProductDelegate> delegate;

@end

@implementation XNGoodsInfoView

- (instancetype)initWithFrame:(CGRect)frame andGoodsInfoModel:(XNGoodsInfoModel *)goodsInfo andDelegate:(id<XNJumpProductDelegate>)delegate
{
    self = [[XNGoodsInfoView alloc] initWithFrame:frame];
    
    self.delegate = delegate;
    [self congfigureGoodsView:goodsInfo];
    return self;
}

- (void)congfigureGoodsView:(XNGoodsInfoModel *)goodsModel
{
    self.goodsInfo = [[XNGoodsInfoModel alloc] init];
    self.goodsInfo = goodsModel;
    
    if ([goodsModel.appGoods_type isEqualToString:@"1"]) {
        [self configureGoodsIdView];
    } else if ([goodsModel.appGoods_type isEqualToString:@"2"]) {
        [self configureGoods_showURLView];
    } else if ([goodsModel.appGoods_type isEqualToString:@"3"]) {
        [self addSubviewsInGoodsView];
    }
    
}

- (void)configureGoods_showURLView
{
    if (!_goodsInfo.goods_showURL.length) {
        return;
    }
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
    NSURL *showURL = [NSURL URLWithString:_goodsInfo.goods_showURL];
    [webView loadRequest:[NSURLRequest requestWithURL:showURL]];
    webView.delegate = self;
    [self addSubview:webView];
}

- (void)configureGoodsIdView
{
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    if (_goodsInfo.goods_id.length) {
        NSString *URLString = [NSString stringWithFormat:@"%@//goodsinfo/api.php?siteid=%@&itemid=%@&itemparam=null&sellerid=&user_id=%@&type=json",basicInfo.serverData.manageserver?:@"",basicInfo.siteid,_goodsInfo.goods_id,basicInfo.uid];
        [[[XNHttpManager sharedManager] getFirstHttpService] sendProductInfoWithURL:URLString andParam:nil andBlock:^(id response){
            if ([response isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *itemDict = (NSDictionary *)response;
                id obj = itemDict[@"item"];
                
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = obj;
                    _goodsInfo.goods_imageURL = dict[@"imageurl"];
                    _goodsInfo.goodsPrice = dict[@"marketprice"];
                    _goodsInfo.goodsTitle = dict[@"name"];
                    _goodsInfo.goods_URL = dict[@"url"];
                    [self addSubviewsInGoodsView];
                } else {
                    [self removeFromSuperview];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(productInfoShowFailed)]) {
                        [self.delegate productInfoShowFailed];
                    }
                }
            } else {
                [self removeFromSuperview];
                if (self.delegate && [self.delegate respondsToSelector:@selector(productInfoShowFailed)]) {
                    [self.delegate productInfoShowFailed];
                }
            }
        }];
    }
}

- (void)addSubviewsInGoodsView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(21 * KWidthRatio, (CGRectGetHeight(self.frame) - 60 * KHeightRatio)/2, 60 * KHeightRatio, 60 * KHeightRatio)];
    
    if (_goodsInfo.goods_imageURL.length) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:_goodsInfo.goods_imageURL] placeholderImage:nil];
    }
    
    [self addSubview:imageView];
    
    UILabel *titleLabel = nil;
    [self addLabel:&titleLabel
             frame:CGRectMake(CGRectGetMaxX(imageView.frame) + 20 * KWidthRatio, 9 *KHeightRatio, CGRectGetWidth(self.frame) - (CGRectGetMaxX(imageView.frame) + 20 * KWidthRatio) - 20 * KWidthRatio, 40 * KHeightRatio)
              text:_goodsInfo.goodsTitle
         textColor:[self colorWithHexString:@"666666"]
          fontSize:16.0 * KWidthRatio
         alignment:NSTextAlignmentLeft
            inView:self];
    
    [self addLabel:nil
             frame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + 12 * KHeightRatio, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(titleLabel.frame) - 24 * KHeightRatio)
              text:[NSString stringWithFormat:@"%@",_goodsInfo.goodsPrice?:@""]
         textColor:[self colorWithHexString:@"ff5000"]
          fontSize:16.0 * KWidthRatio
         alignment:NSTextAlignmentLeft
            inView:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsViewTaped:)];
    [self addGestureRecognizer:tap];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(productInfoSuccess)]) {
        [self.delegate productInfoSuccess];
    }
}

#pragma mark ===================webViewDelegate====================

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(productInfoShowFailed)]) {
        [self.delegate productInfoShowFailed];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(productInfoSuccess)]) {
        [self.delegate respondsToSelector:@selector(productInfoSuccess)];
    }
}

#pragma mark ========================util==========================

- (void)addLabel:(UILabel **)lbl frame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment inView:(UIView *)superView
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.numberOfLines = 2;
    label.textAlignment = alignment;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    [superView addSubview:label];
    
    if (lbl) {
        *lbl = label;
    }
}

- (void)goodsViewTaped:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpByProductURL)]) {
        [self.delegate jumpByProductURL];
    }
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
