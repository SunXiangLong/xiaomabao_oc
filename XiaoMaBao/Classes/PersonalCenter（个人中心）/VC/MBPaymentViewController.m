//
//  MBPaymentViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBPaymentViewController.h"
#import "MBGoodSSearchViewController.h"
#import "MBOrderInfoTableViewController.h"
#import "MBServiceSearchViewController.h"
#import "MBMyServiceController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "MBPayResultsController.h"
#import "MBPaySuccessView.h"
#import "MBOrderListViewController.h"
#import "MBServiceShopsViewController.h"
#import "MBNewHomeViewController.h"
#import "MBNewMyViewController.h"
#import "MBElectronicCardOrderInfoVC.h"
#import "MBGiftCardViewController.h"
#import "MBElectronicCardOrderVC.h"
@interface MBPaymentViewController ()<UIAlertViewDelegate>
{
    NSString *_creatOrderId;
    int  _fight;
    UIButton *_PayButton;
    UIButton *_WeChatButton;
    NSString *_success;
}

@end

@implementation MBPaymentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wayPay:) name:@"wayPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPay:) name:@"alipayPay" object:nil];
    
    //覆盖侧滑手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.navigationController.view  addGestureRecognizer:pan];
    
    switch (_type) {
        case 3:{
            if ([_orderInfo[@"pay_status"] integerValue] == 0) {
                [self createView];
            }else{
                [self successView];
                
            }
        }break;
        default:{
            
            if ([_orderInfo[@"order_amount"]  floatValue] > 0) {
                [self createView];
            }else{
                [self successView];
                
            }
        }break;
    }
    
}
/**
 *  支付成功的view视图
 */
- (void)successView{
    self.navBar.back = NO;
    MBPaySuccessView *PaySuccessView = [MBPaySuccessView instanceView];
    PaySuccessView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y);
    [self.view addSubview:PaySuccessView];
    [PaySuccessView.shopButton addTarget:self action:@selector(shop) forControlEvents:UIControlEventTouchUpInside];
    [PaySuccessView.orderButton addTarget:self action:@selector(jumpOrderDetails) forControlEvents:UIControlEventTouchUpInside];
}


