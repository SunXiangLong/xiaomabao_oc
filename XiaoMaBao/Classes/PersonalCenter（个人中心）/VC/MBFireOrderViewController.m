//
//  MBFireOrderViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//
#import "MBFireOrderViewController.h"
#import "MBPaymentViewController.h"
#import "MBFireOrderTableViewCell.h"
#import "MBShopAddresViewController.h"
#import "MBVoucherViewController.h"
#import "MBRealNameAuthViewController.h"
#import "MBAddIDCardView.h"
#import "MBBabyCardController.h"
#import "MBInvoiceViewController.h"
#import "MBBeanUseViewController.h"
#import "MBDiscountCell.h"
#import "MBRealNameViewController.h"
#import "MaBaoCardModel.h"
@interface MBFireOrderViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UILabel *totalLabel;
/**折扣类型数组*/
@property (strong,nonatomic) NSArray *discountArray;
/**折扣类型数组*/
@property (strong,nonatomic) NSMutableArray<NSString *> *discountPriceArray;
/**红包的id*/
@property (copy,nonatomic) NSString *bonus_id;
/**优惠券*/
@property (copy,nonatomic) NSString *couponId;
/**发票的类型 抬头 公司名称*/
@property (copy,nonatomic) NSString *inv_payee;
@property (copy,nonatomic) NSString *inv_type;
@property (copy,nonatomic) NSString *inv_content;
@property (copy,nonatomic) NSString *inv_identification;

/**麻包豆数量*/
@property (copy,nonatomic) NSString *mabaobean_number;
/**
 *  麻包卡密码  多个的话用 ，分开
 */

@property (copy,nonatomic) NSMutableString *cards;
@end

@implementation MBFireOrderViewController
-(NSMutableString *)cards{
    if (!_cards) {
        _cards = [NSMutableString string];
    }
    return _cards;
}

