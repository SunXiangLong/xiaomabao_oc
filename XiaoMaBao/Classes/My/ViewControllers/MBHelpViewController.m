//
//  MBHelpViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/9.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBHelpViewController.h"
#import "NSString+BQ.h"
#import "MobClick.h"
@interface MBHelpViewController ()
@property (weak,nonatomic) UITableView *tableView;
@end

@implementation MBHelpViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBHelpViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBHelpViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    NSArray *titles = @[
                        @"满69元包邮",
                        @"退货/退余款政策",
                        @"满69元包邮",
                        @"退货/退余款政策",
                        ];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIView *sectionView = [[UIView alloc] init];
        if (i == 0) {
            sectionView.frame = CGRectMake(8, MARGIN_10, self.view.ml_width - 16, 20);
        }else{
            sectionView.frame = CGRectMake(8, CGRectGetMaxY([[[scrollView subviews] lastObject] frame]) + MARGIN_10, self.view.ml_width - 16, 20);
        }
        sectionView.backgroundColor = [UIColor colorWithHexString:@"24aa98"];
        sectionView.layer.cornerRadius = 3.0;
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.frame = sectionView.bounds;
        titleLbl.ml_x = MARGIN_10;
        titleLbl.text = titles[i];
        titleLbl.font = [UIFont systemFontOfSize:12];
        titleLbl.textColor = [UIColor whiteColor];
        
        [sectionView addSubview:titleLbl];
        [scrollView addSubview:sectionView];
        
        NSArray *question = @[
                              @"包邮政策1",
                              @"包邮政策2",
                              @"包邮政策3",
                              @"包邮政策4",
                              ];
        
        NSArray *answer = @[
                              @"您在小麻包购买商品时，如满足以下条件，我们将为您提供免运费的服务：",
                              @"包及以上的纸尿裤或拉拉裤",
                              @"2、其他商品购物金额满69元包邮",
                              @"3、如奶粉或其他商品的订单中包含纸尿裤或啦啦裤，则该笔订单按照纸尿裤及拉拉裤的包",
                              ];
        for (NSInteger n = 0; n < question.count; n++) {
            UILabel *questionLbl = [[UILabel alloc] init];
            questionLbl.font = [UIFont systemFontOfSize:11];
            questionLbl.text = question[n];
            questionLbl.frame = CGRectMake(MARGIN_8, CGRectGetMaxY([[[scrollView subviews] lastObject] frame]) + MARGIN_8, self.view.ml_width - 16, 15);
            [scrollView addSubview:questionLbl];
            
            UILabel *answerLbl = [[UILabel alloc] init];
            answerLbl.font = [UIFont systemFontOfSize:11];
            answerLbl.text = answer[n];
            answerLbl.textColor = [UIColor colorWithHexString:@"8c8c8c"];
            answerLbl.numberOfLines = 0;
            CGSize answerSize = [answer[n] sizeWithFont:answerLbl.font withMaxSize:CGSizeMake(self.view.ml_width - 16, MAXFLOAT)];
            answerLbl.frame = CGRectMake(MARGIN_8, CGRectGetMaxY([[[scrollView subviews] lastObject] frame]) + MARGIN_8, answerSize.width, answerSize.height);
            [scrollView addSubview:answerLbl];
        }
    }
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([[[scrollView subviews] lastObject] frame]));
}


- (NSString *)titleStr{
    return @"麻包帮助";
}

@end
