//
//  MBShoppingCartViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/30.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBShoppingCartViewController.h"
#import "MBFireOrderViewController.h"
#import "MBSignaltonTool.h"
#import "MBNetworking.h"
#import "MBShoppingCartTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBShopingViewController.h"
#import <math.h>
#import "MBLoginViewController.h"
#import "MBRealNameAuthViewController.h"
@interface MBShoppingCartViewController () <UITableViewDataSource,UITableViewDelegate,MBShoppingCartTableViewdelegate>
{
    UIButton *allSelectBtn;
    NSString *_is_cross_border;
    NSString *dele;
    UIButton *_submitButton;
    
}
@property (weak,nonatomic) UIView *maskView;
@property (strong,nonatomic) UILabel *totalLbl;
@property (strong,nonatomic)UITableView *mytableView;
@property (strong,nonatomic)NSMutableArray *goodnumberArray;
@property (strong,nonatomic)NSMutableArray *goodSelectArray;
@property (assign,nonatomic)BOOL iSdelete;
@property (strong,nonatomic)NSMutableDictionary *isAllselectDict;
@property(strong,nonatomic)NSArray *CartinfoDict;
@property (assign,nonatomic)int selectCountNumber;
@end

@implementation MBShoppingCartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
    
    
    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    
    if (userInfo.uid != nil) {
       
        [self getcartIsAllSelect];
        
    }else{
        
        
        [self maskView];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    _selectCountNumber = 0;
    self.view.backgroundColor = BG_COLOR;

    self.CartinfoDict = [NSMutableArray array];
    self.total = [NSDictionary dictionary];
    
    if([self.showBottomBar isEqualToString:@"yes"]){
        
        [self setupUI2];
    }else{
        
        
        [self setupUI];
        
        
    }
    
    
}
- (UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.view.frame;
        maskView.ml_y = TOP_Y;
        maskView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_maskView = maskView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(100, 80, UISCREEN_WIDTH-200, (UISCREEN_WIDTH-200)*256/320);
        imageView.image = [UIImage imageNamed:@"mabaoCart"];
        [maskView addSubview:imageView];
        
        UILabel *maskLbl = [[UILabel alloc] init];
        maskLbl.text = @"您的购物车还是空的哦！去看看今天的特卖商品吧！";
        maskLbl.textAlignment = NSTextAlignmentCenter;
        maskLbl.numberOfLines = 0;
        maskLbl.font = [UIFont systemFontOfSize:16];
        maskLbl.textColor = [UIColor colorR:139 colorG:140 colorB:142];
        [maskView addSubview:maskLbl];
        [maskLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(30);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = NavBar_Color;
        [btn addTarget:self action:@selector(goToDaySale) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 3.0f;
        MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
        if (userInfo.uid == nil) {
            
            [btn setTitle:@"点击登录" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"今日特卖,去看看!" forState:UIControlStateNormal];
        }
        
        [maskView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(maskLbl.mas_bottom).offset(40);
            make.width .mas_equalTo(150);
            make.height.mas_equalTo(30);
            make.centerX.equalTo(maskView.mas_centerX);
        }];
        
        
    }else{
        
        [self.view addSubview:_maskView];
        
        
    }
    return _maskView;
}

#pragma -mark 是否全部选中
-(void)getcartIsAllSelect
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"cart/is_selected_all"] parameters:@{@"session":dict} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取是否全部选中成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
        
        
        NSDictionary *dict = [responseObject valueForKeyPath:@"data"];
        _isAllselectDict = [NSMutableDictionary dictionaryWithDictionary:dict];;
        if ([[_isAllselectDict valueForKey:@"is_selected_all"] integerValue ]==0) {
            _selectCountNumber = 0;
        }
        if (_isAllselectDict) {
            
            
            [self getCartInfo:0 type:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"失败");
    }];
    
}

