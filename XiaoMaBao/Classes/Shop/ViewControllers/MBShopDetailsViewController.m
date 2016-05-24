//
//  MBShopDetailsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBShopDetailsViewController.h"
#import "NTalkerChatViewController.h"
#import "XNGoodsInfoModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MBJoinCartViewController.h"
#import "MBLoginViewController.h"
#import "XWCatergoryView.h"
#import "MBTableViewRmbCell.h"
#import "MBShopTableViewCell.h"
#import "NSString+BQ.h"
#import "MBShoppingCartViewController.h"

#import "MBShopAddresViewController.h"
@interface MBShopDetailsViewController ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,XWCatergoryViewDelegate,SDPhotoBrowserDelegate>
{
    /**
     *  商品介绍
     */
    NSMutableArray *_heightArray;
    BOOL _isReload;
    NSInteger _oldRow;
    /**
     *  麻麻口碑
     */
    NSMutableArray *_evaluationArray;
    NSDictionary *_dic;
    NSDictionary   *_commentsdict;
    NSInteger     _page;
    /**
     *  规格产参数
     */
    NSArray *_googBrandArray;
}
@property (strong, nonatomic)  UIScrollView      *backgroundScrollView;
/** 记录scrollView上次偏移的Y距离 */
@property (nonatomic, assign) CGFloat                    scrollY;
/** 记录scrollView上次偏移X的距离 */
@property (nonatomic, assign) CGFloat                    scrollX;
/** 记录当前展示的tableView 计算顶部topView滑动的距离 */
@property (nonatomic, weak  ) UITableView                *showingTableView;
/** 商品tableView */
@property (nonatomic, strong) UITableView                *rmdTableView;
/** 信息tableView */
@property (nonatomic, strong) UITableView                *infoTableView;
/** 评价tableView */
@property (nonatomic, strong) UITableView                *evaluationTableView;

/** 用来装顶部的scrollView用的View */
@property (nonatomic, strong) SDCycleScrollView           *topView;

/** 选择tableView的view */
@property (nonatomic, strong) XWCatergoryView              *selectView;

@end

