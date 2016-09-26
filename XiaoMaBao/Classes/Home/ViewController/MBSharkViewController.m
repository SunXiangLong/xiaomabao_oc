//
//  MBSharkViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/17.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSharkViewController.h"
#import "MBNetworking.h"
#import "MBUserDataSingalTon.h"
#import "MBSignaltonTool.h"
#import "UIImageView+WebCache.h"
#import "MBSwing.h"
#import "MJExtension.h"
#import <AVFoundation/AVFoundation.h>
@interface MBSharkViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLbl;
@property (weak,nonatomic) UIView *maskView;
@property (assign,nonatomic) NSInteger swingCount;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong,nonatomic) MBSwing *swing;

@property (weak,nonatomic) UIButton *checkBtn;
@property (weak,nonatomic) UIButton *agianBtn;
@property (weak,nonatomic) UIButton *shareBtn;

@property (weak, nonatomic) UIView *sharkView;

@end

@implementation MBSharkViewController

- (UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.view.bounds;
        [self.view addSubview:maskView];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.maskView = maskView;
    }
    return _maskView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self getSwingTimes:NO];//获取摇奖次数
    [self getPrizeUser];//获取中奖信息
}
- (void)getPrizeUser{
    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    
    if (userInfo != nil && [userInfo valueForKey:@"uid"] != nil) {
        NSDictionary *dict = @{@"uid":[userInfo valueForKey:@"uid"],@"sid":[userInfo valueForKey:@"sid"]};
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/promote/get_remote_reward"] parameters:@{@"session":dict} success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
            NSString* header_img = [responseObject.data valueForKey:@"header_img"];
            if (![header_img isKindOfClass:[NSNull class]]) {
                [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:header_img]];
            }
            
            self.titleLbl.text = [NSString stringWithFormat:@"恭喜“%@” 摇中了%@",[responseObject.data valueForKey:@"nick_name"],[responseObject.data valueForKey:@"type_name"]];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd"];
            NSString *str = [NSString stringWithFormat:@"%@",
                             [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[responseObject.data valueForKey:@"prize_time"] integerValue]]]];
            
            self.timeLbl.text = str;
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }
}

