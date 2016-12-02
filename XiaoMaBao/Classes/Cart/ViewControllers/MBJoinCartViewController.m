//
//  MBOrderBuyViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/4.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBJoinCartViewController.h"
#import "MBCartItemButton.h"
#import "UIImageView+WebCache.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
#import "MBPaymentViewController.h"
#import "MBFireOrderViewController.h"
#import "MBShoppingCartViewController.h"
#import "MobClick.h"
#import "MBSpecificationsCell.h"
@interface MBJoinCartViewController ()<UITableViewDataSource,UITableViewDelegate,MBSpecificationsCelldelegate>
{

  
    
    UIView *_lastview;
 
    NSDictionary *_goods_attr_list;
    NSDictionary *_goods_color_list;
    NSDictionary *_specificationsDic ;
    NSArray *_specificationsArray;
    NSMutableArray *_specificationsMutableArray;
    NSString *_goods_number;
}
@property (weak,nonatomic) UIView *goodsView;
@property (weak,nonatomic) UITextField *numberFld;
@property (strong,nonatomic)UILabel *priceLbl;
@property (strong,nonatomic)UILabel *stockLbl;
@property(strong,nonatomic)NSDictionary *orderInfo;

@end

@implementation MBJoinCartViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self specificationsData];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setupGoodsView{
    UIView *goodsView = [[UIView alloc] init];
    goodsView.frame = CGRectMake(0, TOP_Y + 10, self.view.ml_width, 96);
    [self.view addSubview:_goodsView = goodsView];
    
    UIImageView *goodsImgView = [[UIImageView alloc] init];
    NSString *url =_specificationsDic[@"goods_thumb"];
    [goodsImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        goodsImgView.alpha = 0.3f;
        [UIView animateWithDuration:1
                         animations:^{
                             goodsImgView.alpha = 1.0f;
                         }
                         completion:nil];
    }];

    goodsImgView.frame = CGRectMake(8, 0, 87, 87);
    [goodsView addSubview:goodsImgView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = _specificationsDic[@"goods_name"];
    titleLbl.font = [UIFont systemFontOfSize:13];
    titleLbl.numberOfLines = 2;
    titleLbl.textColor = [UIColor colorWithHexString:@"323333"];
    [goodsView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.equalTo(goodsImgView.mas_right).offset(20);
        make.right.mas_equalTo(-10);
    }];
    UILabel *descLbl = [[UILabel alloc] init];
    descLbl.text = self.goods_name;
    descLbl.font = [UIFont systemFontOfSize:12];
    descLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    descLbl.frame = CGRectMake(titleLbl.ml_x, CGRectGetMaxY(titleLbl.frame), titleLbl.ml_width, 15);
    [goodsView addSubview:descLbl];
    
    UILabel *totalLbl = [[UILabel alloc] init];
    totalLbl.text = @"总价:";
    totalLbl.font = [UIFont systemFontOfSize:12];
    totalLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    totalLbl.frame = CGRectMake(self.view.ml_width - 120 - 8, goodsView.ml_height - 20, 30, 16);
    [goodsView addSubview:totalLbl];
    
    _priceLbl = [[UILabel alloc] init];
    _priceLbl.text = _specificationsDic[@"shop_price_formatted"];
    _priceLbl.font = [UIFont systemFontOfSize:15];
    _priceLbl.textColor = [UIColor colorWithHexString:@"e8465e"];
    _priceLbl.frame = CGRectMake(CGRectGetMaxX(totalLbl.frame), totalLbl.ml_y, 100, 15);
    [goodsView addSubview:_priceLbl];
    
    [self addBottomLineView:goodsView];
}
#pragma mark -- 请求规格数据
-(void)specificationsData{
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/goods/getgoodsspecs"] parameters:@{@"goods_id":self.goods_id} success:^(NSURLSessionDataTask *operation, id responseObject) {
         [self dismiss];
        MMLog(@"%@",[responseObject valueForKey:@"data"]);
        _specificationsDic  = [responseObject valueForKey:@"data"];
        if (_specificationsDic) {
            [self setupGoodsView];
            _lastview = _goodsView;
            _specificationsArray = _specificationsDic[@"goods_specs"];
            
           
            
            if (_specificationsArray.count>0) {
                UITableView *tableview = [[UITableView alloc] init];
                tableview.delegate = self;
                tableview.dataSource = self;
                tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
                tableview.scrollEnabled = NO;
                [self.view addSubview:tableview];
                
                NSInteger lenth = 0;
                _specificationsMutableArray = [NSMutableArray array];
                for (NSDictionary *dic in _specificationsArray) {
                    NSArray *arr = dic[@"goods_attr_list"];
                    NSInteger num = arr.count%5;
                    [_specificationsMutableArray addObject:@"1"];
                    if (arr.count>0) {
                        if (num==0) {
                            lenth+= arr.count/5*40+40;
                        }else{
                            lenth+= (arr.count/5+1)*40+40;
                        }
                    }else{
                        lenth = 0;
                    }
                
                    
                }
                NSString *str = [NSString stringWithFormat:@"%ld",lenth];
                
                
                
                   __weak typeof(str)sslenth = str;
                 [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
                     
             
                     make.left.mas_equalTo(0);
                     make.right.mas_equalTo(0);
                     make.top.equalTo(_goodsView.mas_bottom).offset(0);
                     make.height.mas_equalTo([sslenth integerValue]);
                 }];
                
                
                
                _lastview = tableview;
            }
            
            _goods_number = _specificationsDic[@"goods_number"];
            [self setupNumberView];
            
            [self setupSubmitView];
        
        
        }
       
        
       
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];



}
- (void)clickItem:(MBCartItemButton *)btn{
    [[btn.superview subviews] enumerateObjectsUsingBlock:^(MBCartItemButton *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MBCartItemButton class]]){
            obj.clickStatus = NO;
        }
    }];
    
    btn.clickStatus = YES;
}

