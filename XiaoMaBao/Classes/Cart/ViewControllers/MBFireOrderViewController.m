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
#import "UIImageView+WebCache.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
#import "MBShopAddresViewController.h"
#import "MBVoucherViewController.h"
#import "MBRealNameAuthViewController.h"
#import "orderFootView.h"
#import "orderHeadView.h"
#import "MBAddIDCardView.h"
#import "MBBabyCardController.h"
#import "MBInvoiceViewController.h"
#import "MBBeanUseViewController.h"
@interface MBFireOrderViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
   
    UITextField *_beizhu;

    UILabel*_address;
    UILabel *_nameLabel;
    UITextField *_cardTextField;
    UIView *_view1;
    UIView *_view2;
    BOOL *_isyanzhen;

    
    NSString *_is_black;
    NSString *_real_name;
    NSString *_identity_card;
    NSString *_bonus_id;
    
    NSString *_couponMoney;
    NSString *_hongbaoMoney;
    NSString *_strCoupon;
    NSString *_strHongbao;
    NSString *_babyCardStr;
    NSString *_invoiceText;
    NSArray *_array;
    NSString *_address_id;
    NSString *_bean_fee;


}

@property (weak,nonatomic) UIButton *addVouchersBtn;
@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *numarr;
@property (strong,nonatomic) UILabel *couponLbl;
@property (strong,nonatomic) UILabel *bonusLbl;
@property (strong,nonatomic) UILabel *invoiceLbl;
@property (strong,nonatomic) UILabel *babycard;
@property (strong,nonatomic) UILabel *totalLabel;
@property (strong,nonatomic) UILabel *beanLabel;
@property (copy,nonatomic) NSString *couponId;
@property (copy,nonatomic) NSString *inv_payee;
@property (copy,nonatomic) NSString *inv_type;
@property (copy,nonatomic) NSString *inv_content;
@property (copy,nonatomic) NSString *mabaobean_number;
@property (copy,nonatomic) NSArray *photoArr;
@property (assign,nonatomic) BOOL isCard;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    //选择地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selsectaddress:) name:@"AddressNOtifition" object:nil];
    _numarr = [NSMutableArray array];
    for (NSDictionary *dict in self.goodselectArray ) {
        if (![[dict valueForKeyPath:@"celltag"] isEqualToString:@"-1"]) {
            [_numarr addObject:dict];
        }
    }
    _array = [self.CartDict allKeys];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"MBFireOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBFireOrderTableViewCell"];
    
    tableView.dataSource = self,tableView.delegate = self;
    tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - 35);
    [self.view addSubview:_tableView = tableView];
    [self getAddressList];
    [self setupTabbarView];
    
}
-(void)selsectaddress:(NSNotification *)notif
{
    _address_id = [notif userInfo][@"address_id"];
    
    NSDictionary *cardDic = [notif userInfo][@"idcard"];
    NSString *str1 = cardDic[@"real_name"];
    NSString *str2 = cardDic[@"identity_card"];
    if (cardDic) {
        _is_black = [NSString stringWithFormat:@"%@",cardDic[@"is_black"]];
        
        if (str1 &&![str1 isEqualToString:@""]) {
            _real_name = str1;
        }else{
            _real_name = nil;
        }
        if (str2 &&![str2 isEqualToString:@""]) {
            _identity_card = str2;
        }else{
            _identity_card = nil;
        }
        
    }
    
    [self BeforeCreateOrder];
    
  

    
}


#pragma mark -- 更换地址从新获取订单数据－－更改运费（不同地点运费不同）
-(void)BeforeCreateOrder
{
    [self show];
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/checkout"] parameters:@{@"session":sessiondict,@"address_id":_address_id}success:^(NSURLSessionDataTask *operation, id responseObject) {
//           MMLog(@"成功---生成订单前的订单确认接口%@",[responseObject valueForKeyPath:@"data"]);
        
        [self dismiss];
        if ([[responseObject valueForKeyPath:@"status"][@"succeed"] isEqualToNumber:@1]) {
            
            
            NSMutableArray * infoDict = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_list"];
            self.total = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"total"];
            self.CartinfoDict = infoDict;
            self.cartinfoArray = self.CartinfoDict;
            self.order_amount = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"order_amount"];
            self.order_amount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"order_amount_formatted"];
            self.cross_border_tax = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"cross_border_tax"];
            self.shipping_fee_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"shipping_fee_formatted"];
            self.goods_amount = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_amount"];
            self.goods_amount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_amount_formatted"];
            self.discount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"discount_formatted"];
            NSString *str  = [NSString stringWithFormat:@"%@",[[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"real_name"]];
            self.is_cross_border = str;
            self.CartDict =  [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"s_goods_list"];
            [_tableView.tableHeaderView removeFromSuperview];
            _tableView.tableHeaderView = [self tableViewHeaderView];
            [_tableView.tableFooterView removeFromSuperview];
            _tableView.tableFooterView   = [self tableViewFooterView];
            _totalLabel.text = [NSString stringWithFormat:@"应付金额：%@",self.order_amount_formatted];
            self.consignee = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"consignee"] ;
            

            [self getAddressList];

        }else{
        
            [self show:@"获取失败" time:1];
        }
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   [self show:@"请求失败！" time:1];
                   MMLog(@"%@",error);
                   
               }
     ];
    
}
#pragma mark -- 收货地址的处理；
-(void)getAddressList
{
    
    if (self.consignee[@"address_id"]) {
        _address_id = self.consignee[@"address_id"];
    }
    if (self.consignee[@"idcard"]) {
        
        if (![self.consignee[@"idcard"][@"identity_card_front_thumb"] isEqualToString:@""]  &&![self.consignee[@"idcard"][@"identity_card_backend_thumb"] isEqualToString:@""]) {
            _photoArr = @[self.consignee[@"idcard"][@"identity_card_front_thumb"],self.consignee[@"idcard"][@"identity_card_backend_thumb"]];
            _isCard = YES;
        }else{
            UIImage *image  = [UIImage imageNamed:@"addPhoto_image"];
            _photoArr = @[image,image];
        }
        
        NSDictionary *cardDic = self.consignee[@"idcard"];
        NSString *str1 = cardDic[@"real_name"];
        NSString *str2 = cardDic[@"identity_card"];
        if (cardDic) {
            _is_black =  [NSString stringWithFormat:@"%@",cardDic[@"is_black"]];
            
            if (str1 &&![str1 isEqualToString:@""]) {
                _real_name = str1;
            }
            if (str2 &&![str2 isEqualToString:@""]) {
                _identity_card = str2;
            }
            
        }
        
        
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [self tableViewFooterView];
    }else{
        UIImage *image  = [UIImage imageNamed:@"addPhoto_image"];
        _photoArr = @[image,image];
        _is_black = @"0";
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [self tableViewFooterView];
    }
    
    [_tableView reloadData];
    
    
    
  
    
}

