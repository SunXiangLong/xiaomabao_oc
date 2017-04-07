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
#import "MBGoodsDetailsViewController.h"
#import "MBRealNameAuthViewController.h"
#import "MBShoppingCartViewController.h"
#import "MBShoppingCartModel.h"
#import "MBShoppingCartCell.h"
@interface MBShoppingCartViewController () <UITableViewDataSource,UITableViewDelegate,MBShoppingCartTableViewdelegate>
{
    
    UIButton *allSelectBtn;
    NSString *_is_cross_border;
    NSString *dele;
    UIButton *_submitButton;
    BOOL _isRefresh;
    UIView *_bottomView;
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
    if (_isRefresh) {
        if ([MBSignaltonTool getCurrentUserInfo].uid) {
            [self getCartInfoShow:true];
        }else{
            [self maskView];
        }
    }
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
    if ([MBSignaltonTool getCurrentUserInfo].uid) {
        [self getCartInfoShow:true];
    }else{
        [self maskView];
    }
}
/**  初始化界面元素*/
- (void)setupUI{
    
    _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT - TOP_Y - 35) style:UITableViewStylePlain];
    _mytableView.dataSource = self,
    _mytableView.delegate = self;
    _mytableView.tableFooterView = [[UIView alloc] init];
    _mytableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mytableView];
    
    UIView *tableViewFooterView = [[UIView alloc] init];
    tableViewFooterView.frame = CGRectMake(0, 0, self.view.ml_width, 28);
    _mytableView.tableFooterView = tableViewFooterView;
    
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addTopLineView:bottomView];
    bottomView.hidden = true;
    bottomView.frame = CGRectMake(0, UISCREEN_HEIGHT - 45, UISCREEN_WIDTH, 45);
    [self.view addSubview:_bottomView = bottomView];
    
    allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectBtn.titleLabel.font  = SYSTEMFONT(12);
    [allSelectBtn setImage:[UIImage imageNamed:@"syncart_round_check"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"syncart_round_check1"] forState:UIControlStateSelected];
    [allSelectBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn addTarget:self action:@selector(allSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:allSelectBtn];
    [allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(65);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    allSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _totalLbl = [[UILabel alloc] init];
    
    _totalLbl = [[UILabel alloc] init];
    _totalLbl.font = YC_YAHEI_FONT(16);
    [bottomView addSubview:_totalLbl];
    [_totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(allSelectBtn.mas_right).offset(9);
    }];
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.backgroundColor = [UIColor grayColor];
    submitButton.titleLabel.font = SYSTEMFONT(17);
    [bottomView addSubview:_submitButton = submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
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
- (void)updateCart:(MBGood_ListModel *)model goods_number:(NSString *)goods_number flow_order:(NSString *)flow_order row:(NSInteger)row isnum:(BOOL )isNum{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/update_cart"] parameters:@{@"session":dict,@"rec_id":model.rec_id,@"new_number":goods_number,@"flow_order":flow_order} success:^(NSURLSessionDataTask *operation, id responseObject) {
        
//        MMLog(@"更新购物车成功%@",[responseObject valueForKeyPath:@"status"]);
        
        NSDictionary * dict = [responseObject valueForKeyPath:@"status"];
        if([[dict valueForKeyPath:@"succeed"] isEqualToNumber:@1]){
            

            [self getCartInfoShow:false];
            
        }else{
            [self dismiss];
            [self  show:dict[@"error_desc"] time:1];
            
        }
        
         [_mytableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
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
            [self getCartInfoShow:false];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error.localizedDescription);
        [self show:@"请求失败！" time:1];
    }];
    
    
}