-(void)createView
{
    UILabel *promptLbl = [[UILabel alloc] init];
    promptLbl.font = [UIFont systemFontOfSize:14];
    promptLbl.textColor = [UIColor colorWithHexString:@"323232"];
    promptLbl.textAlignment = NSTextAlignmentCenter;
    promptLbl.text = @"下单成功，请于2小时内支付，超时未付款订单将被取消";
    promptLbl.frame = CGRectMake(0, TOP_Y, self.view.ml_width, 45);
    [self.view addSubview:promptLbl];
    
    // 订单View
    UIView *orderView = [[UIView alloc] init];
    orderView.backgroundColor = [UIColor whiteColor];
    orderView.frame = CGRectMake(0, CGRectGetMaxY(promptLbl.frame), self.view.ml_width, 45);
    [self.view addSubview:orderView];
    
    UILabel *orderLbl = [[UILabel alloc] init];
    orderLbl.frame = CGRectMake(MARGIN_8, 0, self.view.ml_width, promptLbl.ml_height);
    orderLbl.textColor = [UIColor colorWithHexString:@"323232"];
    orderLbl.font = [UIFont systemFontOfSize:14];
    orderLbl.text =  string(@"订单号：", _orderInfo[@"order_sn"]);
    [self addTopLineView:orderView];
    [orderView addSubview:orderLbl];
    UIImageView *orderImgView = [[UIImageView alloc] init];
    orderImgView.frame = CGRectMake((orderView.ml_width - 16 - MARGIN_8), (orderView.ml_height - 16) * 0.5, 16, 16);
    [orderView addSubview:orderImgView];
    orderView.userInteractionEnabled = YES;
    if (_type != 2) {
        orderImgView.image = [UIImage imageNamed:@"next"];
        UITapGestureRecognizer *ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderInfoClick:)];
        [orderView addGestureRecognizer:ger];
    }
    
    
    
    // 支付方式View
    UIView *paymentMethodView = [[UIView alloc] init];
    paymentMethodView.backgroundColor = [UIColor whiteColor];
    paymentMethodView.frame = CGRectMake(0, CGRectGetMaxY(orderView.frame), self.view.ml_width, 45);
    [self.view addSubview:paymentMethodView];
    
    UILabel *paymentMethodLbl = [[UILabel alloc] init];
    paymentMethodLbl.frame = CGRectMake(MARGIN_8, 0, self.view.ml_width, promptLbl.ml_height);
    paymentMethodLbl.textColor = [UIColor colorWithHexString:@"323232"];
    paymentMethodLbl.font = [UIFont systemFontOfSize:14];
    paymentMethodLbl.text = @"请选择支付方式：";
    [paymentMethodView addSubview:paymentMethodLbl];
    [self addBottomLineView:paymentMethodView];
    [self addTopLineView:paymentMethodView];
    NSArray *titles = @[
                        @"支付宝客户端支付",
                        @"微信客户端支付"
                        ];
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi])
    {
        titles = @[@"支付宝客户端支付"];
    }
    for (NSInteger i = 0; i < titles.count; i++) {
        UIView *payListView = [[UIView alloc] init];
        payListView.backgroundColor = [UIColor whiteColor];
        payListView.frame = CGRectMake(0, CGRectGetMaxY([[[self.view subviews] lastObject] frame]), self.view.ml_width, 45);
        [self.view addSubview:payListView];
        UIButton *payListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        payListBtn.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN_8, 0, 0);
        [payListBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pay%ld",(long)i+1]] forState:UIControlStateNormal];
        payListBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        payListBtn.frame = CGRectMake(MARGIN_8, 0, self.view.ml_width, payListView.ml_height);
        [payListBtn setTitleColor:[UIColor colorWithHexString:@"323232"] forState:UIControlStateNormal];
        payListBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [payListBtn setTitle:titles[i] forState:UIControlStateNormal];
        [payListView addSubview:payListBtn];
        
        UIButton  *payListButton = [UIButton buttonWithType:UIButtonTypeCustom ];
        payListButton.frame =  CGRectMake(MARGIN_8, 0, self.view.ml_width, payListView.ml_height);
        payListButton.imageEdgeInsets = UIEdgeInsetsMake( MARGIN_8,CGRectGetMaxX(payListView.frame)-80, 0, 0);
        [payListButton setImage:[UIImage imageNamed:@"icon_true"] forState:UIControlStateNormal];
        [payListButton setImage: [UIImage imageNamed:@"pitch_no"]forState:UIControlStateSelected];
        payListButton.selected = YES;
        payListButton.tag = i;
        [payListButton addTarget:self action:@selector(ChoicePayment:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            payListButton.selected = NO;
            _PayButton = payListButton;
        }else if(i==1){
            
            _WeChatButton = payListButton;
        }
        
        [payListView addSubview:payListButton];
        
        [self addBottomLineView:payListView];
    }
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    CGFloat tabbarHeight = 45;
    bottomView.frame = CGRectMake(0, self.view.ml_height - tabbarHeight, self.view.ml_width, tabbarHeight);
    CGFloat submitButtonWidth = 70;
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(self.view.ml_width - submitButtonWidth, 0, submitButtonWidth, bottomView.ml_height);
    submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitButton setTitle:@"付款" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor colorWithHexString:@"e8455d"];
    [bottomView addSubview:submitButton];
    //点击确认订单
    [submitButton addTarget:self action:@selector(MethodPayment) forControlEvents:UIControlEventTouchUpInside];
    //应付金额
    UILabel *paymentLbl = [[UILabel alloc] init];
    paymentLbl.frame = CGRectMake(MARGIN_8, 0, self.view.ml_width-submitButtonWidth, bottomView.ml_height);
    paymentLbl.textColor = [UIColor colorWithHexString:@"323232"];
    paymentLbl.font = [UIFont systemFontOfSize:14];
    paymentLbl.text = [NSString stringWithFormat:@"应付金额：¥%@",_orderInfo[@"order_amount"]];
    
    [bottomView addSubview:paymentLbl];
    [self addTopLineView:bottomView];
    [self.view addSubview:bottomView];
    
}

