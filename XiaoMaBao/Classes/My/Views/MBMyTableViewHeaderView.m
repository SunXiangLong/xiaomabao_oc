//
//  MBMyTableViewHeaderView.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBMyTableViewHeaderView.h"
#import "BkTabBarButton.h"
#import "MBOrderListViewController.h"

@interface MBMyTableViewHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *menuItemView;
@end

@implementation MBMyTableViewHeaderView

- (void)awakeFromNib{
    
    //绘制顶部菜单
    UIView *headerView = [[UIView alloc] init];
    CGFloat width_all = [UIScreen mainScreen].bounds.size.width;
    headerView.backgroundColor = [UIColor colorWithHexString:@"F0FFFF"];
    headerView.frame = CGRectMake(0,0, width_all, 92);
    
    UIImage *Image = [UIImage imageNamed:@"placeholder_num2"] ;
    self.leftImageView = [[UIImageView alloc ]init];
    
    self.leftImageView.image = Image;
    self.leftImageView.frame = CGRectMake(15, 12, 70, 70);
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftImageView.layer.cornerRadius = 35;
    self.leftImageView.layer.masksToBounds = YES;
    [headerView addSubview:self.leftImageView];
    
    CGFloat h_w = (width_all - 15 - 70 - MARGIN_8 - MARGIN_10)*0.5;
    
    self.score = [[UILabel alloc] init];
    self.score.frame = CGRectMake(15+70+MARGIN_8, 20,h_w, 18);
    self.score.font = [UIFont systemFontOfSize:15];
    self.score.text = @"积分：0";
    [headerView addSubview:self.score];
    
    self.myPosts = [[UILabel alloc] init];
    self.myPosts.frame = CGRectMake(15+70+h_w, 20,h_w, 18);
    self.myPosts.font = [UIFont systemFontOfSize:15];
    self.myPosts.text = @"我的动态：0";
    [headerView addSubview:self.myPosts];
    
    self.follow = [[UILabel alloc] init];
    self.follow.frame = CGRectMake(15+70+MARGIN_8, 50,h_w, 18);
    self.follow.font = [UIFont systemFontOfSize:15];
    self.follow.text = @"关注：0";
    [headerView addSubview:self.follow];
    
    self.fans = [[UILabel alloc] init];
    self.fans.frame = CGRectMake(15+70+h_w, 50,h_w, 18);
    self.fans.font = [UIFont systemFontOfSize:15];
    self.fans.text = @"粉丝：0";
    [headerView addSubview:self.fans];
    
    [self addSubview:headerView];
    
    NSArray *menuItemTitles = @[
                                @"待付款",
                                @"待发货",
                                @"已发货",
                                @"待评价",
                                @"退换货"
                                ];
    
    NSArray *menuItemImages = @[
                                @"bankCard",
                                @"daifahuo",
                                @"yifahuo",
                                @"evaluate",
                                @"tuihuanhuo"
                                ];
   
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / menuItemTitles.count;
    for (NSInteger i = 0; i < menuItemTitles.count; i++) {
        BkTabBarButton *menuBtn = [BkTabBarButton buttonWithType:UIButtonTypeCustom];
        menuBtn.tag = i;
        [menuBtn setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [menuBtn setTitle:menuItemTitles[i] forState:UIControlStateNormal];
        [menuBtn setImage:[UIImage imageNamed:menuItemImages[i]] forState:UIControlStateNormal];
        menuBtn.frame = CGRectMake(i * width, 0, width, 44);
        
        [menuBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.menuItemView addSubview:menuBtn];
    }
}

+ (instancetype)instanceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MBMyTableViewHeaderView" owner:nil options:nil] lastObject];
}


- (IBAction)onClick:(UIButton *)button {
    
    
    
    NSString * order_status = [NSString stringWithFormat:@"%ld",button.tag+1];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:order_status,@"order_status",nil];
    //创建通知
    NSNotification *notification = [NSNotification notificationWithName:@"tabBtnClick" object:nil userInfo:dict];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