-(NSArray *)discountArray{
    
    if (!_discountArray) {
        _discountArray = @[@"商品合计",@"运费",@"专场优惠",@"发票信息",@"使用麻包卡",@"使用麻豆",@"代金券",@"使用红包或兑换卷",@"备注："];
    }
    return _discountArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - 40) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        [_tableView registerNib:[UINib nibWithNibName:@"MBFireOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBFireOrderTableViewCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
    
}
-(void)setOrderShopModel:(MBConfirmModel *)orderShopModel{
    _orderShopModel = orderShopModel;
    if (!_tableView) {
        [self.view addSubview:self.tableView];
    }
    
    self.discountPriceArray   = [@[orderShopModel.goods_amount_formatted,orderShopModel.shipping_fee_formatted,orderShopModel.discount_formatted,_inv_payee?_discountPriceArray[3]:@"",orderShopModel.surplus?:@"",([orderShopModel.bean_fee integerValue] > 0)?string(@"￥", orderShopModel.bean_fee) :@"",_couponId?( [orderShopModel.discount integerValue] > 0?orderShopModel.discount_formatted:@""):@"",_bonus_id?([orderShopModel.discount integerValue] > 0?orderShopModel.discount_formatted:@""):@"",@""] mutableCopy];
    ;
    self.tableView.tableHeaderView = [self tableViewHeaderView];
    
    if (_totalLabel) {
        _totalLabel.text =  orderShopModel.order_amount_formatted;
        
    }else{
        [self setUpbottomViewUI];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] init];
    UIView *headerBoxView = [[UIView alloc] init];
    headerBoxView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:headerBoxView];
    
    
    UIImageView *imageview = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"next"]];
    [headerBoxView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerBoxView.mas_centerY);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(16);
        
    }];
    UITapGestureRecognizer *ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressClick:)];
    [headerView addGestureRecognizer:ger];
    if (self.orderShopModel.consignee) {
        
        UILabel *consigneeLabel = [[UILabel alloc] init];
        consigneeLabel.font = SYSTEMFONT(14);
        consigneeLabel.text = self.orderShopModel.consignee.consignee;
        consigneeLabel.textColor = UIcolor(@"434343");
        [headerBoxView addSubview: consigneeLabel];
        [consigneeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(10);
        }];
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.text =  self.orderShopModel.consignee.mobile;
        phoneLabel.textColor = UIcolor(@"434343");
        phoneLabel.font = SYSTEMFONT(14);
        [headerBoxView addSubview:phoneLabel];
        
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.equalTo(consigneeLabel.mas_right).offset(20);
        }];
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = SYSTEMFONT(12);
        addressLabel.textColor = UIcolor(@"9a9a9a");
        addressLabel.numberOfLines = 0;
        addressLabel.text = [NSString stringWithFormat:@"%@%@%@",self.orderShopModel.consignee.province_name,self.orderShopModel.consignee.district_name,self.orderShopModel.consignee.address];
        [headerBoxView addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(consigneeLabel.mas_bottom).offset(8);
            make.left.equalTo(consigneeLabel.mas_left);
            make.right.equalTo(imageview.mas_left).offset(-10);
        }];
        
        
        
        [headerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(addressLabel.mas_bottom).offset(10);
        }];
        
        [headerBoxView.superview layoutIfNeeded];
        
        headerView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, headerBoxView.mj_h + 20);
    }else{
        
        
        UIImageView *imageview = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"flight_butn_add"]];
        [headerBoxView addSubview:imageview];
        
        [imageview  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(headerBoxView.mas_centerY);
            make.width.height.mas_equalTo(26);
        }];
        
        UILabel *consigneeLabel = [[UILabel alloc] init];
        consigneeLabel.font = SYSTEMFONT(12);
        consigneeLabel.text = @"请先填写收货地址";
        consigneeLabel.textColor = UIcolor(@"434343");
        [headerBoxView addSubview:consigneeLabel];
        [consigneeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageview.mas_right);
            make.centerY.equalTo(headerBoxView.mas_centerY);
        }];
        [headerBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.bottom.equalTo(imageview.mas_bottom).offset(10);
            make.left.right.mas_equalTo(0);
        }];
        
        [headerBoxView.superview layoutIfNeeded];
        
        headerView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, headerBoxView.mj_h + 20);
        
    }
    
    return headerView;
}

#pragma mark --选取收货地址
-(void)addressClick:(UITapGestureRecognizer *)ger
{
    MBShopAddresViewController *addressVc = [[MBShopAddresViewController alloc] init];
    WS(weakSelf)
    addressVc.changeAddress = ^(MBConsigneeModel *model) {
        weakSelf.orderShopModel.consignee = model;
        [weakSelf beforeCreateOrder];
    };
    [self pushViewController:addressVc Animated:YES];
}
-(void)selsectaddress:(NSNotification *)notif
{
    self.orderShopModel.consignee.address_id = [notif userInfo][@"address_id"];
    
    NSDictionary *cardDic = [notif userInfo][@"idcard"];
    NSString *str1 = cardDic[@"real_name"];
    NSString *str2 = cardDic[@"identity_card"];
    if (cardDic) {
        
        if (self.orderShopModel.consignee.idcard) {
            self.orderShopModel.consignee.idcard.is_black = cardDic[@"is_black"];
            if (str1 &&![str1 isEqualToString:@""]) {
                self.orderShopModel.consignee.idcard.real_name = str1;
                
            }
            if (str2 &&![str2 isEqualToString:@""]) {
                self.orderShopModel.consignee.idcard.identity_card = str2;
            }
        }else{
            self.orderShopModel.consignee.idcard = [MBIdcardModel yy_modelWithDictionary:cardDic];
            
        }
        
    }
    
    
    
    
    
    
}

