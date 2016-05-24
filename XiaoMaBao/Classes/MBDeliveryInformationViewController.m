//
//  MBDeliveryInformationViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/2.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBDeliveryInformationViewController.h"
#import "MobClick.h"
#import "MBRefundScheduleViewController.h"
@interface MBDeliveryInformationViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *photo;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *CourierNumber;

@property (weak, nonatomic) IBOutlet UITextField *CourierFees;


@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation MBDeliveryInformationViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBDeliveryInformationViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBDeliveryInformationViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    
}
- (void)setUI{
    self.titleStr = @"填写发货信息";

    _scrollView.contentSize =CGSizeMake(UISCREEN_WIDTH, UISCREEN_HEIGHT);
    _topView.ml_width = UISCREEN_WIDTH;
    _topView.ml_x = 0; _topView.ml_y=0;
    [_scrollView addSubview:_topView];
    
    
    _bottomView.ml_width = UISCREEN_WIDTH;
    _bottomView.ml_x = 0; _bottomView.ml_y = _topView.ml_height;
    [_scrollView addSubview:_bottomView];
    
    if ([self.back_tax isKindOfClass:[NSNumber class]]) {
        
        if ([self.back_tax isEqualToNumber:@0 ]) {
            [_CourierFees removeFromSuperview];
            [_lable removeFromSuperview];
            _top.constant = 10;
        }
        
    }else{
        if ([self.back_tax isEqualToString:@"0"]) {
            [_CourierFees removeFromSuperview];
            [_lable removeFromSuperview];
            _top.constant = 10;
        }
    }
    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(UIButton *)sender {
    [self setResignFirstResponder];
}

- (IBAction)determine:(UIButton *)sender {
    [self setResignFirstResponder];
    if (!_CourierNumber.text) {
        [self show:@"快递单号不能为空" time:1];
        return;
    }
    [self submitData];
}
#pragma mark -- UIScrollViewdelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [self setResignFirstResponder];
}

-(void)setResignFirstResponder{
    [self.CourierNumber resignFirstResponder];
    [self.CourierFees  resignFirstResponder];
    

}

- (void)submitData{
    
   
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSString *str;
    if (_CourierFees.text) {
        str = _CourierFees.text;
    }else{
        str = @"";
    }
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
     [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"refund/submitLogistics"] parameters:@{@"session":sessiondict,@"order_id":_order_id,@"logistics_no":_CourierNumber.text,@"logistics_cost":str}success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
       // NSLog(@"填写运单号成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
 
        
        [self show:[responseObject valueForKeyPath:@"status"][@"error_desc"] time:1];
        
        NSString *section = [NSString stringWithFormat:@"%ld",(long)self.section];
        NSDictionary *reduce = @{@"refund":@"2",@"section":section};
        NSNotification *notification =[NSNotification notificationWithName:@"Refund_status" object:nil userInfo:reduce];
        
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];

        MBRefundScheduleViewController   *VC = [[MBRefundScheduleViewController alloc] init];
        VC.type = @"1";
        VC.order_sn = self.order_sn;
        VC.orderid = self.order_id;
        [self.navigationController pushViewController:VC animated:YES];
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
        NSLog(@"%@",error);
        
    }
     ];
    
}

@end