#pragma mark --- 选择支付方式
- (void)ChoicePayment:(UIButton *)button{
    
    switch (button.tag) {
        case 0 :
            _fight = 0;  button.selected = NO; _WeChatButton.selected = YES; break;
        case 1 :
            
            _fight = 1;   button.selected = NO; _PayButton.selected = YES; break;
        default:
            break;
    }
    
}

-(void)MethodPayment{
    switch (_fight) {
        case 0:   [self payForMoney];  break;
        case 1:   [self wxpay];         break;
        default:                       break;
    }
    
}
-(void)orderInfoClick:(UITapGestureRecognizer *)ger{
    MBOrderInfoTableViewController  *infoVC =  [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBOrderInfoTableViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:infoVC];
    switch (_type) {
        case 1:{
            infoVC.parent_order_sn = _orderInfo[@"order_sn"];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }break;
        case 3:{
            MBElectronicCardOrderInfoVC  *VC =  [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBElectronicCardOrderInfoVC"];
            VC.orderSn = self.orderInfo[@"order_sn"];
            [self pushViewController:VC Animated:true];
            
        }break;
            
        default:break;
    }
    
    
}

#pragma mark -- 第三方支付  支付宝
- (void)payForMoney{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url;
    switch (_type ) {
        case 1:{url = string(@"http://api.xiaomabao.com/pay/goods/" , _orderInfo[@"order_sn"]);}break;
        case 2:{url = string(@"http://api.xiaomabao.com/pay/service/", _orderInfo[@"order_sn"]);}break;
        case 3:{url = string(@"http://api.xiaomabao.com/pay/giftcard/", _orderInfo[@"order_sn"]);}break;
        default:
            break;
    }
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types(用于从支付宝返回自己的app)
    NSString *appScheme = @"xiaomabao";
    [MBNetworking   POSTOrigin:url  parameters:@{@"session":sessiondict} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"] intValue] != 0) {
            [self show:responseObject[@"info"] time:1];
            return ;
        }
        if (responseObject[@"data"]) {
            [[AlipaySDK defaultService] payOrder:responseObject[@"data"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
                    [self alert:@"提示" msg:@"支付成功" success:@"1"];
                }else{
                    [self alert:@"提示" msg:@"支付失败" success:@"0"];
                }
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"发起支付失败" time:1];
    }];
    
    
    
}

#pragma mark -WX //微信支付
//微信支付
- (void)wxpay
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url;
    switch (_type ) {
        case 1:{url = string(@"http://api.xiaomabao.com/pay/wx_goods/" , _orderInfo[@"order_sn"]);}break;
        case 2:{url = string(@"http://api.xiaomabao.com/pay/wx_service/", _orderInfo[@"order_sn"]);}break;
        case 3:{url = string(@"http://api.xiaomabao.com/pay/wx_giftcard/", _orderInfo[@"order_sn"]);}break;
        default:
            break;
    }
    [self show];
    [MBNetworking   POSTOrigin:url  parameters:@{@"session":sessiondict} success:^(id responseObject) {
        [self dismiss];
        if ([responseObject[@"status"] intValue] != 0) {
            [self show:responseObject[@"info"] time:1];
            return;
        }
        NSDictionary *dic = responseObject[@"data"];
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = dic[@"appid"];
        req.partnerId           = dic[@"partnerid"];
        req.prepayId            = dic[@"prepayid"];
        req.nonceStr            = dic[@"noncestr"];
        req.timeStamp           = [dic[@"timestamp"] intValue];
        req.package             = dic[@"package"];
        req.sign                = dic[@"sign"];
        [WXApi sendReq:req];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"发起支付失败" time:1];
    }];
    
}