- (void)getSwingTimes:(BOOL )isonce{
    [self show];
    if (isonce) {
          AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    if (userInfo != nil && [userInfo valueForKey:@"uid"] != nil) {
        NSDictionary *dict = @{@"uid":[userInfo valueForKey:@"uid"],@"sid":[userInfo valueForKey:@"sid"]};
        [MBNetworking POSTOrigin:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/promote/get_remain_swing"] parameters:@{@"session":dict} success:^(id responseObject) {
            if (!isonce) {
                [self dismiss];
            }
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dic = (NSDictionary*)responseObject ;
                NSDictionary* dDate = [dic objectForKey:@"data"];
                int rest_count = (int)[dDate[@"rest_count"] integerValue];
                self.tipLbl.text = [NSString stringWithFormat:@"还可以摇%d次",rest_count];
                self.swingCount = rest_count ;
                if (isonce) {
                    [self startSwing];
                }
               
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self dismiss];
        }];
    }
}
-(NSString *)leftImage{
    return @"nav_back";
    
}
-(void)leftTitleClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)showSharkWinning:(BOOL)winning{
    UIView *sharkView = [[UIView alloc] init];
    sharkView.backgroundColor = [UIColor whiteColor];
    sharkView.frame = CGRectMake(35, (self.view.frame.size.height - 180)  * 0.5, self.view.frame.size.width - 70, 160);
    sharkView.layer.cornerRadius = 3.0;
    [self.maskView addSubview:_sharkView=sharkView];
    
    UIImageView *authorImgView = [[UIImageView alloc] init];
    authorImgView.backgroundColor = [UIColor colorWithHexString:@"b0d3e9"];
    authorImgView.frame = CGRectMake(15, 15, 80, 80);
    authorImgView.layer.cornerRadius = 40;
    [sharkView addSubview:authorImgView];
    
    UILabel *prizeName = [[UILabel alloc] init];
    prizeName.textColor = [UIColor colorWithHexString:@"e8455d"];
    prizeName.frame = CGRectMake(CGRectGetMaxX(authorImgView.frame) + MARGIN_10, authorImgView.frame.origin.y, sharkView.frame.size.width - CGRectGetMaxX(authorImgView.frame) + MARGIN_10,authorImgView.frame.size.height);
    prizeName.font = [UIFont systemFontOfSize:16];
    [sharkView addSubview:prizeName];
    
    UILabel *prizeDetailName = [[UILabel alloc] init];
    prizeDetailName.textColor = [UIColor colorWithHexString:@"e8455d"];
    prizeDetailName.frame = CGRectMake(prizeName.frame.origin.x , CGRectGetMaxY(prizeName.frame) * 0.5 + MARGIN_20, prizeName.frame.size.width,15);
    prizeDetailName.font = [UIFont systemFontOfSize:10];
    [sharkView addSubview:prizeDetailName];
    
    UILabel *msgLbl = [[UILabel alloc] init];
    msgLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    msgLbl.frame = CGRectMake(10, CGRectGetMaxY(authorImgView.frame) + MARGIN_10, sharkView.frame.size.width - 20,15);
    msgLbl.font = [UIFont systemFontOfSize:10];
    [sharkView addSubview:msgLbl];
    
    if (!winning) {
        // 文案
        prizeName.text = [NSString stringWithFormat:@"呃，没摇到~"];
        prizeDetailName.text = @"没关系，机会到处有！";
        msgLbl.text = @"每天可以有3次摇将的机会！";
        msgLbl.textAlignment = NSTextAlignmentCenter;
        
        UIButton *agianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        agianBtn.frame = CGRectMake(0, sharkView.ml_height - 35, sharkView.ml_width, 35);
        [agianBtn setTitle:@"再摇一次" forState:UIControlStateNormal];
        agianBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        agianBtn.backgroundColor = [UIColor colorWithHexString:@"e8455d"];
        [agianBtn addTarget:self action:@selector(closeDialog) forControlEvents:UIControlEventTouchUpInside];
        [sharkView addSubview:_agianBtn = agianBtn];
        
    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *startTime = [NSString stringWithFormat:@"%@",
                               [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.swing.send_start_date integerValue]]]];
        NSString *endTime = [NSString stringWithFormat:@"%@",
                               [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.swing.send_end_date integerValue]]]];
        
        prizeName.text = [NSString stringWithFormat:@"哇！棒着呢~"];
        prizeDetailName.text = [NSString stringWithFormat:@"恭喜摇到%@！",self.swing.type_name];
        msgLbl.text = [NSString stringWithFormat:@"有效期：%@~%@",startTime,endTime];
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = CGRectMake(0, sharkView.ml_height - 35, sharkView.ml_width * 0.5, 35);
        [checkBtn setTitle:@"查 看" forState:UIControlStateNormal];
        checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        checkBtn.backgroundColor = [UIColor colorWithHexString:@"e8455d"];
        [sharkView addSubview:_checkBtn = checkBtn];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(sharkView.ml_width * 0.5, sharkView.ml_height - 35, sharkView.ml_width * 0.5, 35);
        [shareBtn setTitle:@"分 享" forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        shareBtn.backgroundColor = [UIColor colorWithHexString:@"c33a4e"];
        [sharkView addSubview:_shareBtn = shareBtn];
    }
    
}

- (void)closeDialog{
    if(_maskView){
        [_maskView removeFromSuperview ];
        [self getSwingTimes:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.maskView) {
        [self.maskView removeFromSuperview];
    }
    
}

#pragma mark - 摇一摇相关方法
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    MMLog(@"开始摇动");
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    MMLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        [self getSwingTimes:YES];
    }
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startSwing{

 
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        
        if (self.swingCount <= 0) {
            [self show:@"您今天的次数已经用光了~" time:1];
            return ;
        }
        
   
        MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
        if (userInfo != nil && [userInfo valueForKey:@"uid"] != nil) {
            NSDictionary *dict = @{@"uid":[userInfo valueForKey:@"uid"],@"sid":[userInfo valueForKey:@"sid"]};
            [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/promote/swing"] parameters:@{@"session":dict} success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                 [self dismiss];
                self.swing = [MBSwing objectWithKeyValues:responseObject.data];
                if ([[responseObject.data allValues] count] == 0) {
                    // 没中奖
                    [self showSharkWinning:NO];
                }else{
                    [self showSharkWinning:YES];
                }
               
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [self show:@"请求失败" time:1];
            }];
        }
        
//    });
    
    
}

- (NSString *)titleStr{
    return @"摇一摇";
}

@end
