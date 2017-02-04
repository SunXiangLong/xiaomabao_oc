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
#import "MBShoppingCartTableViewCell.h"
#import "MBShopingViewController.h"
#import "MBRealNameAuthViewController.h"
#import "MBShoppingCartViewController.h"
#import "MBShoppingCartModel.h"
@interface MBShoppingCartViewController () <UITableViewDataSource,UITableViewDelegate,MBShoppingCartTableViewdelegate>
{
    UIButton *allSelectBtn;
    NSString *_is_cross_border;
    NSString *dele;
    UIButton *_submitButton;
    
}
@property (strong,nonatomic)  UIView *maskView;
@property (strong,nonatomic) UILabel *totalLbl;
@property (strong,nonatomic)UITableView *mytableView;
@property (strong,nonatomic)NSMutableArray *goodnumberArray;
@property (strong,nonatomic)NSMutableArray *goodSelectArray;
@property (strong,nonatomic) MBShoppingCartModel *model;
@end

@implementation MBShoppingCartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    
    if (userInfo.uid) {
        
       [self getCartInfo:0 type:nil isShow:true];
        
    }else{
        
        
        [self maskView];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
    
    
}
/**
 *  初始化界面元素
 */
- (void)setupUI{
    if (_mytableView) {
        return;
    }
    _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT - TOP_Y - 35) style:UITableViewStylePlain];
    
    [_mytableView registerNib:[UINib nibWithNibName:@"MBShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBShoppingCartTableViewCell"];
    _mytableView.dataSource = self,
    _mytableView.delegate = self;
    _mytableView.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    
    
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

/**
 *  更新购物车数据
 *
 *  @param rec_id      唯一标示
 *  @param new_number  数量
 *  @param flow_number 是否选中
 */
- (void)updateCart:(NSString *)rec_id new_number:(NSString *)new_number flow_number:(NSString *)flow_number row:(NSInteger)row{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/update_cart"] parameters:@{@"session":dict,@"rec_id":rec_id,@"new_number":new_number,@"flow_order":flow_number} success:^(NSURLSessionDataTask *operation, id responseObject) {
       
        //        MMLog(@"更新购物车成功---responseObject%@",[responseObject valueForKeyPath:@"status"]);
        NSDictionary * dict = [responseObject valueForKeyPath:@"status"];
        if([[dict valueForKeyPath:@"succeed"] isEqualToNumber:@1]){
            
            
            [self getCartInfo: row type:@"reload" isShow:false];
            
        }else{
            [self dismiss];
            [self  show:dict[@"error_desc"] time:1];
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:1];
        MMLog(@"%@",error);
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
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/cart/select_all_or_zero") parameters:@{@"session":dict} success:^(id responseObject) {
        
         MMLog(@"更新购物车成功---responseObject%@",responseObject);
        if ([responseObject[@"status"][@"succeed"] integerValue] == 1) {
            [self getCartInfo:0 type:nil isShow:false];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error.localizedDescription);
        [self show:@"请求失败！" time:1];
    }];
    
    
}