@implementation MBShopDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isReload = YES;
    _page  =1 ;
    _evaluationArray = [NSMutableArray array];
    _heightArray     = [NSMutableArray array];
    [self getGoosInfo];
    [self   setUI];
    [self setTopView];
    [self setupShopTabbar];
    [self.view insertSubview:self.navBar aboveSubview:self.selectView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(is_attention:) name:@"rmbTable_image_heght" object:nil];
}
- (void)is_attention:(NSNotification *)notificat{
    if ([self.showingTableView isEqual:self.rmdTableView]) {
        NSIndexPath *indexPath = notificat.userInfo[@"indexPath"];
        NSString *image_height =  notificat.userInfo[@"image_height"];
        _heightArray[indexPath.row] = image_height;
//        NSLog(@"%ld",(long)indexPath.row);
        if (_isReload) {
            if (indexPath.row >= _oldRow) {
               [self.rmdTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            }
            
            
        }
        
        _oldRow = indexPath.row ;
    }
    
}

- (void)setUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-40-TOP_Y)];
    [self.view addSubview:self.backgroundScrollView];
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.contentSize = CGSizeMake(UISCREEN_WIDTH * 3, 0);
    
    //商品简介
    self.rmdTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-40-TOP_Y) style:UITableViewStylePlain];
    self.rmdTableView.delegate = self;
    self.rmdTableView.dataSource = self;
    self.rmdTableView.backgroundColor = [UIColor whiteColor];
    self.rmdTableView.contentInset = UIEdgeInsetsMake(UISCREEN_WIDTH  + 40, 0, 0, 0);
    self.rmdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backgroundScrollView addSubview:    self.showingTableView = self.rmdTableView];
    
    //规格参数
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-40-TOP_Y) style:UITableViewStylePlain];
    self.infoTableView.contentInset = UIEdgeInsetsMake(UISCREEN_WIDTH + 40, 0, 0, 0);
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backgroundScrollView addSubview:self.infoTableView];
    
    //麻妈口碑
    self.evaluationTableView = [[UITableView alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH*2, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-40-TOP_Y) style:UITableViewStylePlain];
    self.evaluationTableView.contentInset = UIEdgeInsetsMake(UISCREEN_WIDTH + 40, 0, 0, 0);
    self.evaluationTableView.delegate = self;
    self.evaluationTableView.dataSource = self;
    
    self.evaluationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backgroundScrollView addSubview:self.evaluationTableView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 上拉刷新
    self.evaluationTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([weakSelf.showingTableView isEqual:weakSelf.evaluationTableView]) {
            [weakSelf getcomments];
            [weakSelf.evaluationTableView.mj_footer endRefreshing];
        }
        
        
    }];
    // 默认先隐藏footer
    self.evaluationTableView.mj_footer.hidden = YES;
    
}
- (UIView *)setTableHeadView{
    UIView *commonView = [[UIView alloc] init];
    commonView.frame = CGRectMake(0, 0, self.view.ml_width, 30);
    UILabel *commonLbl = [[UILabel alloc] init];
    commonLbl.frame = CGRectMake(MARGIN_8, 0, commonView.ml_width, commonView.ml_height);
    commonLbl.font = [UIFont systemFontOfSize:14];
    commonLbl.textColor = [UIColor colorWithHexString:@"323232"];
    NSString *comment_num = [_commentsdict valueForKeyPath:@"comment_num"]?:@"";
    commonLbl.text = [NSString stringWithFormat:@"评论晒单 (%@人评论)",comment_num];
    [commonView addSubview:commonLbl];
    
    UILabel *praiseTextLbl = [[UILabel alloc] init];
    praiseTextLbl.font = [UIFont systemFontOfSize:14];
    praiseTextLbl.text = @"好评率";
    praiseTextLbl.frame = CGRectMake(commonView.ml_width - 8 - 50, 0, 50, commonView.ml_height);
    [commonView addSubview:praiseTextLbl];
    
    UILabel *praiseLbl = [[UILabel alloc] init];
    praiseLbl.font = [UIFont systemFontOfSize:14];
    praiseLbl.textColor = [UIColor colorWithHexString:@"e8465e"];
    NSString *good_comment_rate = [_commentsdict valueForKeyPath:@"good_comment_rate"]?:@"";
    praiseLbl.text = good_comment_rate;
    praiseLbl.frame = CGRectMake(commonView.ml_width - 8 - 100, 0, 50, commonView.ml_height);
    [commonView addSubview:praiseLbl];
    [self addBottomLineView:commonView];
    return commonView;
}
- ( void)setTopView{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH,UISCREEN_WIDTH) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    cycleScrollView.imageURLStringsGroup = @[@"ttp://www.xiaomabao.com/images/20160229/20163102291534311494.jpg",@"http://www.xiaomabao.com/images/20160229/20162902291535164358.jpg",@"http://www.xiaomabao.com/images/20160229/20162902291535163960.jpg"];
    cycleScrollView.autoScrollTimeInterval = 10.0f;
    [self.view addSubview: _topView = cycleScrollView];
    
    
    XWCatergoryView * catergoryView = [[XWCatergoryView alloc] initWithFrame:CGRectMake(0, UISCREEN_WIDTH+TOP_Y, UISCREEN_WIDTH,40)];
    catergoryView.titles = @[@"商品介绍",@"规格参数",@"麻妈口碑"];
    catergoryView.delegate = self;
    catergoryView.scrollView = self.backgroundScrollView;
    catergoryView.titleColorChangeGradually = YES;
    catergoryView.backEllipseEable = NO;
    catergoryView.bottomLineEable = YES;
    catergoryView.bottomLineColor = [UIColor colorWithHexString:@"c86a66"];
    catergoryView.bottomLineWidth = 4;
    catergoryView.titleFont = [UIFont boldSystemFontOfSize:14];
    catergoryView.bottomLineSpacingFromTitleBottom =10;
    catergoryView.scrollWithAnimaitonWhenClicked = NO;
    catergoryView.titleColor = [UIColor colorWithHexString:@"333333"];
    catergoryView.titleSelectColor = [UIColor colorWithHexString:@"c86a66"];
    catergoryView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_selectView = catergoryView];
    
    
    
}
#pragma mark - 商品底部Tabbar
- (void)setupShopTabbar{
    UIView *tabbarView                = [[UIView alloc] init];
    tabbarView.backgroundColor        = [UIColor whiteColor];
    CGFloat height                    = 40;
    tabbarView.frame                  = CGRectMake(0, UISCREEN_HEIGHT-40,UISCREEN_WIDTH, height);
    [self.view addSubview:  tabbarView];
    //小能移动客服
    UIButton *customerBtn             = [UIButton buttonWithType:UIButtonTypeCustom];
    [customerBtn setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
    customerBtn.frame                 = CGRectMake(0, 0, 35, height);
    [tabbarView addSubview:customerBtn];
    [customerBtn addTarget:self action:@selector(service) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView                  = [[UIView alloc] init];
    lineView.frame                    = CGRectMake(CGRectGetMaxX(customerBtn.frame), 10, 1, height -20);
    lineView.backgroundColor          = [UIColor colorWithHexString:@"898989"];
    [tabbarView addSubview:lineView];
    
    
    //收藏按钮
    UIButton *collectionBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.GoodsDict[@"is_collect"] integerValue] == 0) {
        [collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    } else {
        [collectionBtn setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
    }
    [collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    
    collectionBtn.frame               = CGRectMake(35, 0, 35, height);
    [collectionBtn addTarget:self action:@selector(ClickCollection:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:collectionBtn];
    
    [self addTopLineView:tabbarView];
    
    CGFloat width                     = (UISCREEN_WIDTH - CGRectGetMaxX(collectionBtn.frame) - MARGIN_20) * 0.5;
    CGFloat y                         = (tabbarView.ml_height - 30) / 2;
    
    UIButton *purchaseBtn             = [UIButton buttonWithType:UIButtonTypeCustom];
    purchaseBtn.frame                 = CGRectMake(CGRectGetMaxX(collectionBtn.frame) + MARGIN_10, y, width, 30);
    purchaseBtn.titleLabel.font       = [UIFont systemFontOfSize:15];
    purchaseBtn.backgroundColor       = [UIColor colorWithHexString:@"eeb94f"];
    [purchaseBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    //立即购买
    [purchaseBtn addTarget:self action:@selector(goNowBuy) forControlEvents:UIControlEventTouchUpInside];
    purchaseBtn.layer.cornerRadius    = 3.0;
    [tabbarView addSubview:purchaseBtn];
    
    UIButton *shopingCartBtn          = [UIButton buttonWithType:UIButtonTypeCustom];
    shopingCartBtn.frame              = CGRectMake(CGRectGetMaxX(purchaseBtn.frame) + MARGIN_5, y, width, 30);
    shopingCartBtn.titleLabel.font    = [UIFont systemFontOfSize:15];
    shopingCartBtn.backgroundColor    = [UIColor colorWithHexString:@"e8465e"];
    [shopingCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    shopingCartBtn.layer.cornerRadius = 3.0;
    [tabbarView addSubview:shopingCartBtn];
    //加入购物车
    [shopingCartBtn addTarget:self action:@selector(goJoinCart) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --小能客服
- (void)service{
    XNGoodsInfoModel *info          = [[XNGoodsInfoModel alloc] init];
    info.appGoods_type              = @"3";
    info.clientGoods_Type           = @"1";
    info.goods_id                   = self.GoodsId;
    info.goods_showURL              = [NSString stringWithFormat:@"http://www.xiaomabao.com/goods-%@.html",self.GoodsDict[@"goods_id"]];
    info.goods_imageURL             = self.goods_gallery[0];
    info.goodsTitle                 = self.goods_name;
    info.goodsPrice                 = self.shop_price_formatted;
    info.goods_URL                  = @"https://www.baidu.com";
    
    NTalkerChatViewController *ctrl = [[NTalkerChatViewController alloc] init];
    ctrl.productInfo                = info;
    ctrl.settingid                  = @"kf_9761_1432534158571";//【必传】 客服组id
    ctrl.erpParams                  = @"www.baidu.com";
    
    
    ctrl.pushOrPresent              = NO;
    
    if (ctrl.pushOrPresent == YES) {
        [self.navigationController pushViewController:ctrl animated:YES];
    } else {
        UINavigationController *nav     = [[UINavigationController alloc] initWithRootViewController:ctrl];
        ctrl.pushOrPresent              = NO;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}

#pragma -mark  加入购物车
- (void)goJoinCart{
    MBJoinCartViewController *joinCartVc = [[MBJoinCartViewController alloc] init];
    joinCartVc.isBuy                     = NO;
    joinCartVc.isSelectGuige             = NO;
    joinCartVc.goods_name                = self.goods_name;
    joinCartVc.goods_id                  = self.GoodsId;
    joinCartVc.shop_price                = self.shop_price;
    joinCartVc.showPlayImageUrl          = self.showPlayImageUrl;
    joinCartVc.goods_number              = [self.GoodsDict valueForKeyPath:@"goods_number"];
    joinCartVc.title                     = @"商品规格";
    [self.navigationController pushViewController:joinCartVc animated:YES];
    
}
#pragma -mark --立即购买
- (void)goNowBuy{
    MBJoinCartViewController *joinCartVc = [[MBJoinCartViewController alloc] init];
    joinCartVc.isBuy            = YES;
    joinCartVc.isSelectGuige    = NO;
    joinCartVc.goods_name       = self.goods_name;
    joinCartVc.goods_id         = self.GoodsId;
    joinCartVc.shop_price       = self.shop_price;
    joinCartVc.showPlayImageUrl = self.showPlayImageUrl;
    joinCartVc.goods_number     = [self.GoodsDict valueForKeyPath:@"goods_number"];
    joinCartVc.title            = @"商品规格";
    [self.navigationController pushViewController:joinCartVc animated:YES];
}
//收藏
#pragma mark - 商品底部收藏按钮
-(void)ClickCollection:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
    [self CreateMycollection];
}
//获取收藏数据
-(void)CreateMycollection
{
    NSString *sid         = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid         = [MBSignaltonTool getCurrentUserInfo].uid;
    if (sid == nil && uid == nil) {
        
        [self    loginClicksss];
        return;
        
    }
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"user/collect/create"] parameters:@{@"session":session,@"goods_id":self.GoodsId}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   
                   
                   [self show:@"加入收藏成功" time:1];
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   NSLog(@"%@",error);
                   [self show:@"请求失败！" time:1];
               }];
    
}
#pragma mark -- 商品内容详情
-(void)getGoosInfo
{
    
    [self show];
    
    
    self.GoodsId = @"4310";
    if (self.GoodsId == nil) {
        
        return ;
    }
    if(self.actId == nil){
        self.actId = @"";
    }
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getGoodsInfo"] parameters:@{@"session":session,@"goods_id":self.GoodsId,@"act_id":self.actId} success:^(NSURLSessionDataTask *operation, id responseObject) {
  
        [self dismiss];
        self.GoodsDict = [responseObject valueForKeyPath:@"data"];
//        NSLog(@"商品详情---%@",self.GoodsDict);
        
        
        NSArray *arr = [self.GoodsDict valueForKeyPath:@"goods_gallery"];
        if (arr.count>0) {
            self.showPlayImageUrl = [arr objectAtIndex:0];
        }
        
        self.goods_name = [self.GoodsDict valueForKeyPath:@"goods_name"];
        self.shop_price = [self.GoodsDict valueForKeyPath:@"shop_price"];
        self.shop_price_formatted = [self.GoodsDict valueForKeyPath:@"shop_price_formatted"];
        self.market_price = [self.GoodsDict valueForKeyPath:@"market_price"];
        self.market_price_formatted = [self.GoodsDict valueForKeyPath:@"market_price_formatted"];
        self.preferential_info = [self.GoodsDict valueForKeyPath:@"preferential_info"];
        self.active_remainder_time = [self.GoodsDict valueForKeyPath:@"active_remainder_time"];
        self.is_promote = [self.GoodsDict valueForKeyPath:@"is_promote"];
        self.is_shipping = [self.GoodsDict valueForKeyPath:@"is_shipping"];
        self.goods_brief = [self.GoodsDict valueForKeyPath:@"goods_brief"];
        self.goods_gallery = [self.GoodsDict valueForKeyPath:@"goods_gallery"];
        self.goods_desc = [self.GoodsDict valueForKeyPath:@"goods_desc"];
        //商品编码
        self.goods_sn = [self.GoodsDict valueForKeyPath:@"goods_sn"];
        self.goods_number = [self.GoodsDict valueForKeyPath:@"goods_number"];
        //品牌
        self.goods_brand = [self.GoodsDict valueForKeyPath:@"goods_name"];
        
        self.carriage_fee = [self.GoodsDict valueForKeyPath:@"carriage_fee"];
        self.salesnum = [self.GoodsDict valueForKeyPath:@"salesnum"];
        
        for (NSString *str in self.goods_desc) {
            [_heightArray addObject:[NSString stringWithFormat:@"%f",UISCREEN_WIDTH*80/213]];
        }
        _isReload = YES;
        [self.rmdTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"失败");
        [KVNProgress dismiss];
        
        
        
        
    }];
    
}
#pragma mark -- 妈妈口碑
-(void)getcomments
{
    [self show ];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *pagination =[NSDictionary dictionaryWithObjectsAndKeys:page,@"page",@"10",@"count", nil];;
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"comments"] parameters:@{@"goods_id":self.GoodsId,@"pagination":pagination} success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        [self dismiss];
        NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
        _commentsdict = [responseObject valueForKeyPath:@"data"];
        [_evaluationArray addObjectsFromArray:dic[@"comments_list"]];
        if ([dic isEqualToDictionary:_dic ]) {
            
            [ self.evaluationTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        _dic = [responseObject valueForKeyPath:@"data"];
        self.evaluationTableView.tableHeaderView = [self setTableHeadView];
        [self.evaluationTableView reloadData];
        _page ++;
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        [self show:@"请求失败" time:1];
        
    }];
    
    
    
    
}
//获取规格参数
-(void)getGoodBrand
{
    
    
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getGoodsProperties"] parameters:@{@"goods_id":self.GoodsId}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   [self dismiss];
                   NSLog(@"规格参数成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                   _googBrandArray = [responseObject valueForKeyPath:@"data"];
                   
                   [self.infoTableView reloadData];
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   [self show:@"请求失败" time:1];
               }];
    
    
    
}

- (NSString *)titleStr{
    return @"商品详情";
}

-(NSString *)rightImage{
    return @"shoppingCart";
}

-(void)rightTitleClick{
    
    MBShoppingCartViewController *shoppingCartVc = [[MBShoppingCartViewController alloc] init];
    shoppingCartVc.showBottomBar = @"yes";//不显示底栏
    [self.navigationController pushViewController:shoppingCartVc animated:YES];
}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    
    myView.vcType                 = @"mabao";
    
    MBNavigationViewController *VC    = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//这里计算相当繁琐 耐心慢慢来吧
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([self.backgroundScrollView isEqual:scrollView]) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger num = offsetX/UISCREEN_WIDTH;
        switch (num) {
            case 0:
                self.showingTableView = self.rmdTableView;
                break;
            case 1:
                self.showingTableView = self.infoTableView;
                if (!_googBrandArray) {
                    [self getGoodBrand];
                }
                
                break;
            case 2:{
                self.showingTableView = self.evaluationTableView;
              
                if (_page==1) {
                     [self getcomments];
                }
               
            }
                break;
            default:
                break;
        }

        if (self.scrollY >= -(40)) {
            if (self.showingTableView == self.rmdTableView) {
                self.rmdTableView.contentOffset = CGPointMake(0,-40);
                
                
            } else if (self.showingTableView == self.infoTableView) {
                self.infoTableView.contentOffset = CGPointMake(0,-40  );
                
            }else{
                self.evaluationTableView.contentOffset = CGPointMake(0,-40);
               
                
            }
        } else {
            
            if (self.showingTableView == self.rmdTableView) {
                self.rmdTableView.contentOffset = CGPointMake(0,self.scrollY);
                
                
            } else if (self.showingTableView == self.infoTableView) {
                self.infoTableView.contentOffset = CGPointMake(0,self.scrollY );
              
            }else{
                self.evaluationTableView.contentOffset = CGPointMake(0,self.scrollY);
               
            }
        }
        
        
    }else{
        
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat seleOffsetY = offsetY - self.scrollY;
        self.scrollY = offsetY;
        
        //         self.showingTableView = (UITableView *)scrollView;
        //判断rmdTableView是否滑动到底部－－到底部禁止刷新（不然出现奇葩状态）
        if ([scrollView isEqual:self.rmdTableView]) {
            CGFloat height = scrollView.ml_height;
            CGFloat distanceFromBottom = scrollView.contentSize.height  - offsetY;
            if (distanceFromBottom<height) {
                _isReload = NO;
                
            }
        }
        
        CGRect headRect = self.topView.frame;
        headRect.origin.y -= seleOffsetY;
        self.topView.frame = headRect;
        
        /* 这段代码很有深意啊。。最开始是直接用偏移量算的，但是回来的时候速度比较快时偏移量会偏度很大
         然后就悲剧了。换了好多方法。。最后才开窍T——T,这一段我会在blog里面详细描述我用的各种错误的方法
         用了KVO监听偏移量的值,切换了selectView的父控件，切换tableview的headView。。。
         */
        if (offsetY >= -(40)) {
            self.selectView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH , 40);
        } else {
            self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), UISCREEN_WIDTH, 40);
        }
        
        CGFloat selectViewOffsetY = self.selectView.ml_y - UISCREEN_WIDTH;
        
        if (selectViewOffsetY != -(UISCREEN_WIDTH-40) && selectViewOffsetY <= 0) {
            
            if (scrollView == self.rmdTableView) {
                
                self.infoTableView.contentOffset = CGPointMake(0, offsetY);
                self.evaluationTableView.contentOffset = CGPointMake(0, offsetY);
                
            } else if (scrollView == self.infoTableView) {
                
                self.rmdTableView.contentOffset = CGPointMake(0, offsetY);
                self.evaluationTableView.contentOffset = CGPointMake(0, offsetY);
                
            }else{
                self.infoTableView.contentOffset = CGPointMake(0, offsetY);
                self.rmdTableView.contentOffset = CGPointMake(0, offsetY);
            }
        }
        
    }
    
    
}

