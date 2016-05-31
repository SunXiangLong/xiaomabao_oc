//
//  BkNavigationBarView.m
//  背包客
//
//  Created by mac on 14-9-13.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#define NAV_BAR_HEIGHT 44
#define NAV_BAR_Y 20
#define NAV_BAR_W 55

#import "BkNavigationBarView.h"
#import "CustomBadge.h"

@interface BkNavigationBarView ()
{

   
}
@end

@implementation BkNavigationBarView

- (UIButton *)leftButton{
    if (!_leftButton) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            leftButton.frame =CGRectMake(10, NAV_BAR_Y, NAV_BAR_W, NAV_BAR_HEIGHT) ;
        leftButton.titleLabel.font = YC_RTWSYueRoud_FONT(17);
        [self addSubview:leftButton];
        self.leftButton = leftButton;
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        rightButton.frame =CGRectMake(self.ml_width - NAV_BAR_W, NAV_BAR_Y, NAV_BAR_W, NAV_BAR_HEIGHT) ;
        rightButton.titleLabel.font = YC_RTWSYueRoud_FONT(16);
        
        [self addSubview:rightButton];
        self.rightButton = rightButton;
    }
    return _rightButton;
}

-(void)setButtonBadge:(CustomBadge *)badge{
    badge.frame = CGRectMake(35, 5, badge.ml_width, badge.ml_height);
    [self.rightButton addSubview:badge];
}

- (UIButton *)titleButton{
    if (!_titleButton) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // @taBbar:
        [titleButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        titleButton.frame =CGRectMake(NAV_BAR_W, NAV_BAR_Y, self.ml_width - NAV_BAR_W * 2 , NAV_BAR_HEIGHT) ;
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        titleButton.titleLabel.font =  YC_RTWSYueRoud_FONT(17);//[UIFont boldSystemFontOfSize:18];
        [self addSubview:titleButton];
        self.titleButton = titleButton;
    }
    return _titleButton;
}

+ (instancetype)navigationBarView{
    BkNavigationBarView *navBar = [[BkNavigationBarView alloc] init];

    navBar.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 0);
    navBar.ml_height = iOS_7 ? 64 : 44;
    UIImageView *banckImage = [[UIImageView  alloc] init];
    banckImage.frame =CGRectMake(0, 0, navBar.ml_width, navBar.ml_height);
    banckImage.image = [UIImage imageNamed:@"navBack"];
    [navBar addSubview:banckImage];
    return navBar;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
}

- (void)setLeftStr:(NSString *)leftStr{
    _leftStr = leftStr;
    [self.leftButton setTitle:leftStr forState:UIControlStateNormal];
}

- (void)setRightStr:(NSString *)rightStr{
    _rightStr = rightStr;
    [self.rightButton setTitle:rightStr forState:UIControlStateNormal];
}

- (void)setBack:(BOOL)back{
   
    
    _back = back;

  
    if (back && self.leftStr == nil) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
         backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        backBtn.frame =CGRectMake(0, NAV_BAR_Y, NAV_BAR_W, NAV_BAR_HEIGHT) ;
        [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
    }
 
}

- (void)setLeftButtonW:(CGFloat)leftButtonW{
    _leftButtonW = leftButtonW;
    
    if (self.leftButtonW) {
        self.leftButton.frame =CGRectMake(0, NAV_BAR_Y, self.leftButtonW, 40) ;
    }
}

- (void) goBack : (UIButton *) btn{
     
   
        if ([self.delegate respondsToSelector:@selector(navigationBarViewPopController:)]) {
            [self.delegate navigationBarViewPopController:self];
        }
    
    
}
@end