- (UIView *)tableViewHeaderView{
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = BG_COLOR;
    headerView.frame = CGRectMake(0, 0, self.view.ml_width,65);
    UIView *headerBoxView = [[UIView alloc] init];
    headerBoxView.backgroundColor = [UIColor whiteColor];
    headerBoxView.frame = CGRectMake(0, 0, self.view.ml_width, 55);
    UIImage *Image = [UIImage imageNamed:@"next"] ;
    UIImageView *imageview = [[UIImageView alloc ]init];
    imageview.image = Image;
    imageview.frame = CGRectMake(CGRectGetWidth(headerBoxView.frame) -Image.size.width *2, 18, 16, 16);
    [headerBoxView addSubview:imageview];
    [headerView addSubview:headerBoxView];
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressClick:)];
    [headerView addGestureRecognizer:ger];
    
    if (self.consignee) {
        UILabel *consigneeLabel = [[UILabel alloc] init];
        consigneeLabel.frame = CGRectMake(MARGIN_8, 10, self.view.ml_width * 0.5, 18);
        consigneeLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.font = [UIFont systemFontOfSize:15];
        phoneLabel.frame = CGRectMake(consigneeLabel.ml_width, 10, self.view.ml_width * 0.5, 18);
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = [UIFont systemFontOfSize:13];
        addressLabel.frame = CGRectMake(MARGIN_8, CGRectGetMaxY(consigneeLabel.frame) + MARGIN_5, self.view.ml_width - MARGIN_20, 15);
        
        NSString *name = [_consignee valueForKeyPath:@"consignee"];
        consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@" ,name];
        phoneLabel.text = [_consignee valueForKeyPath:@"mobile"];
        NSString *province_name = [_consignee valueForKeyPath:@"province_name"];
        NSString *district_name = [_consignee valueForKeyPath:@"district_name"];
        NSString *address = [_consignee valueForKeyPath:@"address"];
        addressLabel.text = [NSString stringWithFormat:@"收货地址：%@%@%@",province_name,district_name,address];
        _address.text = addressLabel.text;
        [headerBoxView addSubview: consigneeLabel];
        [headerBoxView addSubview:phoneLabel];
        [headerBoxView addSubview:addressLabel];
        
    }else{
        
        UIImage *Image = [UIImage imageNamed:@"address_add"] ;
        UIImageView *imageview = [[UIImageView alloc ]init];
        imageview.image = Image;
        imageview.frame = CGRectMake(10, 20, 20, 20);
        [headerBoxView addSubview:imageview];
        
        UILabel *consigneeLabel = [[UILabel alloc] init];
        consigneeLabel.frame = CGRectMake(Image.size.width+10, 0, self.view.ml_width-Image.size.width, 60);
        consigneeLabel.font = [UIFont systemFontOfSize:18];
        consigneeLabel.textAlignment = NSTextAlignmentLeft;
        consigneeLabel.text = @"请添加收货地址";
        consigneeLabel.textColor = [UIColor colorWithHexString:@"2ba390"];
        
        [headerBoxView addSubview:consigneeLabel];
    }
    
    return headerView;
}

