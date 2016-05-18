//
//  BkTabBarView.m
//  背包客
//
//  Created by mac on 14-9-13.
//  Copyright (c) 2014年 Make_ZL. All rights reserved.
//

#import "BkTabBarView.h"
#import "BkTabBarButton.h"
#import "CustomBadge.h"

@interface BkTabBarView ()
{
    CustomBadge *messageBadge;
}
@property (nonatomic, weak) UIButton *plusButton;
/**
 *  所有的选项卡
 */
@property (nonatomic,strong) NSMutableArray *tabBarButtons;
/**
 *  记录当前选中的按钮
 */
@property (nonatomic,weak) UIButton *currentButton;


@end

@implementation BkTabBarView

- (NSMutableArray *)tabBarButtons{
    if (!_tabBarButtons) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

/**
 *  加号按钮的懒加载
 */
- (UIButton *)plusButton
{
    if (!_plusButton) {
        UIButton *plusButton = [[UIButton alloc] init];
        // 设置背景
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        // 设置图标
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        
        [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        // 添加
        [self addSubview:plusButton];
        self.plusButton = plusButton;
    }
    return _plusButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置背景
        [self setupBg];
    }
    return self;
}

/**
 *  设置背景
 */
- (void)setupBg
{
    if (!iOS_7) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

/**
 *  点击了加号按钮
 */
- (void)plusClick
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}


/**
 *  添加一个选项卡按钮
 *
 *  @param item 选项卡按钮对应的模型数据(标题\图标\选中的图标)
 */
- (void)addTabBarButton:(UITabBarItem *)item{
    BkTabBarButton *tabBarButton = [[BkTabBarButton alloc] init];
    tabBarButton.item = item;
    tabBarButton.tag = self.tabBarButtons.count;
    [tabBarButton addTarget:self action:@selector(clickTap:) forControlEvents:UIControlEventTouchDown];
    [self.tabBarButtons addObject:tabBarButton];
    [self addSubview:tabBarButton];
    
    if (self.tabBarButtons.count == 2) {
        [self clickTap:tabBarButton];
    }
    
    if (self.tabBarButtons.count== 4) {
        messageBadge = [CustomBadge customBadgeWithString:@"0" withStyle:[BadgeStyle defaultStyle]];
        
        [tabBarButton addSubview:messageBadge];

        NSString *badgeValue =  [User_Defaults objectForKey:@"messageNumber"];
       
        if (badgeValue&&[badgeValue intValue]>0) {
            [messageBadge autoBadgeSizeWithString:badgeValue];
            messageBadge.hidden = NO;
        }else{
            messageBadge.hidden = YES;
        }

        [messageBadge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(messageBadge.ml_width,  messageBadge.ml_height));
            make.centerX.equalTo(tabBarButton.mas_centerX).offset(8);
            make.top.mas_equalTo(3);
        }];
        
     
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBadge:) name:@"messageBadge" object:nil];
        
    }
}
- (void)messageBadge:(NSNotification *)notificat{
   NSString *badgeValue =  [User_Defaults objectForKey:@"messageNumber"];
    if (badgeValue&&[badgeValue intValue]>0) {
     [messageBadge autoBadgeSizeWithString:badgeValue];
    messageBadge.hidden = NO;
    }else{
     messageBadge.hidden = YES;
    }

}
- (void) clickTap:(UIButton *) tabBarBtn{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectButtonFrom:self.currentButton.tag to:tabBarBtn.tag];
    }
     [self playBounceAnimation:tabBarBtn.imageView];
    // 选中状态
    self.currentButton.selected = NO;
    tabBarBtn.selected = YES;
    self.currentButton = tabBarBtn;
   
}
#pragma mark -- tabbar上icon被点击时动画。
- (void)playBounceAnimation:(UIImageView *)icon{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.6; // 动画持续时间
    animation.calculationMode = kCAAnimationCubic; // 重复次数
    NSNumber *num1 = [NSNumber numberWithFloat:1.0];
    NSNumber *num2 = [NSNumber numberWithFloat:1.4];
    NSNumber *num3 = [NSNumber numberWithFloat:0.9];
    NSNumber *num4 = [NSNumber numberWithFloat:1.15];
    NSNumber *num5 = [NSNumber numberWithFloat:0.95];
    NSNumber *num6 = [NSNumber numberWithFloat:1.02];
    animation.values = @[num1,num2,num3,num4,num5,num6,num1];
    
    
    // 添加动画
    [icon.layer addAnimation:animation forKey:@"scale-layer"];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置选项卡按钮的位置和尺寸
    [self setupTabBarButtonFrame];
}


/**
 *  设置选项卡按钮的位置和尺寸
 */
- (void)setupTabBarButtonFrame
{
    NSInteger count = self.tabBarButtons.count;
    CGFloat buttonW = self.ml_width / count;
    CGFloat buttonH = self.ml_height;
    for (int i = 0; i < count; i++) {
        BkTabBarButton *button = self.tabBarButtons[i];
        button.ml_width = buttonW;
        button.ml_height = buttonH;
        button.ml_x = buttonW * i;
        button.ml_y = 0;
        
    }
}
@end
