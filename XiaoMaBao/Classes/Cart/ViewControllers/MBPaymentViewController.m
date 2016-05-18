//
//  MBPaymentViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBPaymentViewController.h"
#import "MBSignaltonTool.h"
#import "MBNetworking.h"
#import "MBOrderInfoViewController.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MobClick.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "MBPayResultsController.h"
#import "MBPaySuccessView.h"
#import "MBOrderListViewController.h"
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBPaymentViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBPaymentViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wayPay:) name:@"wayPay" object:nil];
    if(self.coupon_id == nil){
        self.coupon_id = @"";
    }
    
    
    
    if(self.order_id && self.isOrderDetail){
        [self getOrderInfo];
        
    }else{
    
     [self createView];
    }
    
    
}

- (void)getOrderInfo{
    [self show];
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"order/info"] parameters:@{@"session":dict,@"order_id":self.order_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        NSLog(@"status---responseObject%@",[responseObject valueForKeyPath:@"status"]);
        if([[[responseObject valueForKeyPath:@"status"] valueForKey:@"succeed"] isEqualToNumber:@1]){
            NSLog(@"生成订单成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
            
            _orderInfo = [responseObject valueForKeyPath:@"data"];
            [self createView];
        }else{
            [self show:[[responseObject valueForKeyPath:@"status"] valueForKey:@"error_desc"] time:1];
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
  
        [self show:@"请求失败" time:1];
    
       
    }];
}


- (void)getDingdanINfo
{
    
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!_identity_card) {
        _identity_card = @"";
        _real_name = @"";
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"flow/doneMobile"]
            parameters:@{@"session":dict,@"pay_id":self.pay_id,@"shipping_id":self.shipping_id,@"address_id":self.address_id,@"bonus_id":@"",@"coupon_id":self.coupon_id,@"integral":@"",@"inv_type":@"0",@"inv_content":@"",@"inv_payee" :@"",@"real_name":self.real_name,@"identity_card":self.identity_card}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"status---responseObject%@",[responseObject valueForKeyPath:@"status"]);
        NSLog(@"生成订单成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                   
                   
        _orderInfo = [responseObject valueForKeyPath:@"data"];
        _is_cross_border = _orderInfo[@"order_info"][@"is_cross_border"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCart" object:nil];
                   
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"----%@",error);
     

    }];

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
    NSString *order_sn = [_orderInfo valueForKeyPath:@"order_sn"];
    
    orderLbl.text =[NSString stringWithFormat:@"订单号：%@",order_sn];
    if (!order_sn) {
        orderLbl.text = @"";
    }
    if (self.service_data) {
         orderLbl.text =self.service_data[@"product_sn"];
    }
    [orderView addSubview:orderLbl];
    
    UIImageView *orderImgView = [[UIImageView alloc] init];
    orderImgView.frame = CGRectMake((orderView.ml_width - 16 - MARGIN_8), (orderView.ml_height - 16) * 0.5, 16, 16);
    orderImgView.image = [UIImage imageNamed:@"next"];
    [orderView addSubview:orderImgView];
    
    orderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderInfoClick:)];
    [orderView addGestureRecognizer:ger];
    
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
        
        [self addTopLineView:payListView];
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
    
    if(self.order_id && self.isOrderDetail){
        NSLog(@"%@",_order_id);
        paymentLbl.text = [NSString stringWithFormat:@"应付金额：%@",_orderInfo[@"order_amount_formatted"]];
        
        
    }else{
        
        paymentLbl.text = [NSString stringWithFormat:@"应付金额：%@",[_orderInfo valueForKeyPath:@"order_amount"]];
    }
    
    
    if (self.service_data) {
          paymentLbl.text = [NSString stringWithFormat:@"应付金额：¥%@",self.service_data[@"order_amount"]];
    }
    [bottomView addSubview:paymentLbl];

    
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
    MBOrderInfoViewController *infoVc = [[MBOrderInfoViewController alloc] init];
    //单号和时间
    NSString *order_id = [_orderInfo valueForKeyPath:@"order_id"];
    infoVc.order_id = order_id;
    if (self.service_data) {
      infoVc.order_id = self.service_data[@"order_id"];
    }
    [self.navigationController pushViewController:infoVc animated:YES];
}