- (UIView *)tableViewFooterView{
    if (![self.is_cross_border isEqualToString:@"0"]) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.frame = CGRectMake(0, 0, self.view.ml_width, 450+60);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 110)];
        if (![_is_black isEqualToString:@"0"]) {
            
            view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 140);
        }
        if(![_is_over_sea isEqualToString:@"0"]){
        
            view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 290);
            footerView.frame = CGRectMake(0, 0, self.view.ml_width, 390+180);
            
         
        }
         view.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:view];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view.ml_height -10, UISCREEN_WIDTH, 10)];
        view2.backgroundColor = BG_COLOR;
        [view addSubview:view2];
        
        UILabel *lable2 = [[UILabel alloc]init];
        
        NSString *name = [_consignee valueForKeyPath:@"consignee"];
        if (name) {
               lable2.text = [NSString stringWithFormat:@"收货人姓名：%@",name] ;
        }
        lable2.font = [UIFont systemFontOfSize:14];
        [view addSubview:_nameLabel = lable2];
        [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(8);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *lable3 = [[UILabel alloc] init];
        lable3.text = @"身 份 证 号：" ;
        lable3.font = [UIFont systemFontOfSize:14];
        [view addSubview:lable3];
        [lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lable2.mas_bottom).offset(8);
            make.left.mas_equalTo(8);
            make.height.mas_equalTo(20);
        }];
        
        UITextField *textField1 = [[UITextField alloc] init];
        textField1.font  = [UIFont systemFontOfSize:14];
        textField1.layer.borderWidth = 1;
        textField1.layer.borderColor = [UIColor grayColor].CGColor ;
        [view addSubview:_cardTextField = textField1];
        [textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lable3.mas_right).offset(0);
            make.top.equalTo(lable2.mas_bottom).offset(8);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(150);
        }];
        UILabel *lable1 = [[UILabel alloc] init];
        
        if (_identity_card) {
            
                [textField1 removeFromSuperview];
              
                NSRange range = NSMakeRange(6, 8);
                
               
                if (_identity_card.length>15) {
                     NSString *newNumb = [_identity_card stringByReplacingCharactersInRange:range withString:@"****"];
                       lable1.text = newNumb;;
                }
                
                lable1.font = [UIFont systemFontOfSize:14];
                [view addSubview:lable1];
                [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lable3.mas_right).offset(0);
                    make.top.equalTo(lable2.mas_bottom).offset(8);
                    make.height.mas_equalTo(20);
                    
                }];
 
            
            
        }
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (![_is_black isEqualToString:@"0"]) {
            [button setBackgroundImage:[UIImage imageNamed:@"card_validation1"] forState:  UIControlStateNormal];
            [button setTitle:@"已拉黑" forState:UIControlStateNormal];

        }else{
            if (_identity_card) {
                [button setBackgroundImage:[UIImage imageNamed:@"card_validation1"] forState:  UIControlStateNormal];
                [button setTitle:@"已验证" forState:UIControlStateNormal];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"card_validation"] forState:  UIControlStateNormal];
                [button setTitle:@"验证" forState:UIControlStateNormal];
            }
            
        }
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(validation:) forControlEvents: UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_identity_card) {
                 make.left.equalTo(lable1.mas_right).offset(10);
            }else{
             make.left.equalTo(textField1.mas_right).offset(10);
            }
            make.top.equalTo(lable2.mas_bottom).offset(8);
           
            make.size.mas_equalTo(CGSizeMake(50, 20));
        }];
        UIImageView *imageview1 = [[UIImageView alloc]init];
         UILabel *lables = [[UILabel alloc] init];
        if (![_is_black isEqualToString:@"0"]) {
            imageview1.image = [UIImage imageNamed:@"cared_dele"];
            [view addSubview:imageview1];
            [imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lable3.mas_bottom).offset(12);
                make.left.mas_equalTo(8);
                make.size.mas_equalTo(CGSizeMake(10, 10));
                
            }];
            
           
            lables.text = @"对不起，该身份证号因提交跨境购订单过多，已被海关列入黑名单，请更换收货人姓名和身份证号重新下单。";
            lables.textColor = [UIColor redColor];
            lables.font = [UIFont systemFontOfSize:10];
            lables.numberOfLines = 0;
            [view addSubview:lables];
            [lables mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(lable3.mas_bottom).offset(10);
                make.left.equalTo(imageview1.mas_right).offset(3);
                make.right.mas_equalTo(0);
            }];
        }

                UILabel *lable4 = [[UILabel alloc] init];
                lable4.text = @"为什么要需要身份证?";
                lable4.font= [UIFont systemFontOfSize:12];
                lable4.textColor = [UIColor redColor];
                [view addSubview:lable4];
                [lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (![_is_black isEqualToString:@"0"]) {
                        make.top.equalTo(lables.mas_bottom).offset(10);
                    }else {
                     make.top.equalTo(lable3.mas_bottom).offset(10);
                    }
                   
                    make.left.mas_equalTo(10);
        
                }];
        
                UIView *view3 = [[UIView alloc] init];
                view3.backgroundColor = [UIColor redColor];
                [view addSubview:view3];
                [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lable4.mas_bottom).offset(0);
                    make.left.mas_equalTo(10);
                    make.width.mas_equalTo(lable4.mas_width);
                    make.height.mas_equalTo(1);
        
                }];
        
                UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
       
                [button1 addTarget:self action:@selector(PromptInformation) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button1];
                [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (![_is_black isEqualToString:@"0"]) {
                       make.top.equalTo(lables.mas_bottom).offset(5);
                    }else{
                        make.top.equalTo(lable3.mas_bottom).offset(5);
                    }
                
                    make.left.mas_equalTo(10);
                    make.width.mas_equalTo(lable4.mas_width);
                    make.height.mas_equalTo(25);
                }];

       if(![_is_over_sea isEqualToString:@"0"]){
            NSString *name = [_consignee valueForKeyPath:@"consignee"];
            MBAddIDCardView *idCardView = [MBAddIDCardView instanceView];
            [view addSubview:idCardView];
           __unsafe_unretained __typeof(self) weakSelf = self;
            [idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(button1.mas_bottom).offset(0);
                 make.left.mas_equalTo(0);
                 make.right.mas_equalTo(0);
                 make.height.mas_equalTo(180);
            }];
           
           
           idCardView.VC = self;
           idCardView.name = name;
           idCardView.idCard = _identity_card;
           idCardView.photoArray = [NSMutableArray arrayWithArray:_photoArr];
           idCardView.block = ^(BOOL isbool ){
               weakSelf.isCard = isbool;
           
           };
           
        }
        
        
        UILabel *totalLbl = [[UILabel alloc] init];
        totalLbl.font = [UIFont systemFontOfSize:14];
        
        totalLbl.text = [NSString stringWithFormat:@"商品金额：%@",self.goods_amount_formatted];
        totalLbl.frame = CGRectMake(8, CGRectGetMaxY(view.frame)+10, self.view.ml_width, 15);
        
        UILabel *freightLbl = [[UILabel alloc] init];
        freightLbl.font = [UIFont systemFontOfSize:14];
        freightLbl.text = [NSString stringWithFormat:@"运       费：%@",self.shipping_fee_formatted];
        freightLbl.frame = CGRectMake(8, CGRectGetMaxY(totalLbl.frame) + MARGIN_5, self.view.ml_width, 15);
        
        UILabel *vouchersLbl = [[UILabel alloc] init];
        vouchersLbl.font = [UIFont systemFontOfSize:14];
        
        
        vouchersLbl.text = _discount_formatted?[NSString stringWithFormat:@"专场优惠：%@",_discount_formatted]:@"¥0.00";
            
        
        
        vouchersLbl.frame = CGRectMake(8, CGRectGetMaxY(freightLbl.frame) + MARGIN_5, self.view.ml_width, 15);
        
        UILabel *rateLbl = [[UILabel alloc] init];
        rateLbl.font = [UIFont systemFontOfSize:14];
        rateLbl.text =   [NSString stringWithFormat:@"税       费：%@",self.cross_border_tax];
        rateLbl.frame = CGRectMake(8, CGRectGetMaxY(vouchersLbl.frame) + MARGIN_5, self.view.ml_width, 0);
        
        
        UILabel *remarkLbl = [[UILabel alloc] init];
        remarkLbl.font = [UIFont systemFontOfSize:14];
        remarkLbl.text = [NSString stringWithFormat:@"备       注：%@",@""];
        remarkLbl.frame = CGRectMake(8, CGRectGetMaxY(rateLbl.frame) + MARGIN_5, 70, 15);
        
        UITextField *remarkTxt = [[UITextField alloc] init];
        remarkTxt.font = [UIFont systemFontOfSize:14];
        remarkTxt.delegate = self;
        remarkTxt.placeholder = @"请输入备注信息";
        
        remarkTxt.frame = CGRectMake(5 + remarkLbl.ml_width, CGRectGetMaxY(rateLbl.frame) + MARGIN_5, self.view.ml_width-60-8, 15);
        _beizhu = remarkTxt;
        
        
        //添加优惠券和红包选择
        UIView * invoiceView = [self setBonusView:remarkLbl margin:MARGIN_10 text:@"发票信息" type:3];
        UIView * couponView = [self setBonusView:invoiceView margin:0 text:@"使用代金券" type:0];
        UIView * beanView = [self setBonusView:couponView margin:0 text:@"使用麻豆" type:4];
        UIView * bonusView = [self setBonusView:beanView margin:0 text:@"使用红包或兑换券" type:1];
        UIView * babyCard = [self setBonusView:bonusView margin:0 text:@"使用麻包卡" type:2];
        [footerView addSubview:totalLbl];
        [footerView addSubview:freightLbl];
        [footerView addSubview:rateLbl];
        [footerView addSubview:vouchersLbl];
        [footerView addSubview:remarkLbl];
        [footerView addSubview:remarkTxt];
        
        
        //红包
        [footerView addSubview:invoiceView];
        [footerView addSubview:couponView];
        [footerView addSubview:beanView];
        [footerView addSubview:bonusView];
        [footerView addSubview:babyCard];
        UITapGestureRecognizer *ger0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(invoiceClick:)];
        [invoiceView addGestureRecognizer:ger0];
        UITapGestureRecognizer *ger1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponClick:)];
        [couponView addGestureRecognizer:ger1];
        UITapGestureRecognizer *ger4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beanViewClick:)];
        [beanView addGestureRecognizer:ger4];
 
        UITapGestureRecognizer *ger2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bonusClick:)];
        [bonusView addGestureRecognizer:ger2];
              [self addBottomLineView:footerView];
        UITapGestureRecognizer *ger3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(babyCardClick:)];
        [babyCard addGestureRecognizer:ger3];
        [self addBottomLineView:footerView];
        return footerView;
        
    }else{
        
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.frame = CGRectMake(0, 0, self.view.ml_width, 280+60+60);
        UILabel *totalLbl = [[UILabel alloc] init];
        totalLbl.font = [UIFont systemFontOfSize:14];
        
        totalLbl.text = [NSString stringWithFormat:@"商品金额：%@",self.goods_amount_formatted];
        totalLbl.frame = CGRectMake(8, 10, self.view.ml_width, 15);
        
        UILabel *freightLbl = [[UILabel alloc] init];
        freightLbl.font = [UIFont systemFontOfSize:14];
        freightLbl.text = [NSString stringWithFormat:@"运       费：%@",self.shipping_fee_formatted];
        freightLbl.frame = CGRectMake(8, CGRectGetMaxY(totalLbl.frame) + MARGIN_5, self.view.ml_width, 15);
        
        UILabel *vouchersLbl = [[UILabel alloc] init];
        vouchersLbl.font = [UIFont systemFontOfSize:14];
        vouchersLbl.text = [NSString stringWithFormat:@"专场优惠：%@",_discount_formatted];
 
       
        vouchersLbl.frame = CGRectMake(8, CGRectGetMaxY(freightLbl.frame) + MARGIN_5, self.view.ml_width, 15);
        
        UILabel *rateLbl = [[UILabel alloc] init];
        rateLbl.font = [UIFont systemFontOfSize:14];
        rateLbl.text =   [NSString stringWithFormat:@"税       费：%@",self.cross_border_tax];
        rateLbl.frame = CGRectMake(8, CGRectGetMaxY(vouchersLbl.frame) + MARGIN_5, self.view.ml_width, 0);

        
        UILabel *remarkLbl = [[UILabel alloc] init];
        remarkLbl.font = [UIFont systemFontOfSize:14];
        remarkLbl.text = [NSString stringWithFormat:@"备       注：%@",@""];
        remarkLbl.frame = CGRectMake(8, CGRectGetMaxY(rateLbl.frame) + MARGIN_5, 70, 15);
       
        UITextField *remarkTxt = [[UITextField alloc] init];
        remarkTxt.font = [UIFont systemFontOfSize:14];
        remarkTxt.delegate = self;
        remarkTxt.placeholder = @"请输入备注信息";
        
        remarkTxt.frame = CGRectMake(5 + remarkLbl.ml_width, CGRectGetMaxY(rateLbl.frame) + MARGIN_5, self.view.ml_width-60-8, 15);
        _beizhu = remarkTxt;
        
        
        
        
        //添加优惠券和红包选择
        UIView * invoiceView = [self setBonusView:remarkLbl margin:MARGIN_10 text:@"发票信息" type:3];
        UIView * couponView = [self setBonusView:invoiceView margin:0 text:@"使用代金券" type:0];
        UIView * beanView = [self setBonusView:couponView margin:0 text:@"使用麻豆" type:4];
        UIView * bonusView = [self setBonusView:beanView margin:0 text:@"使用红包或兑换券" type:1];
        UIView * babyCard = [self setBonusView:bonusView margin:0 text:@"使用麻包卡" type:2];
        
        [footerView addSubview:totalLbl];
        [footerView addSubview:freightLbl];
        [footerView addSubview:rateLbl];
        [footerView addSubview:vouchersLbl];
        [footerView addSubview:remarkLbl];
        [footerView addSubview:remarkTxt];
        
        
        //红包
        [footerView addSubview:invoiceView];
        [footerView addSubview:couponView];
        [footerView addSubview:beanView];
        [footerView addSubview:bonusView];
        [footerView addSubview:babyCard];
        
        UITapGestureRecognizer *ger0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(invoiceClick:)];
        [invoiceView addGestureRecognizer:ger0];
        UITapGestureRecognizer *ger1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponClick:)];
        [couponView addGestureRecognizer:ger1];
        
        UITapGestureRecognizer *ger4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beanViewClick:)];
        [beanView addGestureRecognizer:ger4];
        
        UITapGestureRecognizer *ger2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bonusClick:)];
        [bonusView addGestureRecognizer:ger2];
        
        
        UITapGestureRecognizer *ger3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(babyCardClick:)];
        [babyCard addGestureRecognizer:ger3];
        
        
        [self addBottomLineView:footerView];
        
        return footerView;

    
    
    }
    
}
#pragma mark --选取收货地址
-(void)addressClick:(UITapGestureRecognizer *)ger
{
    MBShopAddresViewController *addressVc = [[MBShopAddresViewController alloc] init];
    
    [self pushViewController:addressVc Animated:YES];
}
#pragma mark--身份证验证按钮
- (void)validation:(UIButton *)button{
    [_cardTextField resignFirstResponder];
  
    if ([button.titleLabel.text isEqualToString:@"验证"]) {
        
           [self authentication];
    }
 
    
}
#pragma mark--为何验证身份证提示；
- (void)PromptInformation{
 [_cardTextField resignFirstResponder];
   
    UIView* baseline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    baseline.backgroundColor = [UIColor blackColor];
    baseline.alpha = 0.5 ;
    [self.view addSubview:_view2 = baseline];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view1 = view];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"care_cancel"] forState: UIControlStateNormal ];
    [button addTarget:self action:@selector(dele) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.text = @"      尊敬的麻米，根据海关规定，跨境购商品需要办理跨境购商品清单手续，需要您填写身份证信息进行实名认证，以保证您购买的商品顺利通过入境申报。";
    lable1.font = [UIFont systemFontOfSize:12];
    lable1.backgroundColor = [UIColor whiteColor];
    lable1.numberOfLines = 0;
    [view addSubview:lable1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lable1.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lable1.text length])];
    lable1.attributedText = attributedString;
    [lable1 sizeToFit];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    
            UIImageView *imageview = [[UIImageView alloc] init];
            imageview.image = [UIImage imageNamed:@"card_volume"];
            [view addSubview:imageview];
            [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(lable1.mas_bottom).offset(6);
                make.left.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(10, 10));
    
            }];
            UILabel *lable5 = [[UILabel alloc] init];
            lable5.text = @"温馨提示：";
            lable5.font = [UIFont systemFontOfSize:12];
            lable5.textColor = [UIColor redColor];
            [view addSubview:lable5];
            [lable5 mas_makeConstraints:^(MASConstraintMaker *make) {
               make.baseline.equalTo(imageview.mas_baseline).offset(0);
               make.left.equalTo(imageview.mas_right).offset(3);
    
            }];
            UILabel *lable6 = [[UILabel alloc] init];
            lable6.text = @"收货人请填写与身份证对应的真实姓名，否则您的订单无法通过海关审批。";
            lable6.font = [UIFont systemFontOfSize:12];
            //lable6.textColor = [UIColor redColor];
            lable6.numberOfLines = 0;
            [view addSubview:lable6];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:lable6.text];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:2];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [lable6.text length])];
    lable6.attributedText = attributedString2;
    [lable6 sizeToFit];

            [lable6 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(lable1.mas_bottom).offset(4);
                make.left.equalTo(lable5.mas_right).offset(1);
                make.right.mas_equalTo(-10);
            }];
    
    UILabel *lable2 = [[UILabel alloc] init];
    lable2.text = @"小麻包承诺：身份证信息视如 “ 绝密档案” 保管，绝不对外泄露。";
    lable2.textColor  = [UIColor redColor];
    lable2.font = [UIFont    systemFontOfSize:12];
    lable2.numberOfLines = 0;
    [view addSubview:lable2];
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:lable2.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [lable2.text length])];
    lable2.attributedText = attributedString1;
    [lable2 sizeToFit];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lable6.mas_bottom).offset(6);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];

    
    
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(UISCREEN_HEIGHT/2-100);
        make.bottom.equalTo(lable2.mas_bottom).offset(20);
    }];
}
-(void)dele{

    [_view1 removeFromSuperview];
    [_view2 removeFromSuperview];

}
/**
 *  设置红包或优惠券
 *
 *  @param preView 前一个UI
 *  @param margin  上边距
 *  @param text    文字内容
 *
 *  @return 设置区域
 */
