//
//  MBUserFeedBackViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/8.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBUserFeedBackViewController.h"
#import "MobClick.h"
@interface MBUserFeedBackViewController ()<UITextViewDelegate>
@property (weak,nonatomic) UILabel *evaluateLbl;
@end

@implementation MBUserFeedBackViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBUserFeedBackViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBUserFeedBackViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(8, TOP_Y + MARGIN_20, self.view.ml_width - 16, 115);
    textView.contentInset = UIEdgeInsetsMake(5, 5, 0, 0);
    textView.delegate = self;
    textView.layer.cornerRadius = 5.0;
    textView.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    textView.layer.borderWidth = 1;
    [self.view addSubview:textView];
    
    UILabel *evaluateLbl = [[UILabel alloc] init];
    evaluateLbl.text = @"亲，您遇到什么问题啦？或者有什么建议吗？欢迎您提给我们";
    evaluateLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    evaluateLbl.font = [UIFont systemFontOfSize:15];
    evaluateLbl.frame = CGRectMake(15, textView.ml_y + 10, self.view.ml_width - 30, 20);
    [self.view addSubview:_evaluateLbl = evaluateLbl];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(35, CGRectGetMaxY([textView frame]) + 25, self.view.ml_width - 70, 35);
    [doneBtn setTitle:@"提交" forState:UIControlStateNormal];
    doneBtn.backgroundColor = [UIColor colorWithHexString:@"2ba390"];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    doneBtn.layer.cornerRadius = 17;
    [self.view addSubview:doneBtn];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.evaluateLbl.hidden = textView.text.length > 0;
}

- (NSString *)titleStr{
    return @"用户反馈";
}

@end