#pragma mark -- 第三方支付  支付宝
 - (void)payForMoney{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    Order *order = [[Order alloc] init];
    NSString *partner = @"2088911663943262";
    NSString *seller = @"zfb@xiaomabao.com";
    if(self.order_id && self.isOrderDetail){
        order.productName = @"小麻包购买商品";//商品标题
        order.productDescription = @"小麻包购买商品"; //商品描述
        order.amount = [[self.orderInfo valueForKeyPath:@"order_amount_formatted"] substringFromIndex:1]; //商品价格
    }else{
        order.productName = [self.orderInfo  valueForKeyPath:@"subject"];//商品标题
        order.productDescription = [self.orderInfo valueForKeyPath:@"desc"]; //商品描述
        order.amount = [self.orderInfo  valueForKeyPath:@"order_amount"]; //商品价格
    }
    

    order.notifyURL =  [NSString stringWithFormat:@"%@%@",BASE_URL_ROOT,@"/mobile/payment/alipay/notify_url.php"]; //回调URL
     
     if (self.service_data) {
        
         order.productName = @"小麻包购买服务";//商品标题
         order.productDescription = @"小麻包购买服务";//商品描述
         order.amount = self.service_data[@"order_amount"];//商品价格
          order.notifyURL  = [NSString stringWithFormat:@"%@%@",BASE_URL_ROOT,@"payment/alipay_notify"]; //回调URL
     }
    NSString *privateKey = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",
                            @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAN33e4EXrmgdqvXH",
                            @"wx3bifW+v57GolErHmWuDF7vGn2kH8X8M56hgd9IAelLsSPUMaprdit3XcbdId0J",
                            @"raQzrySsziIhhfCkiu/liUUnvJI7a6o2PiRpppOZc7dd1jcjTOcyB9au2T/Q9qus",
                            @"JPjMIi6IhVAxwITFxc8G9IYHmjw9AgMBAAECgYAkVaa58w5xrKmXoiOmd5GV0Ku9",
                            @"afaYIt7O9jbAM5O6jWtGFYq9pOKFklv9vI46tzmKFB078EZBj2FDtZnfDzbUFAG2",
                            @"7xZys73eYz/KbBI9BENqvej+bQ8GbSLCBHXKW6QOYVGx1BuRKC6hFnqpCk74IzL9",
                            @"QlR6+87+lM2qmQFJAQJBAPWWd76inQfUp2FIJ2yo/hEAO3BSznRgaVHDKimFsO35",
                            @"obcfyOijJGHcL1kjGKAZ9iTL7Mhe75XMLxzChFLT9lUCQQDnYKOvgJZgLrEaupXo",
                            @"NYiOcS765qaQurkqpO0/M1gqrC8EKdcJqXo5FU0MqnQxkWuwxir38ZZTb4uWq29Q",
                            @"1wZJAkA7MU0jUaZvoL3HIND/y6uRBXFOHWdNfX9lCZk78NE4SpbDwJF4IPo/7AYt",
                            @"gdwJmrhNHimwEdHFVTV1xRyHqjcRAkAjkAX4nqH+TI7qFc2esEO56QmYhMULL7fw",
                            @"JwNUGHcvr+FWGXw0vvjLN0vta3GKgNh1hi/qhhZd4qIo2Va1rScJAkA5vZuFwEJH",
                            @"MQlf3p18GKnGyd2QRJE0PDSP9wB736S7Vh5PEsaQA2W2N9QYHPjJU6v4Nwav3dCQeb350xkmPGmQ"
                            ];