#pragma mark -- 获取购物车数据
-(void)getCartInfoShow:(BOOL)isShow
{
    
    if (isShow) {
        [self show];
    }
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/flow/cart") parameters:@{@"session":dict} success:^(id responseObject) {
        [self dismiss];
        if (![self checkData:responseObject]) {
            
            return ;
        }
        
        _model = [MBShoppingCartModel yy_modelWithDictionary:responseObject[@"data"]];
        _totalLbl.text = string(@"合计：", _model.total.goods_price);
        [_submitButton setTitle:string(@"去结算(",string(_model.total.real_goods_count, @")")) forState:UIControlStateNormal];
        _bottomView.hidden = false;
        if (_model.goods_list.count > 0) {
            if (_model.isSettlement) {
                if (_maskView) {
                    [_maskView removeFromSuperview];
                    _maskView = nil;
                }
                
                
                allSelectBtn.selected = YES;
                //结算可用
                _submitButton.backgroundColor = [UIColor colorWithHexString:@"e8455d"];
                [_submitButton setEnabled:YES];
            }else{
                allSelectBtn.selected = NO;
                //结算变灰，且不可用
                _submitButton.backgroundColor = [UIColor grayColor];
                [_submitButton setEnabled:NO];
            }
            
            
        }else{
            
            [self maskView];
            
        }
        
        [_mytableView reloadData];
        
        
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
            //            MMLog(@"%@",responseObject);
            VC.orderShopModel = [MBConfirmModel yy_modelWithDictionary:responseObject[@"data"]];
            [self dismiss];
            VC.isRefresh = ^(){
                _isRefresh  = true;
                
            };
            VC.navBar.back = true;
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
        self.tabBarController.selectedIndex = 2;
        [UIApplication sharedApplication].keyWindow.rootViewController =    self.tabBarController;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}
- (NSString *)titleStr{
    return @"购物车";
}
#pragma mark --  收藏和删除购物车商品
- (void)delteCartAndSavecollectRequestData:(NSString *)rec_id  and:(NSInteger)num and:(NSInteger)row{
    [self show];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    if (num == 0) {//删除
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/del_cart"] parameters:@{@"session":session,@"rec_id":rec_id}
                   success:^(NSURLSessionDataTask *operation, id responseObject) {
                       [self getCartInfoShow:false];
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
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idstr = @"MBShoppingCartCell";
    // 创建cell
    MBShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:idstr];
    if (!cell) {
        cell = [[MBShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idstr model:_model.goods_list[indexPath.row]];
    }else{
        cell.goodsModel = _model.goods_list[indexPath.row];
    }
    cell.delegate = self;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 96+18;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [MobClick event:@"ShoppingCart2"];
    
    MBGoodsDetailsViewController *shopDetailVc = [[MBGoodsDetailsViewController alloc] init];
    shopDetailVc.GoodsId =  _model.goods_list[indexPath.row].goods_id;
    shopDetailVc.title = _model.goods_list[indexPath.row].goods_name;
    [self pushViewController:shopDetailVc Animated:YES];
    
}
#pragma mark -- 在滑动手势删除某一行的时候，显示出更多的按钮

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        [MobClick event:@"ShoppingCart5"];
        
        [self delteCartAndSavecollectRequestData:_model.goods_list[indexPath.row].rec_id and:0 and:indexPath.row];
        
    }];
    
    
    //添加一个收藏按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"加入收藏"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        [MobClick event:@"ShoppingCart6"];
        
        [self delteCartAndSavecollectRequestData:_model.goods_list[indexPath.row].goods_id and:1 and:indexPath.row];
        
    }];
    
    //将设置好的按钮放到数组中返回
    return@[deleteRowAction,moreRowAction];
    
}
#pragma mark -- MBShoppingCartTableViewdelegate
- (void)show:(NSString *)str{
    [self show:str time:.5];
}
//选中和取消选中
-(void)click:(MBGood_ListModel *)model{
    
    if ([model.flow_order integerValue] == 1) {
        [self updateCart:model goods_number:model.goods_number flow_order:@"0" row:[_model.goods_list indexOfObject:model] isnum:false];
    }else{
        [self updateCart:model goods_number:model.goods_number flow_order:@"1" row:[_model.goods_list indexOfObject:model] isnum:false];
    }
    
}

- (void)goodsNumberChange:(NSDictionary *)dic{

    MBGood_ListModel *model = dic[@"model"];
     [self updateCart:model goods_number:dic[@"num"] flow_order:@"1" row:[_model.goods_list indexOfObject:model] isnum:true];

}

@end