- (void)setupNumberView{
    NSInteger column = 5;
    CGFloat width = (self.view.ml_width / (column + 1));
    CGFloat margin = width / (column + 1);
    
    UIView *numberView = [[UIView alloc] init];
    [self.view addSubview:numberView];
 
    

    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lastview.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    
    }];
    
    
    
    UILabel *sepceLbl = [[UILabel alloc] init];
    sepceLbl.font = [UIFont systemFontOfSize:15];
    sepceLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    sepceLbl.text = @"数量";
    sepceLbl.frame = CGRectMake(margin, MARGIN_8, self.view.ml_width - 2 * margin, 20);
    [numberView addSubview:sepceLbl];
    
    UIButton *minuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minuBtn setImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateNormal];
    minuBtn.frame = CGRectMake(margin, CGRectGetMaxY(sepceLbl.frame) + margin, 20, 20);
    [numberView addSubview:minuBtn];
    [minuBtn addTarget:self action:@selector(minusClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *numberFld = [[UITextField alloc] init];
    numberFld.frame = CGRectMake(CGRectGetMaxX(minuBtn.frame) + 4, minuBtn.ml_y, 45, 20);
    numberFld.font = [UIFont systemFontOfSize:12];
    numberFld.text = @"1";
    numberFld.textAlignment = NSTextAlignmentCenter;
    numberFld.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    numberFld.layer.borderWidth = 1;
    numberFld.layer.cornerRadius = 2.0;
    [numberView addSubview:_numberFld = numberFld];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"cart_add"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(CGRectGetMaxX(numberFld.frame) + 4, minuBtn.ml_y, 20, 20);
    [numberView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *stockLbl = [[UILabel alloc] init];
    stockLbl.font = [UIFont systemFontOfSize:15];
    stockLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    
    stockLbl.text = [NSString stringWithFormat:@"库存量：%@件",_specificationsDic[@"goods_number"]];
    stockLbl.frame = CGRectMake(CGRectGetMaxX(addBtn.frame) + MARGIN_10, addBtn.ml_y, self.view.ml_width - 2 * margin, addBtn.ml_height);
    [numberView addSubview:_stockLbl = stockLbl];
}

- (void)minusClick{
    if ([self.numberFld.text integerValue] - 1 == 0) {
        [self show:@"商品件数不能为0" time:1];
    }else{
        self.numberFld.text = [NSString stringWithFormat:@"%ld",[self.numberFld.text integerValue] - 1];
        _priceLbl.text = [NSString stringWithFormat:@"¥%d.00",[self.shop_price intValue] * [self.numberFld.text intValue]];
    }
}

- (void)addClick{
    if ([self.numberFld.text integerValue] < [_goods_number integerValue]) {
        self.numberFld.text = [NSString stringWithFormat:@"%ld",[self.numberFld.text integerValue] + 1];
        _priceLbl.text = [NSString stringWithFormat:@"¥%d.00",[self.shop_price intValue] * [self.numberFld.text intValue]];
    }else{
        [self show:@"库存不足" time:1];
    }
}


- (void)setupSubmitView{
    
    UIView *submitView = [[UIView alloc] init];
    submitView.frame = CGRectMake(0, self.view.ml_height - 40, self.view.ml_width, 40);
    [self.view addSubview:submitView];
    if (self.isSelectGuige) {
        //立即购买按钮
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
        submitBtn.backgroundColor = [UIColor orangeColor];
        submitBtn.frame = CGRectMake(8, (submitView.ml_height - 30) * 0.5, (submitView.ml_width - 16)/2, 30);
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [submitBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        submitBtn.layer.cornerRadius = 3.0;
        [submitView addSubview:submitBtn];

        [submitBtn addTarget:self action:@selector(BeforeCreateOrder) forControlEvents:UIControlEventTouchUpInside];

        
        //加入购物车按钮
        UIButton *submitBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn1.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
        submitBtn1.backgroundColor = [UIColor redColor];
        submitBtn1.frame = CGRectMake(CGRectGetMaxX(submitBtn.frame)+5, (submitView.ml_height - 30) * 0.5, (submitView.ml_width - 16)/2, 30);
        submitBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [submitBtn1 addTarget:self action:@selector(ensureJoinTocart) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn1 setTitle:@"加入购物车" forState:UIControlStateNormal];


        submitBtn1.layer.cornerRadius = 3.0;
        [submitView addSubview:submitBtn1];
        
        UIView *submitTopLineView = [[UIView alloc] init];
        submitTopLineView.frame = CGRectMake(0, 0, self.view.ml_width, PX_ONE);
        submitTopLineView.backgroundColor = [UIColor colorWithHexString:@"3d3a3a"];
        [submitView addSubview:submitTopLineView];

    }else{
        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
        submitBtn.frame = CGRectMake(8, (submitView.ml_height - 30) * 0.5, submitView.ml_width - 16, 30);
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        if (self.isBuy) {
            [submitBtn setTitle:@"确认购买" forState:UIControlStateNormal];
            submitBtn.backgroundColor = [UIColor colorWithHexString:@"eeb94f"];
        }else{
            [submitBtn setTitle:@"确认添加" forState:UIControlStateNormal];
        }
        [submitBtn addTarget:self action:@selector(ensureTobuy) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.layer.cornerRadius = 3.0;
        [submitView addSubview:submitBtn];
        
        UIView *submitTopLineView = [[UIView alloc] init];
        submitTopLineView.frame = CGRectMake(0, 0, self.view.ml_width, PX_ONE);
        submitTopLineView.backgroundColor = [UIColor colorWithHexString:@"3d3a3a"];
        [submitView addSubview:submitTopLineView];
    }
    
}
-(void)ensureTobuy
{
    if (self.isBuy) {
        //提交订单前的确认
        [self BeforeCreateOrder];
        
    }else{
        [self ensureJoinTocart];
        
        
    }
    
}
-(void)ensureJoinTocart
{

    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    
    if (sid == nil && uid == nil) {
       
        [self loginClicksss:@"shop"];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i= 0; i<_specificationsArray.count; i++) {
        id dic = _specificationsMutableArray[i];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [arr addObject:dic[@"tag"][@"goods_attr_id"]];
        }else{
            NSString *str =   _specificationsArray[i][@"attr_name"];
            NSString *sss = [NSString stringWithFormat:@"请选择%@",str];
            [self show:sss time:1];
            return;
        }
        
    }
    
    NSArray *arrs  = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSString *attr;
    for (int i =0; i<arrs.count; i++) {
        NSString *str = arrs[i];
        if (i==0) {
            attr = [NSString stringWithFormat:@"%@",str];
        }else{
            
            attr = [NSString stringWithFormat:@"%@,%@",attr,str];
        }
    }
    if (!attr) {
        attr = @"";
    }

     
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *goodnumber = self.numberFld.text;
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/addtocart"] parameters:@{@"session":dict, @"goods_id":self.goods_id,@"number":goodnumber,@"spec":attr} success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"status"][@"succeed"]];
        
        if ([status isEqualToString:@"1"]) {
            [self show:@"加入购物车成功!" time:1];
            [self popViewControllerAnimated:YES];
           
        }else{
            [self show:[responseObject valueForKeyPath:@"status"][@"error_desc"] time:1];
            [self popViewControllerAnimated:YES];
           
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
         [self show:@"请求失败！" time:1];
    }];

}
//确认购买
-(void)BeforeCreateOrder
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    if (sid == nil && uid == nil) {
        [self loginClicksss:@"shop"];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i= 0; i<_specificationsArray.count; i++) {
        id dic = _specificationsMutableArray[i];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [arr addObject:dic[@"tag"][@"goods_attr_id"]];
        }else{
          NSString *str =   _specificationsArray[i][@"attr_name"];
            NSString *sss = [NSString stringWithFormat:@"请选择%@",str];
            [self show:sss time:1];
            return;
        }

    }
    
    NSArray *arrs  = [arr sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *attr;
    
    for (int i =0; i<arrs.count; i++) {
        NSString *str = arrs[i];
        if (i==0) {
            attr = [NSString stringWithFormat:@"%@",str];
        }else{
            attr = [NSString stringWithFormat:@"%@,%@",attr,str];
        }
    }
   
    
    if (!attr) {
        attr = @"";
    }
    
    NSString *goodnumber = self.numberFld.text;
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/addtocart"] parameters:@{@"session":sessiondict, @"goods_id":self.goods_id,@"number":goodnumber,@"spec":attr} success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject valueForKeyPath:@"status"][@"succeed"]];
        
        MMLog(@"%@",[responseObject valueForKeyPath:@"status"]);
        
        if ([status isEqualToString:@"1"]) {
            MBShoppingCartViewController *payVc = [[MBShoppingCartViewController alloc] init];
            payVc.showBottomBar = @"yes";
            [self.navigationController pushViewController:payVc animated:YES];
        }else{
            
            [self show:[responseObject valueForKeyPath:@"status"][@"error_desc"] time:1];
        }

        
        
         
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败..." time:1];
    }];
    
    
    
}