- (UIView *)setBonusView:(UIView *)preView margin:(NSInteger)margin text:(NSString *)text type:(NSInteger)type{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = BG_COLOR;
    headerView.frame = CGRectMake(0, CGRectGetMaxY(preView.frame)+margin, UISCREEN_WIDTH, 60);
    UIView *headerBoxView = [[UIView alloc] init];
    headerBoxView.backgroundColor = [UIColor whiteColor];
    headerBoxView.frame = CGRectMake(0, MARGIN_10, UISCREEN_WIDTH, 50);
    
    UIImage *Image = [UIImage imageNamed:@"next"] ;
    UIImageView *imageview = [[UIImageView alloc ]init];
    imageview.image = Image;
    imageview.frame = CGRectMake(CGRectGetWidth(headerBoxView.frame) -Image.size.width *2, 18, 16, 16);
    
    [headerBoxView addSubview:imageview];
    
    UILabel *consigneeLabel = [[UILabel alloc] init];
    consigneeLabel.frame = CGRectMake(8, 0,140, 50);
    consigneeLabel.font = [UIFont systemFontOfSize:16];
    consigneeLabel.textAlignment = NSTextAlignmentLeft;
    consigneeLabel.text = text;
    consigneeLabel.textColor = [UIColor redColor];
    consigneeLabel.backgroundColor = [UIColor whiteColor];
    if(type==0){
        //优惠券获取内容
        _couponLbl = [[UILabel alloc] init];
        _couponLbl.frame = CGRectMake(consigneeLabel.ml_width+8, 0,self.view.ml_width-Image.size.width*2-8-consigneeLabel.ml_width, 50);
        _couponLbl.font = [UIFont systemFontOfSize:14];
        if (_strCoupon) {
             _couponLbl.text = _strCoupon;
        }
        _couponLbl.textAlignment = NSTextAlignmentRight;
        [headerBoxView addSubview:_couponLbl];
    }else  if(type  == 1){
        //红包获取内容
        _bonusLbl = [[UILabel alloc] init];
        _bonusLbl.frame = CGRectMake(consigneeLabel.ml_width+8, 0,self.view.ml_width-Image.size.width*2-8-consigneeLabel.ml_width, 50);
        _bonusLbl.font = [UIFont systemFontOfSize:14];
        if (_strHongbao) {
            _bonusLbl.text = _strHongbao;
        }
        _bonusLbl.textAlignment = NSTextAlignmentRight;
        [headerBoxView addSubview:_bonusLbl];
    }else if (type  == 2){
        //可使用麻包卡金额
        _babycard = [[UILabel alloc] init];
        _babycard.frame = CGRectMake(consigneeLabel.ml_width+8, 0,self.view.ml_width-Image.size.width*2-8-consigneeLabel.ml_width, 50);
        _babycard.font = [UIFont systemFontOfSize:14];
        if (self.surplus) {
            _babycard.text = self.surplus;
        }
        _babycard.textAlignment = NSTextAlignmentRight;
        [headerBoxView addSubview:_babycard];
    
    }else if (type  == 4){
        //可使用麻豆
        _beanLabel = [[UILabel alloc] init];
        _beanLabel.frame = CGRectMake(consigneeLabel.ml_width+8, 0,self.view.ml_width-Image.size.width*2-8-consigneeLabel.ml_width, 50);
        _beanLabel.font = [UIFont systemFontOfSize:14];
        _beanLabel.textAlignment = NSTextAlignmentRight;
        [headerBoxView addSubview:_beanLabel];
      
        if (_bean_fee) {
            
            _beanLabel.text =  [NSString stringWithFormat:@"￥%@",_bean_fee];
        }
        
    
    }else{
        //发票信息
        _invoiceLbl = [[UILabel alloc] init];
        _invoiceLbl.frame = CGRectMake(consigneeLabel.ml_width+8, 0,self.view.ml_width-Image.size.width*2-8-consigneeLabel.ml_width, 50);
        _invoiceLbl.font = [UIFont systemFontOfSize:14];
        if (_invoiceText) {
            _invoiceLbl.text = _invoiceText;
        }
        _invoiceLbl.textAlignment = NSTextAlignmentRight;
        [headerBoxView addSubview:_invoiceLbl];
    }
    [headerBoxView addSubview:consigneeLabel];
    [headerView addSubview:headerBoxView];

    return headerView;
}