//选中和取消选中
-(void)click:(NSInteger )row{
    
    NSInteger flow_order = [[[self.CartinfoDict objectAtIndex:row] valueForKeyPath:@"flow_order"] integerValue];
    
    
    if (flow_order == 1) {
        [self updateCart:self.CartinfoDict[row][@"rec_id"] new_number:self.CartinfoDict[row][@"goods_number"] flow_number:@"0" row:(row)];
    }else{
        [self updateCart:self.CartinfoDict[row][@"rec_id"] new_number:self.CartinfoDict[row][@"goods_number"] flow_number:@"1" row:(row)];
    }
    
    
    
}
//增加一个
- (void)addShop:(NSDictionary *)dic{
    //如果选中，则更新购物车
    NSString * selected =dic[@"selected"];
    if([selected isEqualToString:@"1"]){
        [self updateCart:dic[@"rec_id"] new_number:dic[@"goods_number"] flow_number:@"1" row:[dic[@"row"] integerValue]];
    }
    
}
//减少一个
- (void)reduceShop:(NSDictionary *)dic{
    
    
    //如果选中，则更新购物车
    NSString * selected =dic[@"selected"];
    if([selected isEqualToString:@"1"]){
        [self updateCart:dic[@"rec_id"] new_number:dic[@"goods_number"] flow_number:@"1" row:[dic[@"row"] integerValue]];
    }
}
/**
 *  更新购物车数据
 *
 *  @param rec_id      唯一标示
 *  @param new_number  数量
 *  @param flow_number 是否选中
 */
- (void)updateCart:(NSString *)rec_id new_number:(NSString *)new_number flow_number:(NSString *)flow_number row:(NSInteger)row{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/update_cart"] parameters:@{@"session":dict,@"rec_id":rec_id,@"new_number":new_number,@"flow_order":flow_number} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
//        NSLog(@"更新购物车成功---responseObject%@",[responseObject valueForKeyPath:@"status"]);
        NSDictionary * dict = [responseObject valueForKeyPath:@"status"];
        if([[dict valueForKeyPath:@"succeed"] isEqualToNumber:@1]){
            
            
            [self getCartInfo: row type:@"reload"];
            
        }else{
            
            [self  show:dict[@"error_desc"] time:1];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"失败");
    }];
    
}

/**
 *  全选或全不选
 */
- (void)selectAllOrZero{
    
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"cart/select_all_or_zero"] parameters:@{@"session":dict}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
        
//        NSLog(@"更新购物车成功---responseObject%@",[responseObject valueForKeyPath:@"status"]);
        NSDictionary * dict = [responseObject valueForKeyPath:@"status"];
        if([[dict valueForKeyPath:@"succeed"] isEqualToNumber:@1]){
            [self getCartInfo:0 type:nil];
            
        }
    }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"%@",error);
                   [self show:@"请求失败！" time:1];
               }
     ];
    
}

#pragma mark -- 获取购物车数据
-(void)getCartInfo:(NSInteger )row type:(NSString *)type
{
    
//    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/cart"] parameters:@{@"session":dict} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self dismiss];
        NSLog(@"%@",[responseObject valueForKeyPath:@"data"]);
        
        
        self.CartinfoDict = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_list"];
        self.total = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"total"];
        _goodnumberArray = [NSMutableArray array];
        _goodSelectArray = [NSMutableArray array];
        int i = 0;
        int selectAll = 0;
        for (NSDictionary *dict in self.CartinfoDict) {
            NSString *goodNumber = [dict valueForKeyPath:@"goods_number"];
            [_goodnumberArray addObject:goodNumber];
            NSMutableDictionary *mydict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i++],@"celltag", nil];
            [_goodSelectArray addObject:mydict];
            
            //判断是否选中
            NSInteger flow_order = [[dict valueForKeyPath:@"flow_order"] integerValue];
            selectAll += flow_order;
            
        }
        
        //选中状态判断
        if (self.CartinfoDict.count>0) {
            
            if (selectAll > 0) {
                [_maskView removeFromSuperview];
                _maskView = nil;
                [allSelectBtn setImage:[UIImage imageNamed:@"icon_true"] forState:UIControlStateNormal];
                allSelectBtn.selected = YES;
                //结算可用
                _submitButton.backgroundColor = [UIColor colorWithHexString:@"e8455d"];
                [_submitButton setEnabled:YES];
            }else{
                [allSelectBtn setImage:[UIImage imageNamed:@"pitch_no"] forState:UIControlStateNormal];
                allSelectBtn.selected = NO;
                
                //结算变灰，且不可用
                _submitButton.backgroundColor = [UIColor grayColor];
                [_submitButton setEnabled:NO];
            }
            NSString *account = [self.total valueForKeyPath:@"goods_price"];
            _totalLbl.text = [NSString stringWithFormat:@"总价:%@",account];
            
        }else
        {
            
            [self maskView];
        }
        
        
        
     
        
        if ([type isEqualToString:@"reload"]) {
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
           
            [_mytableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        }else {
            
            
            
            
            [_mytableView reloadData];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self show:@"请求失败！" time:1];
        NSLog(@"%@",error);
        
        
    }];
    
}