-(NSString *)titleStr{
    return @"支付方式";
}

-(void)alipayPay:(NSNotification *)notif
{
    NSDictionary * resultDic = [notif userInfo];
    if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
        [self alert:@"提示" msg:@"支付成功" success:@"1"];
    }else{
        if (resultDic[@"memo"]) {
            [self alert:@"提示" msg:resultDic[@"memo"] success:@"0"];
        }else{
            [self alert:@"提示" msg:@"付款失败" success:@"0"];
        }
        
    }
}
-(void)wayPay:(NSNotification *)notif
{
    NSDictionary * coupon = [notif userInfo];
    [self alert:@"提示" msg:coupon[@"strMsg"] success:coupon[@"success"]];
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg success:(NSString *)success
{
    _success = success;
    
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if ([_success isEqualToString:@"1"]) {
        
        switch (_type) {
                
            case 2:{
                MBPayResultsController *VC = [[MBPayResultsController alloc] init];
                VC.order_id = self.orderInfo[@"order_id"];
                [self pushViewController:VC Animated:YES];
            }break;
            default:{
                [self successView];
            }break;
        }
        
    }
}
- (void)back{
    
}
- (void)shop{
    
    [self popViewControllerAnimated:YES];
}

#pragma mark  支付成功后跳转订单详情
- (void)jumpOrderDetails{
    switch (_type) {
        case 1:{
            MBOrderInfoTableViewController  *infoVC =  [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBOrderInfoTableViewController"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:infoVC];
            infoVC.parent_order_sn = _orderInfo[@"order_sn"];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }break;
        case 2:{
            MBMyServiceController *VC = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBMyServiceController"];
            VC.page = 1;
            [self pushViewController:VC Animated:true];
        }break;
        case 3:{
            MBElectronicCardOrderInfoVC  *VC =  [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBElectronicCardOrderInfoVC"];
            VC.orderSn = self.orderInfo[@"order_sn"];
            [self pushViewController:VC Animated:true];
        }break;
        default:
            break;
    }
    
    
    
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    BkBaseViewController *rootVC  = nil;
    
    for (BkBaseViewController *VC in self.navigationController.viewControllers ) {
        switch (_type) {
            case 1:
            {
                if ([VC isKindOfClass:[MBNewHomeViewController class]]||[VC isKindOfClass:[MBNewMyViewController class]]) {
                    rootVC = VC;
                }
            }break;
            case 2:
            {
                if ([VC isKindOfClass:[MBServiceShopsViewController class]]) {
                    rootVC = VC;
                }
            }break;
            case 3:
            {
                if ([VC isKindOfClass:[MBGiftCardViewController class]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"electronicCardOrderReloadData" object:nil];
                    rootVC = VC;
                    
                }
            }break;
            default:break;
        }
        
    }
    //    搜索界面的商品购买到支付到下单（搜索模态进入的根视图和其他pop不一样)
    if ([self.navigationController.viewControllers.firstObject isMemberOfClass:[MBGoodSSearchViewController class]]) {
        
        rootVC = self.navigationController.viewControllers.firstObject;
    }
    //    搜索界面的服务购买到支付到下单（搜索模态进入的根视图和其他pop不一样)
    if ([self.navigationController.viewControllers.firstObject isMemberOfClass:[MBServiceSearchViewController class]]) {
        
        rootVC = self.navigationController.viewControllers.firstObject;
    }
    
    if (_isOrderVC) {
        rootVC = nil;
    }
    if (rootVC) {
        [self.navigationController popToViewController:rootVC animated:YES];
        
        NSNotification *notification =[NSNotification notificationWithName:@"HYTPopViewControllerNotification" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else{
        return [self.navigationController popViewControllerAnimated:animated];
    }
    
    return nil;
}


@end