/**使用麻豆*/
- (void)giveFriend{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/bean/number") parameters:@{@"session":dict} success:^(id responseObject) {
        [self dismiss];
        if (responseObject) {
            MMLog(@"%@",responseObject);
            MBBeanUseViewController *VC = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBBeanUseViewController"];
            VC.number = [NSString stringWithFormat:@"%@",responseObject[@"number"]];
            WS(weakSelf)
            VC.block = ^(NSString *mabaobean_number){
                
                _mabaobean_number = mabaobean_number;
                [weakSelf beforeCreateOrder];
                
            };
            [self pushViewController:VC Animated:true];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:.8];
    }];
    
    
}
/** * 优惠券单击事 **  */
-(void)couponClick{
    if (_bonus_id) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已使用了红包或兑货券不可以在使用代金券" delegate: self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alerView show];
        
    }else{
        MBVoucherViewController *vc = [[MBVoucherViewController alloc] init];
        vc.is_fire = @"yes";
        vc.order_money = self.orderShopModel.order_amount;
        
        @weakify(self);
        [[vc.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *coupon) {
            @strongify(self);
            
            self.couponId = coupon [@"bonus_id"];
            [self beforeCreateOrder];
            
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


#pragma mark --bottomViewUI布局
- (void)setUpbottomViewUI{
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, UISCREEN_HEIGHT - 40 , UISCREEN_WIDTH, 40);
    [self.view addSubview:bottomView];
    [self addTopLineView:bottomView];
    
    UILabel *total = [[UILabel alloc] init];
    total.text = @"应付总额：";
    total.textColor = UIcolor(@"797979");
    total.font = SYSTEMFONT(14);
    [bottomView addSubview:total];
    [total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    UILabel *price = [[UILabel alloc] init];
    price.textColor = UIcolor(@"e8455d");
    price.font = SYSTEMFONT(16);
    
    [bottomView addSubview:_totalLabel = price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(total.mas_right).offset(3);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor colorWithHexString:@"e8455d"];
    [bottomView addSubview:submitButton];
    _totalLabel.text =  self.orderShopModel.order_amount_formatted;
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(105);
    }];
    [submitButton addTarget:self action:@selector(goPaymentVc) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --提交订单前的一堆判断逻辑
/***  一堆判断逻辑－先的有收获地址 -跨境购的需要实名认证－ 海外直邮的需要上传身份证 */
- (void)goPaymentVc{
    /***  是否存在收货地址*/
    if (!self.orderShopModel.consignee.consignee) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"小麻包提示" message:@"收货地址不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *determine = [UIAlertAction actionWithTitle:@"去添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alerVC addAction:cacle];
        [alerVC addAction:determine];
        [self presentViewController:alerVC animated:YES completion:nil];
        
        return;
    }
    /***  是否跨境购*/
    if (self.orderShopModel.real_name) {
        
        /***  是否实名认证*/
        if (![self.orderShopModel.consignee.idcard.identity_card isValidWithIdentityNum]) {
            
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"小麻包提示" message:@"购买海外商品需要提交真实的身份证信息，海关叔叔才会放行哦" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cacle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *determine = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MBRealNameViewController *VC = [[MBRealNameViewController alloc] init];
                VC.model = self.orderShopModel.consignee;
                [self pushViewController:VC Animated:true];
            }];
            
            [alerVC addAction:cacle];
            [alerVC addAction:determine];
            [self presentViewController:alerVC animated:YES completion:nil];
            return;
        }
        /***  是否被海关拉黑*/
        if ([self.orderShopModel.consignee.idcard.is_black integerValue] == 1) {
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"小麻包提示" message:@"收货人的身份证已被海关拉黑，请更换收货人" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cacle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *determine = [UIAlertAction actionWithTitle:@"去更换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MBRealNameViewController *VC = [[MBRealNameViewController alloc] init];
                VC.model = self.orderShopModel.consignee;
                [self pushViewController:VC Animated:true];
            }];
            
            [alerVC addAction:cacle];
            [alerVC addAction:determine];
            [self presentViewController:alerVC animated:YES completion:nil];
            return;
        }
        
        
        
    }
    MBPaymentViewController *payVc = [[MBPaymentViewController alloc] init];
    [self getDingdanINfo:payVc];
    
    
}
- (NSString *)titleStr{
    return @"结算";
}
#pragma mark --- 获取红包弹出框
- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"使用兑换券或红包", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        UITextField*textField=alertController.textFields.firstObject;
        NSString * bonus_sn = textField.text;
        
        [self getBonusBySn:bonus_sn order_money:self.orderShopModel.order_amount];
        
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        //textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请输入兑换券或红包序列号";
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark ---提交订单数据
- (void)getDingdanINfo:(MBPaymentViewController *)VC
{
    
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *name = self.orderShopModel.consignee.consignee;
    if (!self.orderShopModel.consignee.idcard) {
        self.orderShopModel.consignee.idcard = [MBIdcardModel yy_modelWithDictionary:@{@"identity_card":@""}];
    }
    if (!self.couponId) self.couponId = @"";
    if (!_bonus_id)  _bonus_id = @"";
    if (!_inv_payee) _inv_payee = @"";
    if (!_inv_type)  _inv_type= @"";
    if (!_inv_content)  _inv_content = @"";
    if (!_inv_identification)_inv_identification = @"";
    if (!_mabaobean_number) _mabaobean_number = @"";    if (!name) {
        [self show:@"收货人姓名不能为空" time:1];
        return;
    }
    if (!self.orderShopModel.consignee.address_id) {
        [self show:@"收货人地址ID不存在" time:1];
        return;
    }
    
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/flow/done_new") parameters:@{@"session":dict,@"pay_id":@"3",@"shipping_id":@"4",@"address_id":self.orderShopModel.consignee.address_id,@"bonus_id":_bonus_id,@"coupon_id":self.couponId,@"integral":@"",@"inv_type":_inv_type,@"inv_content":_inv_content,@"inv_payee" :_inv_payee,@"real_name":name,@"identity_card":self.orderShopModel.consignee.idcard.identity_card,@"cards":self.cards,@"mabaobean_number":_mabaobean_number,@"inv_identification":_inv_identification} success:^(id responseObject) {
        [self dismiss];
        MMLog(@"%@",responseObject);
        if ([responseObject[@"status"] isKindOfClass:[NSDictionary class]]&&[responseObject[@"status"][@"succeed"] integerValue] == 1) {
            self.isRefresh();
            VC.orderInfo = responseObject[@"data"][@"order_info"];
            VC.type = MBOrdersForGoods;
            [self.navigationController pushViewController:VC animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCart" object:nil];
            
        }else{
            
            UIAlertController   *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:responseObject[@"status"][@"error_desc"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sheet = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.isRefresh();
                [self popViewControllerAnimated:true];
            }];
            [alerVC addAction:sheet];
            [self presentViewController:alerVC animated:true completion:nil];
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
    }];
    
}
#pragma mark -- 更换地址从新获取订单数据－－更改运费（不同地点运费不同）
-(void)beforeCreateOrder
{
    [self show];
    if (!_mabaobean_number) {
        _mabaobean_number = @"";
    }
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    if (!self.orderShopModel.consignee.address_id) {
        [self show:@"请设置收货地址" time:.8];
        return;
    }
    NSDictionary *parameter = @{@"address_id":self.orderShopModel.consignee.address_id,@"session":sessiondict,@"cards":self.cards,@"mabaobean_number":_mabaobean_number};
    if (self.couponId) {
        parameter = @{@"address_id":self.orderShopModel.consignee.address_id,@"session":sessiondict,@"cards":self.cards,@"mabaobean_number":_mabaobean_number,@"coupon_id":self.couponId};
    }
    
    if (self.bonus_id) {
        parameter = @{@"address_id":self.orderShopModel.consignee.address_id,@"session":sessiondict,@"cards":self.cards,@"mabaobean_number":_mabaobean_number,@"bonus_id":_bonus_id};
    }
    
    
    
    
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/flow/checkout") parameters:parameter success:^(id responseObject) {
        //        MMLog(@"%@",responseObject);
        [self dismiss];
        if ([responseObject[@"status"] isKindOfClass:[NSDictionary  class]]&&[responseObject[@"status"][@"succeed"]  integerValue] == 1) {
            self.orderShopModel = [MBConfirmModel yy_modelWithDictionary:responseObject[@"data"]];
            [_tableView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
    }];
    
}