//    if (![_is_cross_border  isEqual:[NSNull null]]) {
//        if (![_is_cross_border integerValue]== 0) {
//            
//            privateKey = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@",
//                          @"MIICXQIBAAKBgQCyRddjMMtmtp6XIsrjwbf9DuwmdqBx4ODqmiRyON935ZAYeAba",
//                          @"u1kPTF0N1NQmDzp62uTDeBfsk7AMViVgCLlFrrvMlLkxmqtmEuMU/LHBQu1F9lu1",
//                          @"5n9KaZrmK7LSzlr/Xw6Ljfhp8AL1T0EolzyGvHF30sgZ9e8pOFPjGeHL0wIDAQAB",
//                          @"AoGABSx9ucU6wfpe0+gQl1eR7Wg3dk5PDb8HCAf9MstvwN0Kt4sUN9jkFsuSj8oz",
//                          @"df9PJS2hIgMkPptyqoj9gLIAHncyjcich6Uc8t0Blebj502qdzQZPBKUffTFY8uV",
//                          @"uL41QcOIqG9DL28wdPLzDCgXrK+wuaRi2iWEV+mscjokXhECQQDab/KaNbjveOlh",
//                          @"sNlPq4FbwugB1F3wsbDhg4WKa+Qk5lXjeM6fjHbM/CLTZ7rNCL4Zy0sGai0ZcPqC",
//                          @"AcB9fLB1AkEA0O3FoehiGtTP4MhRr3kq9s9Df6QfuW2yIIqDw0KUwwdf4yqawT+1",
//                          @"cRtDFdOgg22OCY8dTgzTxuRISHFf6DoCJwJBAMSV/YtFkBONCNTPmTO3USspJS4I",
//                          @"Vyb4dAzxFez2npOK7H9UyPgULRLcU+dYsmg2VwfVysaSJdaAtCLuurL01cUCQEI5",
//                          @"K6yfQQFqNR31wNaS3Ihwt99sgVXALHbeENfCce7DlqQlq/nXHMbmMkRn2PfvsNbc",
//                          @"0xgbPsFLOJIlxZWRVX8CQQCLWnk+mf+NhHRk0XOYoP9Gl7Swa0jJunj4WdEBBNbG",
//                          @"l3Q98N1rJDyON0QhA3C4t5i85BURJJWGeniMEHKkQ0Pg"
//                          ];
//            
//            
//            
//            partner = @"2088021773439893";
//            seller = @"liulianqi@xiaomabao.com";
//            order.rmb_fee = order.amount;
//            order.amount = nil;
//            order.notifyURL =    @"http://api.xiaomabao.com/interalipay/notify_url.php"; //回调URL
//            order.forex_biz = @"FP";
//            order.product_code = @"NEW_WAP_OVERSEAS_SELLER";
//            order.split_fund_info = @"[{\"transIn\":\"2088911663943262\",\"amount\":\"0.0\",\"currency\":\"CNY\",\"desc\":\"\"}]";
//            order.currency = @"USD";
//        }
//        
//    }
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self.orderInfo valueForKeyPath:@"order_sn"]; //订单ID（由商家自行制定）
     if (self.service_data) {
         order.tradeNO =  self.service_data[@"product_sn"];
     }
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"xiaomabao";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSArray *array = [[UIApplication sharedApplication] windows];
        UIWindow* win=[array objectAtIndex:0];
        [win setHidden:NO];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
            
            if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
                [self alert:@"提示" msg:@"支付成功" success:@"1"];
            }else{
                [self alert:@"提示" msg:resultDic[@"memo"] success:@"0"];
            }
         
        }];
        
    }
}