/**
 *  红包单击事件
 *
 *  @param ger 点击手势
 */
-(void)bonusClick:(UITapGestureRecognizer *)ger{
    if (self.couponId) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已使用了代金券不可以在使用红包或兑货券" delegate: self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerView show];
    }else{
    
    [self showOkayCancelAlert];
    }
    
}

-(void)invoiceClick:(UITapGestureRecognizer *)ger{

    MBInvoiceViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBInvoiceViewController"];
    WS(weakSelf)
    VC.block = ^(NSString *inv_payee,NSString *inv_type,NSString *inv_content){
        
        weakSelf.invoiceLbl.text = inv_content;
        weakSelf.inv_payee = inv_payee;
        weakSelf.inv_type = inv_type;
        weakSelf.inv_content = inv_content;
        
    };
    [self pushViewController:VC Animated:YES];
    
}
- (void)beanViewClick:(UITapGestureRecognizer *)ger{
    
    [self giveFriend];
    
}
- (void)giveFriend{

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/bean/number") parameters:@{@"session":dict} success:^(id responseObject) {
        [self dismiss];
        if (responseObject) {
            MBBeanUseViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBBeanUseViewController"];
            VC.number = [NSString stringWithFormat:@"%@",responseObject[@"number"]];
            WS(weakSelf)
            VC.block = ^(NSString *mabaobean_number){
                weakSelf.mabaobean_number = mabaobean_number;
                
                [weakSelf beforeCreateOrder];

            };
            [self pushViewController:VC Animated:true];
        }



    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:.8];
    }];


}
/**
 *  优惠券单击事件
 *
 *  @param ger 点击手势
 */