#pragma mark -- 使用红包
-(void)getBonusBySn:(NSString *)bonus_sn order_money:(NSString *)order_money
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/discount/get_bonus_info"]
            parameters:@{@"session":sessiondict,@"bonus_sn":bonus_sn,@"order_money":order_money}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   
                   NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
                   if (dic) {
                       _bonus_id = dic[@"bonus_id"];
                       [self beforeCreateOrder];
                       
                   }else{
                       UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject valueForKeyPath:@"status"][@"error_desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                       [view show];
                       
                   }
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   [self show:@"使用失败" time:1];
                   MMLog(@"%@",error);
                   
               }];
    
}

#pragma mark --UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderShopModel.goods_list.count + 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == self.orderShopModel.goods_list.count) {
        return self.discountArray.count;
    }
    return self.orderShopModel.goods_list[section].goods_list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.orderShopModel.goods_list.count) {
        return 40;
    }
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.orderShopModel.goods_list.count) {
        return 0.001;
    }
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == self.orderShopModel.goods_list.count) {
        return 0.001;
    }
    if ([self.orderShopModel.goods_list[section].discount_name isEqualToString:@""]) {
        return 30;
    }
    
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == self.orderShopModel.goods_list.count) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 25);
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = UIcolor(@"434343");
    lable.font = SYSTEMFONT(14);
    lable.text = self.orderShopModel.goods_list[section].supplier;
    [headerView addSubview:lable];
    
    
    
    if ([self.orderShopModel.goods_list[section].discount_name isEqualToString:@""]) {
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_centerY);
            make.left.mas_equalTo(10);
        }];
        return headerView;
    }
    
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY).offset(-15);
        make.left.mas_equalTo(10);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.tag = 2222222;
    lineView.backgroundColor = [UIColor colorWithHexString:@"dfe1e9"];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_centerY);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(PX_ONE);
    }];
    
    UILabel *discountName = [[UILabel alloc] init];
    discountName.textColor = UIcolor(@"e8455d");
    discountName.font = SYSTEMFONT(14);
    discountName.text = self.orderShopModel.goods_list[section].discount_name;
    [headerView addSubview:discountName];
    [discountName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY).offset(15);
        make.left.mas_equalTo(10);
    }];
    return headerView;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.orderShopModel.goods_list.count) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] init];
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 30);
    footer.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:footer];
    
    if (![self.orderShopModel.goods_list[section].shipping_fee isEqualToString:@"¥0.00"]) {
        
        UILabel *lable = [[UILabel alloc] init];
        lable.font = SYSTEMFONT(12);
        lable.textColor = UIcolor(@"373737");
        lable.text =  @"运费：";
        [footer addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footer.mas_centerY);
            make.left.mas_equalTo(10);
        }];
        UILabel *fee = [[UILabel alloc] init];
        fee.font = SYSTEMFONT(12);
        fee.textColor = UIcolor(@"e8455d");
        fee.text = self.orderShopModel.goods_list[section].shipping_fee;
        [footer addSubview:fee];
        [fee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footer.mas_centerY);
            make.left.equalTo(lable.mas_right);
        }];
        
        
    }else{
        UILabel *fee = [[UILabel alloc] init];
        fee.font = SYSTEMFONT(12);
        fee.textColor = UIcolor(@"878787");
        fee.text = [NSString stringWithFormat:@"共%@件商品",self.orderShopModel.goods_list[section].number];
        [footer addSubview:fee];
        [fee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footer.mas_centerY);
            make.left.mas_equalTo(10);
        }];
    }
    
    UILabel *total_money = [[UILabel alloc] init];
    total_money.font = SYSTEMFONT(12);
    total_money.textColor = UIcolor(@"e8455d");
    total_money.text =  self.orderShopModel.goods_list[section].total_money;
    [footer addSubview:total_money];
    [total_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footer.mas_centerY);
        make.right.mas_equalTo(-10);
    }];
    UILabel *lable = [[UILabel alloc] init];
    lable.font = SYSTEMFONT(12);
    lable.textColor = UIcolor(@"373737");
    lable.text =  @"小计：";
    [footer addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footer.mas_centerY);
        make.right.equalTo(total_money.mas_left);
    }];
    
    return footerView;
    
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.orderShopModel.goods_list.count) {
        
        static NSString *identifier = @"MBDiscountCell";
        MBDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        BOOL isnext = YES;
        if (indexPath.row < 3 || indexPath.row > 7 ) {
            isnext = NO;
        }
        if (!cell) {
            cell = [[MBDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.row == (self.discountPriceArray.count - 1)) {
            cell.isnote =true;
        }else{
            cell.isnote =false;
        }
        cell.price = _discountPriceArray[indexPath.row];
        
        cell.name = _discountArray[indexPath.row];
        cell.isnext = isnext;
        
        @weakify(self)
        [[cell.textField rac_textSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.discountPriceArray[self.discountPriceArray.count - 1] = x;
            
        }];
        return cell;
    }
    
    MBFireOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBFireOrderTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBFireOrderTableViewCell" owner:nil options:nil]firstObject];
    }
    cell.model = self.orderShopModel.goods_list[indexPath.section].goods_list[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.orderShopModel.goods_list.count) {
        switch (indexPath.row) {
            case 3:{
                MBInvoiceViewController *VC = [[UIStoryboard storyboardWithName:@"Shopping" bundle:nil] instantiateViewControllerWithIdentifier:@"MBInvoiceViewController"];
                WS(weakSelf)
                VC.block = ^(NSString *inv_payee,NSString *inv_type,NSString *inv_content,NSString *inv_identification){
                    
                    weakSelf.discountPriceArray[3] = inv_content;
                    weakSelf.inv_payee = inv_payee;
                    weakSelf.inv_type = inv_type;
                    weakSelf.inv_content = inv_content;
                    weakSelf.inv_identification = inv_identification;
                    [weakSelf.tableView reloadData];
                    
                };
                [self pushViewController:VC Animated:YES];
                
            }break;
            case 4:{
                _cards = nil;
                MBBabyCardController *VC =  [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MBBabyCardController"];
                @weakify(self);
                [[VC.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *arr) {
                    @strongify(self);
                    for ( MaBaoCardModel*model in arr) {
                        if ([model isEqual:arr.firstObject]) {
                            if (model.card_no) {
                                [self.cards appendString:model.card_no];
                            }
                        }else{
                            
                            if (model.card_no) {
                                [self.cards appendString:@","];
                                [self.cards appendString:model.card_no];
                            }
                            
                            
                        }
                    }
                    
                    [self beforeCreateOrder];
                    
                    
                }];
                [self pushViewController:VC Animated:YES];
                
            }break;
            case 5:{
                
                [self giveFriend];
                
            }break;
            case 6:{
                
                [self couponClick];
            }break;
            case 7:{
                if (self.couponId) {
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已使用了代金券不可以在使用红包或兑货券" delegate: self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alerView show];
                }else{
                    
                    [self showOkayCancelAlert];
                }
                
            }break;
            default:break;
        }
    }
}

#pragma mark --要开始移动scrollView时调用（移除键盘）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;{
    [self.view endEditing:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}



@end
