//
//  MBLoginShareButton.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBLoginShareButton.h"


@interface MBLoginShareButton ()
@property (weak,nonatomic) UIView *lineView;
@end

@implementation MBLoginShareButton

- (CGFloat)imageRadio{
    if (!_imageRadio) {
        return 0.6;
    }else{
        return _imageRadio;
    }
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(self.frame.size.width - PX_ONE, 7, PX_ONE, self.frame.size.height - 14);
        lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [self addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat height = contentRect.size.height * self.imageRadio;
    return CGRectMake(0, height, contentRect.size.width, contentRect.size.height - height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat height = contentRect.size.height * self.imageRadio;
    if (self.titleLabel.text == nil) {
        height = contentRect.size.height;
    }
    return CGRectMake(0, 0, contentRect.size.width, height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.showLine) {
        self.lineView.hidden = NO;
    }
}
@end