-(void)couponClick:(UITapGestureRecognizer *)ger{
    if (_bonus_id) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已使用了红包或兑货券不可以在使用代金券" delegate: self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alerView show];
        
    }else{
        MBVoucherViewController *vc = [[MBVoucherViewController alloc] init];
        vc.is_fire = @"yes";
        vc.order_money = self.order_amount;
    
        @weakify(self);
        [[vc.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *coupon) {
            @strongify(self);
      
            self.couponId = coupon [@"bonus_id"];
            _strCoupon   =  coupon [@"type_name"];
            //更新底部价格
            float totalMoney = self.order_amount.floatValue;
            float type_money = [coupon [@"type_money"] floatValue];
            _couponMoney =      coupon[@"type_money"];
            _tableView.tableFooterView = [self tableViewFooterView];
            float money = totalMoney - type_money;
            if(money < 0)
                money = 0;
            self.totalLabel.text = [NSString stringWithFormat:@"应付金额：￥%.2lf",money];
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
    
    }
   
}
/**
 *  麻包卡点击事件
 *
 *  @param ger 点按手势
 */

-(void)babyCardClick:(UITapGestureRecognizer *)ger{
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
        
        MMLog(@"%@",_cards);
        
        
        [self beforeCreateOrder];
       
        
    }];
    [self pushViewController:VC Animated:YES];
}
//根据产品sid(session_id)、uid生成订单前的订单确认接口
-(void)beforeCreateOrder
{
    if (!_mabaobean_number) {
        _mabaobean_number = @"";
    }
    
    [self show];
  
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/checkout"] parameters:@{@"session":sessiondict,@"cards":self.cards,@"mabaobean_number":_mabaobean_number}success:^(NSURLSessionDataTask *operation, id responseObject) {
        
//        MMLog(@"成功---生成订单前的订单确认接口%@",[responseObject valueForKeyPath:@"data"]);
        
        NSMutableArray * infoDict = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_list"];
        
        
        
        self.total = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"total"];
       
        self.CartinfoDict = infoDict;
        self.cartinfoArray = self.CartinfoDict;
        self.order_amount = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"order_amount"];
        self.order_amount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"order_amount_formatted"];
        self.cross_border_tax = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"cross_border_tax"];
        self.shipping_fee_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"shipping_fee_formatted"];
        self.goods_amount = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_amount"];
        self.goods_amount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_amount_formatted"];
        self.discount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"discount_formatted"];
        
        self.surplus = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"surplus"];

        self.consignee = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"consignee"] ;
        
        NSString *str  = [NSString stringWithFormat:@"%@",[[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"real_name"]];
        NSString *str1 = [NSString stringWithFormat:@"%@",[[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"is_over_sea"]];
        _bean_fee = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"bean_fee"];
        self.is_cross_border = str;
        self.is_over_sea = str1;
        self.CartDict =  [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"s_goods_list"];
        [self dismiss];
         [self setupTabbarView];
        [_tableView reloadData];
         _tableView.tableFooterView = [self tableViewFooterView];

    }
     
     
               failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   [self show:@"请求失败！" time:1];
                   MMLog(@"%@",error);
                   
               }
     ];
    
}
#pragma mark --底部提交按钮
- (void)setupTabbarView{
    CGFloat tabbarHeight = 35;
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, self.view.ml_height - tabbarHeight, self.view.ml_width, tabbarHeight);
    [self.view addSubview:bottomView];
    
    [self addTopLineView:bottomView];
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.font = [UIFont systemFontOfSize:14];
    _totalLabel.frame = CGRectMake(20, 0, 200, bottomView.ml_height);
    
    _totalLabel.text = [NSString stringWithFormat:@"应付金额：%@",self.order_amount_formatted];
    [bottomView addSubview:_totalLabel];
    
    CGFloat submitButtonWidth = 90;
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(self.view.ml_width - submitButtonWidth, 0, submitButtonWidth, bottomView.ml_height);
    submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor colorWithHexString:@"e8455d"];
    [bottomView addSubview:submitButton];
    //点击确认订单
    [submitButton addTarget:self action:@selector(goPaymentVc) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ---提交订单数据
- (void)getDingdanINfo:(MBPaymentViewController *)VC
{
    
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *name = [_consignee valueForKeyPath:@"consignee"];
    if (!_identity_card) {
        _identity_card = @"";
        _real_name = @"";
    }
    if (!self.couponId) {
        self.couponId = @"";
    }
    
    if (!_bonus_id) {
        _bonus_id = @"";
    }
    if (!_inv_payee) {
        _inv_payee = @"";
        _inv_type= @"";
        _inv_content = @"";
    }
    if (!_mabaobean_number) {
        _mabaobean_number = @"";
    }
    if (!name) {
        [self show:@"收货人姓名不能为空" time:1];
        return;
    }
    if (!_address_id) {
        [self show:@"收货人地址ID不存在" time:1];
        return;
    }
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/done_new"]parameters:@{@"session":dict,@"pay_id":@"3",@"shipping_id":@"4",@"address_id":_address_id,@"bonus_id":_bonus_id,@"coupon_id":self.couponId,@"integral":@"",@"inv_type":_inv_type,@"inv_content":_inv_content,@"inv_payee" :_inv_payee,@"real_name":name,@"identity_card":_identity_card,@"cards":self.cards,@"mabaobean_number":_mabaobean_number}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                 
                   [self dismiss];
                   
                   NSDictionary *dict = [responseObject valueForKeyPath:@"status"];
                  
                   if ([responseObject valueForKeyPath:@"data"]) {
                       VC.orderInfo = [responseObject valueForKeyPath:@"data"][@"order_info"];
                       
                       VC.type = @"1";
                       VC.order_sn = VC.orderInfo[@"order_sn"];
                       [self.navigationController pushViewController:VC animated:YES];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCart" object:nil];
                       
                   }else{
                        MMLog(@"%@",dict);
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"error_desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                       [alert show];
                   }
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   MMLog(@"----%@",error);
                 [self show:@"请求失败！" time:1];
                  
                   
               }];
    
}
#pragma mark --提交订单前的一堆判断逻辑
/***  一堆判断逻辑－先的有收获地址 -跨境购的需要实名认证－ 海外直邮的需要上传身份证 */
- (void)goPaymentVc{
    /***  是否存在收货地址*/
    if (self.consignee) {
        MBPaymentViewController *payVc = [[MBPaymentViewController alloc] init];
        /***  是否跨境购*/
        if (![self.is_cross_border isEqualToString:@"0"]) {
            /***  是否被海关拉黑*/
            if ([_is_black isEqualToString:@"0"]) {
                /***  是否实名认证*/
                if (_identity_card) {
                    /***  是否是海外直邮*/
                    if (![_is_over_sea isEqualToString:@"0"]) {
                        /***海外直邮身份证是否上传*/
                        if (_isCard) {
                            [self getDingdanINfo:payVc];
                        }else{
                            [self show:@"请上传身份证照片" time:1];
                        }
                    }else{
                        [self getDingdanINfo:payVc];
                    }
                    
                    
                }else{
                    UIAlertView *alerView1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"跨境购商品需要先实名认证。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    ;
                    [alerView1 show];
                }
                
            }else {
                
                UIAlertView *alerView1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该收货人的身份证已被海关拉黑，请更换收货人。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alerView1 show];
            }
        }else{
            
            
            [self getDingdanINfo:payVc];
            
            
        }
        
        
    }else{
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"收货地址不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"添加收货地址", nil];
        alerView.tag = 222;
        [alerView show];
    }
}
- (NSString *)titleStr{
    return @"确认订单";
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
       
        [self getBonusBySn:bonus_sn order_money:self.order_amount];
        
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
                       //更新底部价格
                       float totalMoney =  [dic[@"type_money"] floatValue ];
                       float type_money;
                       if (self.couponId) {
                           type_money = [_totalLabel.text floatValue] -totalMoney;
                       }else{
                           type_money = self.order_amount.floatValue -totalMoney;
                       }
                        _hongbaoMoney = dic[@"type_money"];
                        _strHongbao = dic[@"type_name"];
                        self.totalLabel.text = [NSString stringWithFormat:@"应付金额：￥%.2lf",type_money];
                        _tableView.tableFooterView = [self tableViewFooterView];
        
             
                      
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

    return _array.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self.CartDict objectForKey:_array[section]][@"goods_list"];
    return arr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    orderHeadView *headerView = [orderHeadView instanceView];
    headerView.headLableText.text = _array[section];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    orderFootView *footView = [orderFootView instanceView];
     NSDictionary *dic = [self.CartDict objectForKey:_array[section]];
    footView.priceLabletext.text = dic[@"shipping_fee"];
    footView.shuifeiLabletext.text = dic[@"cross_border_money"];
    footView.zongjiaLabeltext.text = [NSString stringWithFormat:@"共%@件商品，总计%@",dic[@"number"],dic[@"total_money"]];
    return footView;

}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    MBFireOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBFireOrderTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBFireOrderTableViewCell" owner:nil options:nil]firstObject];
    }
    NSDictionary *dic = [self.CartDict objectForKey:_array[indexPath.section]][@"goods_list"][indexPath.row];
    
    cell.countNumber.text = [NSString stringWithFormat:@"X %@",dic[@"goods_number"]];
    cell.countprice.text = dic[@"subtotal_formatted"];
    cell.desribe.text = dic[@"goods_name"];
    [cell.showimageview sd_setImageWithURL:[NSURL URLWithString:dic[@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 61;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}



#pragma mark --要开始移动scrollView时调用（移除键盘）

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;{
    [_cardTextField resignFirstResponder];
    [_beizhu resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
     [_cardTextField resignFirstResponder];
    return YES;
}
#pragma mark -- 验证身份证
- (void)authentication{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    NSString *name = _consignee [@"consignee"];
    
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    if (!name) {
        [self show:@"收货人姓名不能为空" time:1];
        return;
    }
    [MBNetworking POSTOrigin:[NSString stringWithFormat:@"%@/idcard/add",BASE_URL_root] parameters:@{@"real_name":name, @"identity_card":_cardTextField.text,@"session":sessiondict} success:^(id responseObject) {
        [self dismiss];
        if ([s_str(responseObject[@"status"]) isEqualToString:@"1"]) {
            [self show:responseObject[@"msg"] time:1];
            _identity_card = _cardTextField.text;
            _is_black = @"0";
            _tableView.tableFooterView = [self tableViewFooterView];
        }else{
            if (responseObject[@"msg"]) {
                [self show:responseObject[@"msg"] time:1];
            }else{
            
                [self show:@"绑定失败" time:1];
            }
            
        }
 
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        
        [self show:@"请求失败" time:1];
    }];
    
}


@end