#pragma mark -WX //微信支付
//微信支付
- (void)wxpay
{
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict;
    //NSMutableDictionary *dict = [req sendPay_demo];
    //订单标题，展示给用户
    NSString *order_name    = @"小麻包购买商品";
    //订单金额,单位（分）
    NSString *order_price  ;
    NSString *price;
    if(self.order_id && self.isOrderDetail){
        
        price = [[self.orderInfo valueForKeyPath:@"order_amount_formatted"] substringFromIndex:1]; //商品价格
    }else{
        
       price = [self.orderInfo  valueForKeyPath:@"order_amount"]; //商品价格
    }
  
    order_price = [NSString stringWithFormat:@"%.0f",[price doubleValue]*100];
   
    
    //================================
    //预付单参数订单设置
    //================================
    srand( (unsigned)time(0) );
    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
    NSString *orderno   =  [self.orderInfo valueForKeyPath:@"order_sn"]; //[NSString stringWithFormat:@"%ld",time(0)];
    if (self.service_data) {
        order_name = @"小麻包购买服务";
        order_price =  [NSString stringWithFormat:@"%.0f",[self.service_data[@"order_amount"] doubleValue]*100];
        orderno = self.service_data[@"product_sn"];
    }
    
    
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    
    [packageParams setObject: APP_ID            forKey:@"appid"];       //开放平台appid
    [packageParams setObject: MCH_ID            forKey:@"mch_id"];      //商户号
    [packageParams setObject: @"APP-001"        forKey:@"device_info"]; //支付设备号或门店号
    [packageParams setObject: noncestr          forKey:@"nonce_str"];   //随机串
    [packageParams setObject: @"APP"            forKey:@"trade_type"];  //支付类型，固定为APP
    [packageParams setObject: order_name        forKey:@"body"];        //订单描述，展示给用户
    [packageParams setObject: self.service_data?NOTIFY_service_URL:NOTIFY_URL        forKey:@"notify_url"];  //支付结果异步通知
    [packageParams setObject: orderno           forKey:@"out_trade_no"];//商户订单号
    [packageParams setObject: @"196.168.1.1"    forKey:@"spbill_create_ip"];//发器支付的机器ip
    [packageParams setObject: order_price       forKey:@"total_fee"];       //订单金额，单位为分
    [packageParams setObject: orderno           forKey:@"attach"]; //附加数据，在查询API和支付通知中原样返回，该字段主要用于商户携带订单的自定义数据
    //获取prepayId（预支付交易会话标识）
    NSString *prePayid;
    prePayid            = [req sendPrepay:packageParams];
    
    
    if ( prePayid != nil) {
        //获取到prepayid后进行第二次签名
        
        NSString    *package, *time_stamp, *nonce_str;
        //设置支付参数
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        nonce_str	= [WXUtil md5:time_stamp];
        
        package         = @"Sign=WXPay";
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: APP_ID        forKey:@"appid"];
        [signParams setObject: nonce_str    forKey:@"noncestr"];
        [signParams setObject: package      forKey:@"package"];
        [signParams setObject: MCH_ID        forKey:@"partnerid"];
        [signParams setObject: time_stamp   forKey:@"timestamp"];
        [signParams setObject: prePayid     forKey:@"prepayid"];
        
        //生成签名
        NSString *sign  = [req createMd5Sign:signParams];
        NSLog(@"%@",sign);
        
        
        //添加签名
        [signParams setObject: sign  forKey:@"sign"];
        
        dict = [NSMutableDictionary dictionaryWithDictionary:signParams];
    }
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug success:@"0"];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
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
    NSLog(@"%ld",buttonIndex);
    
     if ([_success isEqualToString:@"1"]) {
         if(self.service_data){
             MBPayResultsController *VC = [[MBPayResultsController alloc] init];
             VC.order_id = self.service_data[@"order_id"];
             [self pushViewController:VC Animated:YES];
         }else{
              self.navBar.back = NO;
             //覆盖侧滑手势
             UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
             [self.navigationController.view  addGestureRecognizer:pan];
             MBPaySuccessView *PaySuccessView = [MBPaySuccessView instanceView];
             PaySuccessView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y);
             [self.view addSubview:PaySuccessView];
             [PaySuccessView.shopButton addTarget:self action:@selector(shop) forControlEvents:UIControlEventTouchUpInside];
             [PaySuccessView.orderButton addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
             
         }

     }
}
- (void)back{

}
- (void)shop{
    UIViewController *mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainVc;
  
}
- (void)order{

    MBOrderListViewController *VC = [[MBOrderListViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];

}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    if ([_type isEqualToString:@"1"]) {
        UIViewController *mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        [UIApplication sharedApplication].keyWindow.rootViewController = mainVc;
        return nil;
    }else{
        
        return [self.navigationController popViewControllerAnimated:animated];
        
    }
    
    return nil;
}


@end
