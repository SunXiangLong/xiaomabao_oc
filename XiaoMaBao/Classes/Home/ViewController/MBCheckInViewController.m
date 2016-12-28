//
//  MBCheckInViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/18.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBCheckInViewController.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
#import "ZLDateView.h"
#import "MBSignRoleView.h"
@interface MBCheckInViewController ()

@property (weak, nonatomic) IBOutlet UIView *calendarBottomView;
@property (weak, nonatomic) IBOutlet ZLDateView *calendarView;
@property (weak, nonatomic) IBOutlet UIView *shareTimeView;
@property (weak, nonatomic) IBOutlet UIView *monthDayView;
- (IBAction)SignClick;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *msgLbl;
@property (strong,nonatomic) NSArray *weeks;
@end

@implementation MBCheckInViewController


- (void)viewDidLoad {
    [super viewDidLoad];

  
    self.calendarBottomView.backgroundColor = [UIColor colorWithRed:126/256.0 green:156/256.0 blue:172/256.0 alpha:0.5];
    self.shareTimeView.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:165.0/255.0 blue:193.0/255.0 alpha:0.7];
    self.calendarView.backgroundColor = [UIColor colorWithRed:157.0/255.0 green:193.0/255.0 blue:213.0/255.0 alpha:0.5];
   
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月";
    self.timeLbl.text = [fmt stringFromDate:date];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self refreshCalendarView];
    [self setupBottomView];
}
-(NSString *)leftImage{
return @"nav_back";

}
-(void)leftTitleClick{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)setupBottomView{
    NSArray *bottomCalendarTitles = @[@"今天",@"签到成功"];
    
    NSInteger count = bottomCalendarTitles.count;
    CGFloat width = (self.calendarBottomView.ml_width - MARGIN_20) / count;
    
    for (NSInteger i = 0; i < count; i++) {
        UIView *bottomRangeView = [[UIView alloc] init];
        bottomRangeView.frame = CGRectMake(i * width + MARGIN_20, 0, width, self.calendarBottomView.ml_height);
        [self.calendarBottomView addSubview:bottomRangeView];
        
        UIView *calendarBottomMakeView = nil;
        if (i == 0) {
            calendarBottomMakeView = [[UIView alloc] init];
            calendarBottomMakeView.layer.cornerRadius = 7.5;
            calendarBottomMakeView.layer.borderWidth = 1;
            calendarBottomMakeView.layer.borderColor = [UIColor whiteColor].CGColor;
            calendarBottomMakeView.backgroundColor = [UIColor clearColor];
            calendarBottomMakeView.frame = CGRectMake(0, (bottomRangeView.ml_height - 15) * 0.5, 15, 15);
            [bottomRangeView addSubview:calendarBottomMakeView];
            
        }else {
            calendarBottomMakeView = [[UIView alloc] init];
            calendarBottomMakeView.layer.cornerRadius = 7.5;
            calendarBottomMakeView.frame = CGRectMake(0, (bottomRangeView.ml_height - 15) * 0.5, 15, 15);
            [bottomRangeView addSubview:calendarBottomMakeView];
            calendarBottomMakeView.backgroundColor = [UIColor redColor];
        }
        
        UILabel *calendarBottomLabel = [[UILabel alloc] init];
        calendarBottomLabel.frame = CGRectMake(CGRectGetMaxX(calendarBottomMakeView.frame) + 8, 0, width, self.calendarBottomView.ml_height);
        calendarBottomLabel.textColor = [UIColor whiteColor];
        calendarBottomLabel.font = [UIFont systemFontOfSize:12];
        calendarBottomLabel.text = bottomCalendarTitles[i];
        [bottomRangeView addSubview:calendarBottomLabel];
    }
    
    
    NSArray *month = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat monthWidth = self.view.frame.size.width / month.count;
    [month enumerateObjectsUsingBlock:^(NSString *day, NSUInteger idx, BOOL *stop) {
        UILabel *monthLbl = [[UILabel alloc] init];
        monthLbl.textColor = [UIColor whiteColor];
        monthLbl.font = [UIFont boldSystemFontOfSize:12];
        monthLbl.textAlignment = NSTextAlignmentCenter;
        monthLbl.text = day;
        monthLbl.frame = CGRectMake(monthWidth * idx, 0, monthWidth, self.monthDayView.frame.size.height);
        [self.monthDayView addSubview:monthLbl];
    }];
}

- (void)refreshCalendarView{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/promote/get_sign_days") parameters:@{@"session":dict} success:^(id responseObject) {
        
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"][@"succeed"] integerValue] == 1) {
            
            self.calendarView.datys = responseObject[@"data"][@"days"];
            // 刷新lbl
            NSString *msgLbl = [NSString stringWithFormat:@"我的可用麻豆为%@麻豆",responseObject[@"data"][@"sign_score"]];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:msgLbl];
            
            NSString *pattern = @"\\d+";
            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *result = [regex firstMatchInString:msgLbl options:NSMatchingReportProgress range:NSMakeRange(0, msgLbl.length)];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
            self.msgLbl.attributedText = attr;
            
            if ([responseObject[@"data"][@"signed"] integerValue] != 0) {
                
                // 刷新btn
                [self.signButton setImage:[UIImage imageNamed:@"signed_circle_btn"] forState:UIControlStateNormal];
            }

        }else{
            NSString *errorStr = responseObject[@"status"][@"error_desc"];
            if (errorStr) {
                [self show:errorStr time:.8];
            }else{
                [self show:@"未知错误" time:.8];
            }
        
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:.5];
    }];
    
}

- (NSString *)titleStr{
    return @"签到";
}

- (IBAction)signRoleClick:(UIButton *)sender {
    UIView* maskView = [UIView new];
    CGFloat width  = self.view.frame.size.width * 0.95 ;
    CGFloat height = 180 ;
    maskView.center = self.view.center ;
    maskView.bounds = self.view.frame;
    [self.view addSubview:maskView];
    
    UIControl* mask = [UIControl new];
    [mask addTarget:self action:@selector(hiddenRole:) forControlEvents:UIControlEventTouchDown];
    mask.frame = maskView.bounds ;
    mask.backgroundColor = [UIColor darkGrayColor];
    mask.alpha = 0.85 ;
    [maskView addSubview:mask];
    
    MBSignRoleView* signRoleView = [[MBSignRoleView alloc]init];
    [signRoleView addTarget:self action:@selector(hiddenRole:) forControlEvents:UIControlEventTouchDown];

    signRoleView.bounds = CGRectMake(0,0, width, height);

    signRoleView.center = maskView.center ;
    [maskView addSubview:signRoleView];
}

#pragma mark - 隐藏签到规则
-(void)hiddenRole:(UIControl*)sender{
    [sender.superview removeFromSuperview];
}


- (IBAction)SignClick {
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/promote/sign"] parameters:@{@"session":dict} success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
        
        if ([[responseObject.status valueForKey:@"succeed"] integerValue] == 0) {
            [self show:responseObject.status[@"error_desc"] time:1];
        }else{
            [self show:@"签到成功! 您每天继续来签到吧!" time:1];
            [self refreshCalendarView];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
    }];
}
@end