#pragma mark - <UICollectionViewDataSource>
- (void)catergoryView:(XWCatergoryView *)catergoryView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            self.showingTableView = self.rmdTableView;
            break;
        case 1:
            self.showingTableView = self.infoTableView;
            if (!_googBrandArray) {
                [self getGoodBrand];
            }
            
            break;
        case 2:{
            self.showingTableView = self.evaluationTableView;
            if (_page ==1) {
                [self getcomments];
            }
           
        }
            break;
        default:
            break;
    }
    
}

#pragma mark --UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.rmdTableView]) {
        return self.goods_desc.count;
    }else if([tableView isEqual:self.infoTableView]){
        return _googBrandArray.count;
        
    }
    return _evaluationArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.rmdTableView]) {
        return [_heightArray[indexPath.row] floatValue];
    }else if([tableView isEqual:self.infoTableView]){
        
        return 25;;
    }
    
    NSDictionary *dic =_evaluationArray[indexPath.row];
    NSString *contentr = dic[@"content"];
    NSInteger height = [contentr sizeWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT) ].height;
    NSArray *arr = dic[@"img_path"];
    if (arr.count>0) {
        return 50+height+(UISCREEN_WIDTH-40)/5+20;
    }
    
    
    return 50+height;
    
}
#pragma mark --- UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([tableView isEqual:self.rmdTableView]) {
        MBTableViewRmbCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBTableViewRmbCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBTableViewRmbCell" owner:nil options:nil]firstObject];
        }
        cell.indexPath = indexPath;
        cell.image_height = _heightArray[indexPath.row];
        [cell setImageUrl:self.goods_desc[indexPath.row]];
        return cell;
    }else if ([tableView isEqual:self.evaluationTableView]){
        
        MBShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBShopTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBShopTableViewCell" owner:self options:nil]firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = _evaluationArray[indexPath.row];
        [cell dict:dic];
        return cell;
    }
    static NSString *str = @"ssss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",_googBrandArray[indexPath.row][@"name"],_googBrandArray[indexPath.row][@"value"]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"433f3e"];
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.rmdTableView]) {
        
        //        SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
        //        photoBrowser.delegate = self;
        //        photoBrowser.currentImageIndex = indexPath.row;
        //        photoBrowser.imageCount = self.goods_desc.count;
        //        photoBrowser.sourceImagesContainerView = self.rmdTableView;
        //
        //        [photoBrowser show];
        MBShopAddresViewController *VC = [[MBShopAddresViewController alloc] init];
        [self pushViewController:VC Animated:YES];

        
    }
}
#pragma mark -- SDPhotoBrowserdelegate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.goods_desc[index]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    return imageView.image;
}
// 返回高质量图片的url

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:self.goods_desc[index]];
}

@end