/**
 *  初始化界面元素
 */
- (void)setupUI{
    
    
    if (_mytableView) {
        return;
    }
    _mytableView = [[UITableView alloc] init];
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableView registerNib:[UINib nibWithNibName:@"MBShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBShoppingCartTableViewCell"];
    _mytableView.dataSource = self,
    _mytableView.delegate = self;
    _mytableView.backgroundColor = [UIColor colorR:249 colorG:249 colorB:249];
    _mytableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - self.tabBarController.tabBar.ml_height - TOP_Y - 35);
    [self.view addSubview:_mytableView];
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    tableViewFooterView.frame = CGRectMake(0, 0, self.view.ml_width, 28);
    _mytableView.tableFooterView = tableViewFooterView;
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    bottomLineView.frame = CGRectMake(0, self.view.ml_height - self.tabBarController.tabBar.ml_height - 1, self.view.ml_width, 1);
    [self.view addSubview:bottomLineView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor lightTextColor];
    bottomView.layer.borderColor = [[UIColor redColor] CGColor];
    CGFloat tabbarHeight = 35;
    bottomView.frame = CGRectMake(0, self.view.ml_height - tabbarHeight - self.tabBarController.tabBar.ml_height - 1, self.view.ml_width, tabbarHeight);
    [self.view addSubview:bottomView];
    
    [bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectBtn.frame = CGRectMake(0, 4, 72, tableViewFooterView.ml_height);
    allSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN_20, 0, 0);
    
    [allSelectBtn setTitleColor:[UIColor colorWithHexString:@"323232"] forState:UIControlStateNormal];
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn addTarget:self action:@selector(allSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:allSelectBtn];
    
    CGFloat submitButtonWidth = 90;
    
    if(_totalLbl){
        [_totalLbl removeFromSuperview];
    }
    _totalLbl = [[UILabel alloc] init];
    _totalLbl.font = [UIFont systemFontOfSize:14];
    _totalLbl.frame = CGRectMake(CGRectGetMaxX(allSelectBtn.frame) +5, 0, self.view.ml_width - submitButtonWidth, bottomView.ml_height);
    
    [bottomView addSubview:_totalLbl];
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(self.view.ml_width - submitButtonWidth, 0, submitButtonWidth, bottomView.ml_height);
    [submitButton setTitle:@"结算" forState:UIControlStateNormal];
    [bottomView addSubview:_submitButton = submitButton];
    [submitButton addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  初始化界面元素
 */
- (void)setupUI2{
    if (_mytableView) {
        return;
    }
    _mytableView = [[UITableView alloc] init];
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mytableView registerNib:[UINib nibWithNibName:@"MBShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBShoppingCartTableViewCell"];
    _mytableView.dataSource = self,
    _mytableView.delegate = self;
    _mytableView.backgroundColor = [UIColor colorR:249 colorG:249 colorB:249];
    _mytableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - 35);
    
    [self.view addSubview:_mytableView];
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    tableViewFooterView.frame = CGRectMake(0, 0, self.view.ml_width, 28);
    _mytableView.tableFooterView = tableViewFooterView;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor lightTextColor];
    bottomView.layer.borderColor = [[UIColor redColor] CGColor];
    CGFloat tabbarHeight = 35;
    bottomView.frame = CGRectMake(0, self.view.ml_height - tabbarHeight, self.view.ml_width, tabbarHeight);
    [self.view addSubview:bottomView];
    
    [bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectBtn.frame = CGRectMake(0, 4, 72, tableViewFooterView.ml_height);
    allSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN_20, 0, 0);
    
    [allSelectBtn setTitleColor:[UIColor colorWithHexString:@"323232"] forState:UIControlStateNormal];
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn addTarget:self action:@selector(allSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:allSelectBtn];
    
    CGFloat submitButtonWidth = 90;
    
    if(_totalLbl){
        [_totalLbl removeFromSuperview];
    }
    _totalLbl = [[UILabel alloc] init];
    _totalLbl.font = [UIFont systemFontOfSize:14];
    _totalLbl.frame = CGRectMake(CGRectGetMaxX(allSelectBtn.frame) +5, 0, self.view.ml_width - submitButtonWidth, bottomView.ml_height);
    [bottomView addSubview:_totalLbl];
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(self.view.ml_width - submitButtonWidth, 0, submitButtonWidth, bottomView.ml_height);
    [submitButton setTitle:@"结算" forState:UIControlStateNormal];
    [bottomView addSubview:_submitButton = submitButton];
    
    
    [submitButton addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
}