- (NSString *)titleStr{
    if (self.title) {
        return self.title;
    }else{
        
        return @"商品规格";
    }
}

#pragma mark --UITableViewdelgete
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _specificationsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = _specificationsArray[indexPath.row][@"goods_attr_list"];
    NSInteger num = arr.count%5;
    
    if (num==0) {
        return arr.count/5*40+40;
    }
    return (arr.count/5+1)*40+40;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBSpecificationsCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"_specificationsDic"];
    if (!cell) {
      cell = [[[NSBundle mainBundle]loadNibNamed:@"MBSpecificationsCell" owner:self options:nil]firstObject];
    }
    cell.dic = _specificationsArray[indexPath.row];
    [cell setUI];
    cell.row = indexPath.row;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.delegate =self;
    return cell;
}
#pragma mark --MBSpecificationsCelldelegate
-(void)getDic:(NSDictionary *)dic{

    _specificationsMutableArray[[dic[@"row"] integerValue]]=dic;
    
    [self setData];

}
-(void)setData{
    

    NSMutableArray *arr = [NSMutableArray array];
    for (id dic in _specificationsMutableArray) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [arr addObject:dic[@"tag"][@"goods_attr_id"]];
        }
    }
    
   NSArray *arrs  = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSString *attr;
    for (int i =0; i<arrs.count; i++) {
        NSString *str = arrs[i];
        if (i==0) {
            attr = [NSString stringWithFormat:@"%@",str];
        }else{
        
            attr = [NSString stringWithFormat:@"%@,%@",attr,str];
        }
    }
    
    
    
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/goods/getgoodsspecinfos"] parameters:@{@"goods_id":self.goods_id,@"attr":attr,@"number":_numberFld.text} success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
//        MMLog(@"%@",[responseObject valueForKey:@"data"]);
        NSDictionary *dic = [responseObject valueForKey:@"data"];
        if (dic) {
            
            _priceLbl.text = dic[@"result"];
            _numberFld.text =[NSString stringWithFormat:@"%@", dic[@"qty"]];
            
            if (dic[@"num"]) {
                _stockLbl.text = [NSString stringWithFormat:@"库存量：%@件",dic[@"num"]];
                _goods_number = dic[@"num"];
            }
           
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
    
}

@end
