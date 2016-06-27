//
//  MBSubmitOrdersController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBSubmitOrdersController.h"
#import "WLZ_ChangeCountView.h"
#import "MBPaymentViewController.h"
#import "MBBabyCardController.h"
@interface MBSubmitOrdersController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    WLZ_ChangeCountView *_changeView;
 
    double _number;
    double _mabao_surplus;


}
@property (assign, nonatomic) NSInteger choosedCount;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *service_price;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *shop_price;
@property (weak, nonatomic) IBOutlet UITextField *user_photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (copy, nonatomic) NSMutableString *cards;
@property (weak, nonatomic) IBOutlet UILabel *surplus;

@end

@implementation MBSubmitOrdersController
-(NSMutableString *)cards{
    if (!_cards) {
        _cards   = [NSMutableString string];
    }
    return _cards;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
   MBUserDataSingalTon *userInf = [MBSignaltonTool getCurrentUserInfo];
 
    
    
    if (userInf.mobile_phone) {
        _user_photo.text = userInf.mobile_phone;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setAddOrSub];
    _choosedCount   = 1;
    [self setheadData];

 
   
}
#pragma mark -- 请求数据
- (void)setheadData{
    
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSDictionary *parameter = @{@"session":sessiondict,@"product_id":self.product_id,@"product_num":_changeView.numberFD.text,@"cards":self.cards} ;
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/checkout"];
    
    [MBNetworking POSTOrigin:url parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self dismiss];
        if (responseObject) {
            self.shop_name.text = [responseObject valueForKeyPath:@"product_name"];
            self.service_price.text = [NSString stringWithFormat:@"%@元",[responseObject valueForKeyPath:@"product_market_price"]];
            self.surplus.text = [NSString stringWithFormat:@"¥ %.2f",[[responseObject valueForKeyPath:@"surplus"] floatValue]];
            
            _number = [[responseObject valueForKeyPath:@"product_market_price"] doubleValue];
            double number = [[responseObject valueForKeyPath:@"order_amount"] doubleValue];
            _mabao_surplus = [[responseObject valueForKeyPath:@"surplus"] doubleValue];
            self.price.text = [NSString stringWithFormat:@"¥ %.2f",number];
            self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
          
        }else{
            [self show:@"数据错误" time:1];
            [self popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
        [self popViewControllerAnimated:YES];
    }];
    

}
#pragma mark -- 提交订单前确保价格和服务器统一（长时间不提交，服务端价格被修改）
- (void)upData{
    [self show];
   
    NSString *url =[NSString stringWithFormat:@"%@%@%@",BASE_URL_root,@"/service/product_price/",_product_id];
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
        if (responseObject) {
            self.shop_name.text = [responseObject valueForKeyPath:@"product_name"];
            self.service_price.text = [NSString stringWithFormat:@"%@元",[responseObject valueForKeyPath:@"product_market_price"]];
            
           
            _number = [[responseObject valueForKeyPath:@"product_market_price"] doubleValue];
        
            self.price.text = [NSString stringWithFormat:@"¥ %.2f",(_number - _mabao_surplus)];
            self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
         self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
            
            if ([_user_photo.text isValidPhone] ) {
                
             [self submitOrders];
                

            }else{
                
             [self show:@"请输入正确的手机号" time:1];
                
            }

           
           
        }else{
            [self show:@"数据错误" time:1];
          
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    
    }];
    
    
}

#pragma mark -- 提交订单
- (void)submitOrders{
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    

        NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/submit_order"] parameters:@{@"session":sessiondict,@"product_id":self.product_id,@"product_number":_changeView.numberFD.text,@"mobile_phone":_user_photo.text,@"cards":self.cards}
                   success:^(NSURLSessionDataTask *operation, id responseObject) {
                       NSLog(@"UserInfo成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                       
                       [self dismiss];
                       NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
                       if (dic){
                           MBPaymentViewController *VC = [[MBPaymentViewController alloc] init];
                           VC.service_data = dic;
                           VC.type = @"2";
                           [self pushViewController:VC Animated:YES];
                           
                       }else{
                          [self show:@"数据错误" time:1];
                       }
                     
        
                   } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                       NSLog(@"%@",error);
                       [self show:@"请求失败" time:1];
                   }];

}

- (IBAction)mabaoka:(id)sender {
    
    _cards = nil;
    MBBabyCardController *VC = [[MBBabyCardController alloc] init];
    @weakify(self);
    
    [[VC.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *arr) {
        @strongify(self);
        
        
        for (NSDictionary *dic in arr) {
            if ([dic isEqualToDictionary:arr.firstObject]) {
                
                [self.cards appendString:dic[@"card_no"]];
                
            }else{
                
                
                [self.cards appendString:@","];
                [self.cards appendString:dic[@"card_no"]];
                
                
            }
        }
        [self setheadData];

    }];
    [self pushViewController:VC Animated:YES];
}

- (void)setAddOrSub{
    //可滑动
    self.bottom.constant  = UISCREEN_HEIGHT - TOP_Y - 46;
    
    _changeView  = [[WLZ_ChangeCountView alloc] initWithFrame:CGRectMake(0, 0, 105, 33) chooseCount:1 totalCount:MAXFLOAT];
    _changeView.numberFD.delegate = self;
    [_changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.numView addSubview:_changeView];


}
- (IBAction)submitOrders:(id)sender {
    [self upData];
}

//加
- (void)addButtonPressed:(id)sender
{
    
    ++self.choosedCount ;
    if (self.choosedCount>0) {
        _changeView.subButton.enabled=YES;
    }
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    self.price.text = [NSString stringWithFormat:@"¥ %.2f",(_number*self.choosedCount - _mabao_surplus )];
    self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
}

//减
- (void)subButtonPressed:(id)sender
{
     -- self.choosedCount ;
    if (self.choosedCount==0) {
        self.choosedCount= 1;
        _changeView.subButton.enabled=NO;
    }
    else
    {
        _changeView.addButton.enabled=YES;
        
    }
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
      self.price.text = [NSString stringWithFormat:@"¥ %.2f",(_number*self.choosedCount - _mabao_surplus)];
      self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
    
    
}
- (NSString *)titleStr{

return @"提交订单";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _changeView.numberFD = textField;
    
    
    if ([_changeView.numberFD.text isEqualToString:@""] || [_changeView.numberFD.text isEqualToString:@"0"]) {
        self.choosedCount = 1;
        _changeView.numberFD.text=@"1";
         _changeView.subButton.enabled=NO;
    }else{
             _changeView.subButton.enabled=YES;
    }

    
    
    _changeView.addButton.enabled=YES;
    _changeView.numberFD.text = _changeView.numberFD.text;
    self.price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
    self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",(_number*self.choosedCount- _mabao_surplus )];
}

#pragma mark -- UIScrollViewdelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;{
    
    [_changeView.numberFD resignFirstResponder];
  
    
}





@end
