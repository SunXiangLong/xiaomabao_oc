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
@interface MBSubmitOrdersController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    WLZ_ChangeCountView *_changeView;
 
    double _number;


}
@property (assign, nonatomic) NSInteger choosedCount;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *service_price;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *shop_price;
@property (weak, nonatomic) IBOutlet UILabel *user_photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIView *numView;

@end

@implementation MBSubmitOrdersController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBSubmitOrdersController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBSubmitOrdersController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _choosedCount   = 1;
    [self setheadData];
    [self setAddOrSub];

   
}
#pragma mark -- 请求数据
- (void)setheadData{
    
    [self show];
    _product_id = @"1";
    NSString *url =[NSString stringWithFormat:@"%@%@%@",BASE_URL_SHERVICE,@"service/product_price/",_product_id];
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        NSLog(@"%@",responseObject);
        if (responseObject) {
            self.shop_name.text = [responseObject valueForKeyPath:@"product_name"];
            self.service_price.text = [NSString stringWithFormat:@"%@元",[responseObject valueForKeyPath:@"product_shop_price"]];
           
            MBUserDataSingalTon *userInf = [MBSignaltonTool getCurrentUserInfo];
            _number = [[responseObject valueForKeyPath:@"product_shop_price"] doubleValue];
            self.price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
            self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
            NSString *photo = [userInf.mobile_phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            
            self.user_photo.text = photo;
        }else{
            [self show:@"数据错误" time:1];
            [self popViewControllerAnimated:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
        [self popViewControllerAnimated:YES];
    }];
    
    
}
#pragma mark -- 提交订单前确保价格和服务器统一（长时间不提交，服务端价格呗修改）
- (void)upData{
    [self show];
    _product_id = @"1";
    NSString *url =[NSString stringWithFormat:@"%@%@%@",BASE_URL_SHERVICE,@"service/product_price/",_product_id];
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            self.shop_name.text = [responseObject valueForKeyPath:@"product_name"];
            self.service_price.text = [NSString stringWithFormat:@"%@元",[responseObject valueForKeyPath:@"product_shop_price"]];
            
            MBUserDataSingalTon *userInf = [MBSignaltonTool getCurrentUserInfo];
            _number = [[responseObject valueForKeyPath:@"product_shop_price"] doubleValue];
            self.price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
            self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
            NSString *photo = [userInf.mobile_phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.user_photo.text = photo;
            [self submitOrders];
        }else{
            [self show:@"数据错误" time:1];
          
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    
    }];
    
    
}

#pragma mark -- 提交订单
- (void)submitOrders{
  
        
        
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
        NSString *mobile_phone = [MBSignaltonTool getCurrentUserInfo].mobile_phone;
        if (!sid) {
            return;
        }
        NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_SHERVICE,@"service/submit_order"] parameters:@{@"session":sessiondict,@"product_id":self.product_id,@"product_number":_changeView.numberFD.text,@"mobile_phone":mobile_phone}
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       NSLog(@"UserInfo成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                       [self dismiss];
                       NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
                       if (dic){
                           MBPaymentViewController *VC = [[MBPaymentViewController alloc] init];
                           VC.service_data = dic;
                           [self pushViewController:VC Animated:YES];
                           
                       }else{
                          [self show:@"数据错误" time:1];
                       }
                     
        
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       NSLog(@"%@",error);
                       [self show:@"请求失败" time:1];
                   }];

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
    self.price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
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
    
      self.price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
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
    self.shop_price.text = [NSString stringWithFormat:@"¥ %.2f",_number*self.choosedCount];
}

#pragma mark -- UIScrollViewdelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;{
    
    [_changeView.numberFD resignFirstResponder];
  
    
}





@end