#pragma mark -- 获取购物车数据
-(void)getCartInfo:(NSInteger )row type:(NSString *)type isShow:(BOOL)isShow
{
    
    if (isShow) {
        [self show];
    }
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/flow/cart") parameters:@{@"session":dict} success:^(id responseObject) {
        [self dismiss];
        if (![responseObject[@"status"] isKindOfClass:[NSDictionary class]]) {
            [self show:@"登录超时，请重新登录"];
            return ;
        }else{
            _model = [MBShoppingCartModel yy_modelWithJSON:responseObject[@"data"]];
            if (_model.goods_list.count > 0) {
                if (_model.isSettlement) {
                    if (_maskView) {
                        [_maskView removeFromSuperview];
                        _maskView = nil;
                    }
                    
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
                
                
            }else{
            
                [self maskView];
                
            }
            
            if ([type isEqualToString:@"reload"]) {
                
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
                
                [_mytableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                
                
            }else {
                
                
                [_mytableView reloadData];
            }
        
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
        MMLog(@"%@",error);
    }];

    
}
//全选按钮
-(void)allSelectBtn:(UIButton *)button
{
     [MobClick event:@"ShoppingCart1"];
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
    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/flow/checkout") parameters:@{@"session":sessiondict} success:^(id responseObject) {
        if ([responseObject[@"status"] isKindOfClass:[NSDictionary  class]]&&[responseObject[@"status"][@"succeed"]  integerValue] == 1) {
            MBFireOrderViewController *VC = [[MBFireOrderViewController alloc] init];
            VC.orderShopModel = [MBConfirmModel yy_modelWithDictionary:responseObject[@"data"]];
            [self dismiss];
            [self pushViewController:VC Animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败！" time:1];
    }];
    
    
}

- (void)goToDaySale{
    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    if (userInfo.uid == nil) {
         [self loginClicksss:@"shop"];
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
   
    if (num == 0) {//删除
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/del_cart"] parameters:@{@"session":session,@"rec_id":rec_id}
                   success:^(NSURLSessionDataTask *operation, id responseObject) {
                       
                       
                       [self getCartInfo:row type:@"dele" isShow:false];
                       
                   } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                       MMLog(@"失败");
                   }];
        
    }else {//收藏
        
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/collect/collect_goods"] parameters:@{@"session":session,@"goods_id":rec_id}
                   success:^(NSURLSessionDataTask *operation, id responseObject) {
                       [self dismiss];
                       if ([[responseObject valueForKeyPath:@"status"][@"succeed"]isEqualToNumber:@1]) {
                           [self show:@"收藏成功" time:1];
                           
                       }else{
                           
                           [self show:[responseObject valueForKeyPath:@"status"][@"error_desc"] time:1];
                           
                       }
                       
                       NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
                       [_mytableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                   } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                       MMLog(@"%@",error);
                       [self show:@"请求失败！" time:1];
                   }];
    }
    
    
    
    
    
}




#pragma mark --UITableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_model.goods_list.count > 0) {
         return _model.goods_list.count;
    }
    return 0;
}
- (void)configureCell:(MBShoppingCartTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
 [cell uiedgeInsetsZero];
    cell.delegate = self;
    cell.row = indexPath.row;
    cell.model = _model.goods_list[indexPath.row];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBShoppingCartTableViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"MBShoppingCartTableViewCell" cacheByIndexPath:indexPath configuration:^(MBShoppingCartTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [MobClick event:@"ShoppingCart2"];
    
}
#pragma mark -- 在滑动手势删除某一行的时候，显示出更多的按钮

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        [MobClick event:@"ShoppingCart5"];
        
        [self DelteCartAndSavecollectRequestData:_model.goods_list[indexPath.row].rec_id and:0 and:indexPath.row];
        
    }];
    
    
    //添加一个收藏按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"加入收藏"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        [MobClick event:@"ShoppingCart6"];
        
        [self DelteCartAndSavecollectRequestData:_model.goods_list[indexPath.row].goods_id and:1 and:indexPath.row];
        
    }];
    
    //将设置好的按钮放到数组中返回
    return@[deleteRowAction,moreRowAction];
    
}
#pragma mark -- MBShoppingCartTableViewdelegate
//选中和取消选中
-(void)click:(NSInteger )row{
    
    if ([_model.goods_list[row].flow_order integerValue] == 1) {
        [self updateCart:_model.goods_list[row].rec_id new_number:_model.goods_list[row].goods_number flow_number:@"0" row:(row)];
    }else{
        [self updateCart:_model.goods_list[row].rec_id new_number:_model.goods_list[row].goods_number flow_number:@"1" row:(row)];
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
    if ([dic[@"goods_number"] integerValue ] <= 0) {
        [self  show:@"商品件数最少为1" time:1];
        return;
    }
    //如果选中，则更新购物车
    NSString * selected =dic[@"selected"];
    if([selected isEqualToString:@"1"]){
        [self updateCart:dic[@"rec_id"] new_number:dic[@"goods_number"] flow_number:@"1" row:[dic[@"row"] integerValue]];
    }
}
@end
