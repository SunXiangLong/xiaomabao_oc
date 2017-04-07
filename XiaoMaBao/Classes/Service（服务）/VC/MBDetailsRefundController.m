//
//  MBDetailsRefundController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBDetailsRefundController.h"
#import "MBMyServiceChilderViewController.h"
@interface MBDetailsRefundController ()

@property (weak, nonatomic) IBOutlet UILabel *priceLable;


@end

@implementation MBDetailsRefundController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBDetailsRefundController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBDetailsRefundController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.priceLable.text = self.price;
    
    //覆盖侧滑手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.navigationController.view  addGestureRecognizer:pan];
    
}
-(void)back{
    
    
}

-(NSString *)titleStr{
    return @"退款详情";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    NSArray *arr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:arr[arr.count-4] animated:YES];
    NSNotification *notification =[NSNotification notificationWithName:@"HYTPopViewControllerNotification" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return    nil;
   
    
    
    
    
}
@end