//全选按钮
-(void)allSelectBtn:(UIButton *)button
{
    [self selectAllOrZero];
}
#pragma mark -- 提交订单前的确认
- (void)clickSubmit{
    
    [self BeforeCreateOrder];
    
}

//根据产品sid(session_id)、uid生成订单前的订单确认接口
-(void)BeforeCreateOrder
{
    [self show];
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/checkout"] parameters:@{@"session":sessiondict}success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"成功---生成订单前的订单确认接口%@",[responseObject valueForKeyPath:@"data"]);

        NSMutableArray * infoDict = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_list"];
        
        
        
        self.total = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"total"];
        MBFireOrderViewController *fireOrderVc = [[MBFireOrderViewController alloc] init];
        fireOrderVc.CartinfoDict = infoDict;
        fireOrderVc.cartinfoArray = self.CartinfoDict;
        fireOrderVc.order_amount = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"order_amount"];
        fireOrderVc.order_amount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"order_amount_formatted"];
        fireOrderVc.cross_border_tax = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"cross_border_tax"];
        fireOrderVc.shipping_fee_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"shipping_fee_formatted"];
        fireOrderVc.goods_amount = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_amount"];
        fireOrderVc.goods_amount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"goods_amount_formatted"];
        fireOrderVc.discount_formatted = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"discount_formatted"];
        
        fireOrderVc.goodnumber = self.goodnumberArray;
        fireOrderVc.goodselectArray = self.goodSelectArray;
        fireOrderVc.consignee = [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"consignee"] ;
        
        NSString *str  = [NSString stringWithFormat:@"%@",[[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"real_name"]];
        NSString *str1 = [NSString stringWithFormat:@"%@",[[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"is_over_see"]];
        
        fireOrderVc.is_cross_border = str;
        fireOrderVc.is_over_see = str1;
        fireOrderVc.CartDict =  [[responseObject valueForKeyPath:@"data"] valueForKeyPath:@"s_goods_list"];
        [self dismiss];
        
        
        [self pushViewController:fireOrderVc Animated:YES];
    }
     
     
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   [self show:@"请求失败！" time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
}

- (void)goToDaySale{
    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    if (userInfo.uid == nil) {
        //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //由storyboard根据myView的storyBoardID来获取我们要切换的视图
        MBLoginViewController *myViewVc = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
        //由navigationController推向我们要推向的view
        myViewVc.vcType = @"shop";
        [self.navigationController pushViewController:myViewVc animated:YES];
        return;
    }else{
        UIViewController *mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        [UIApplication sharedApplication].keyWindow.rootViewController = mainVc;
    }
    
}
- (NSString *)titleStr{
    return @"购物车";
}
#pragma mark --  收藏和删除购物车商品
- (void)DelteCartAndSavecollectRequestData:(NSString *)rec_id  and:(NSInteger)num and:(NSInteger)row{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self dismiss];
    if (num == 0) {//删除
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/del_cart"] parameters:@{@"session":session,@"rec_id":rec_id}
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                       NSLog(@"删除成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                       
                       [self getCartInfo:row type:@"dele"];
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       NSLog(@"失败");
                   }];
        
    }else {//收藏
        
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/collect/collect_goods"] parameters:@{@"session":session,@"goods_id":rec_id}
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                       if ([[responseObject valueForKeyPath:@"status"][@"succeed"]isEqualToString:@"1"]) {
                           [self show:@"收藏成功" time:1];
                           
                       }else{
                       
                          [self show:[responseObject valueForKeyPath:@"status"][@"error_desc"] time:1];
                       
                       }
                    
                       NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
                       [_mytableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       NSLog(@"%@",error);
                       [self show:@"请求失败！" time:1];
                   }];
    }
    
    
    
    
    
}




#pragma mark --UITableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.CartinfoDict.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MBShoppingCartTableViewCell";
    
    MBShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (self.CartinfoDict.count>0) {
        
        cell.Goods_price.text = [[self.CartinfoDict objectAtIndex:indexPath.row]  valueForKeyPath:@"subtotal"];
        cell.Market_Price.text = [[self.CartinfoDict objectAtIndex:indexPath.row]  valueForKeyPath:@"market_price"];
        cell.goods_number.text = [[self.CartinfoDict objectAtIndex:indexPath.row]  valueForKeyPath:@"goods_number"];
        NSString * nameStr = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_name"];
        cell.row = indexPath.row;
        cell.delegate =self;
//        NSInteger minLen = MIN(28, [nameStr length]);

        cell.GoodsDescribe.text = [NSString stringWithFormat:@"%@",nameStr];
        
        
        cell.goodID = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_id"];
        cell.rec_id = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"rec_id"];
        NSString *urlstr = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_img"];
        
        NSInteger flow_order = [[[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"flow_order"] integerValue];
        
        
        NSString *str = [[self.CartinfoDict objectAtIndex:indexPath.row]valueForKeyPath:@"is_cross_border"];
        if (![str isEqualToString:@"0"]) {
            _is_cross_border = str;
        }else{
            _is_cross_border = @"0";
        }
        if (flow_order == 1) {
            cell.isSelect = @"1";
            cell.selectImageview.image = [UIImage imageNamed:@"icon_true"];
            cell.selectbutton.selected = YES;
        }else{
            cell.isSelect = @"0";
            cell.selectImageview.image = [UIImage imageNamed:@"pitch_no"];
            cell.selectbutton.selected = NO;
            
        }
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *dic = self.CartinfoDict[indexPath.row];
        if ([dic[@"is_third"] isEqualToString:@"1"]) {
            [array addObject:[UIImage imageNamed:@"thrid_goods_icon.ipg"]];
        }
        if ([dic[@"coupon_disable"]isEqualToString:@"1"]) {
            [array addObject:[UIImage imageNamed:@"coupon_disable.jpg"]];
        }
        if ([dic[@"is_cross_border"]isEqualToString:@"1"]) {
            [array addObject:[UIImage imageNamed:@"icon_cross_g.jpg"]];

        }
        if ([dic[@"is_group"]isEqualToString:@"1"]) {
            [array addObject:[UIImage imageNamed:@"icon_group_g.jpg"]];
            
        }
       
        cell.imageArray = array;
        
        NSURL *url = [NSURL URLWithString:urlstr];
        [cell.Carimageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.Carimageview.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.Carimageview.alpha = 1.0f;
                             }
                             completion:nil];
        }];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row+100;
    cell.viewController =self;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


  
}
#pragma mark -- 在滑动手势删除某一行的时候，显示出更多的按钮

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        
        NSString *rec_id = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"rec_id"];
        
        [self DelteCartAndSavecollectRequestData:rec_id and:0 and:indexPath.row];
        
        
    }];
    
    
    //添加一个收藏按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"加入收藏"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        
        NSString *goods_id = [[self.CartinfoDict objectAtIndex:indexPath.row] valueForKeyPath:@"goods_id"];
        [self DelteCartAndSavecollectRequestData:goods_id and:1 and:indexPath.row];
        
        
        
    }];
    
    //将设置好的按钮放到数组中返回
    return@[deleteRowAction,moreRowAction];
    
}




@end
