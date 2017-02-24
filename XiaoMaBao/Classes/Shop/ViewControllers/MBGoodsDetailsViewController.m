//
//  MBGoodsDetailsViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBGoodsDetailsViewController.h"
#import "MBGoodsModel.h"
#import "MBShoppingBtn.h"
#import "MBImageTableViewCell.h"
#import "MBGoodsSpecsView.h"
#import "MBShoppingBtn.h"
#import "MBShoppingCartViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MBShopTableViewCell.h"
#import "MBNavigationViewController.h"
#import "DataSigner.h"
#import "MBGoodsPropertyTableViewCell.h"
@interface MBGoodsDetailsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_goodsName;
    UILabel *_shopPriceFormatted;
    UILabel *_marketPriceFormatted;
    UILabel *_goods_number;
    UIView  *_infoItemLineView;
    NSTimer *_myTimer;
    UIButton  *_lastButton;
    BOOL _isCommentData;
    BOOL _isPropertyData;
    BOOL _isSpecData;
    NSInteger _page;
    NSArray *_titles;
    NSArray<UITableView *> *_tableViews;
    
}

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, weak)   UIView *headBackView;
@property (nonatomic, weak)   UIView *headView;
@property (nonatomic, assign) CGFloat headViewHeight;
@property (nonatomic, strong) SDCycleScrollView *goodsImageSDScrollView;
@property (nonatomic, copy)   NSMutableArray *goodsInfoViewArr;
/**促销时间button*/
@property (nonatomic, strong) UIButton *timerButton;
/**商品信息Model*/
@property (nonatomic, strong) MBGoodsModel *model;
/**促销时间*/
@property (nonatomic, assign) int lettTimes;
/** 底部视图*/
@property (nonatomic, weak) UIScrollView *scrollView;
/** 记录tableview偏移量*/
@property (nonatomic, copy) NSMutableArray *contentOffsetDictionaryM;
/** 当前index*/
@property (nonatomic, assign) NSInteger pageIndex;
/** 上次偏移量*/
@property (nonatomic, assign) CGFloat contentoffSetY;
/** 临时headerView*/
@property (nonatomic, strong) UIView *tempHeaderView;
/** 上次位置*/
@property (nonatomic, assign) CGPoint lastContentOffset;
/** 滑动锁*/
@property (nonatomic, assign) BOOL islockObserveParam;
/**商品规格数据 */
@property (nonatomic, strong) MBGoodsSpecsRootModel *goodsSpecsModel;
/**商品介绍数据 */
@property (nonatomic, copy) NSArray<MBGoodsPropertyModel *> *goodsPropertyArray;
/**商品评价数据 */
@property (nonatomic, strong) MBGoodCommentModel *goodCommentModel;
@end

@implementation MBGoodsDetailsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getShoppingCartNumber];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_myTimer invalidate];
    _myTimer = nil;
    
}
- (NSMutableArray *)contentOffsetDictionaryM{
    
    if (!_contentOffsetDictionaryM) {
        
        _contentOffsetDictionaryM =  [NSMutableArray arrayWithObjects:@"null",@"null",@"null",nil];
        
    }
    return _contentOffsetDictionaryM;
}
- (UIView *)tempHeaderView{
    
    if (!_tempHeaderView) {
        _tempHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH, 50)];
        _tempHeaderView.userInteractionEnabled = NO;
        
    }
    return _tempHeaderView;
    
}
-(NSMutableArray *)goodsInfoViewArr
{
    if (!_goodsInfoViewArr) {
        _goodsInfoViewArr = [NSMutableArray array];
    }
    return _goodsInfoViewArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    
    //异步请求相应的数据，成功获取数据先后顺序未知（根据不同顺序做不同的半判断）
    [self getGoosInfoData];
    [self getGoodsCommentsData];
    [self getGoodsIntroduceData];
    [self getGoodsPropertyData];
    
    [self getShareButton];
    
    
    
    
}
#pragma mark --设置分享按钮
-(void)getShareButton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(UISCREEN_WIDTH - 2*NAV_BAR_W, NAV_BAR_Y, NAV_BAR_W, NAV_BAR_HEIGHT);
    [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goodShare) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0,0);
    [self.navBar addSubview:button];
    
}
-(void)goodShare{
    
    if (!_model.goods_gallery||_model.goods_gallery == 0 ) {
        [self show:@"商品图片不存在，无法分享！" time:.5];
        return;
    }
    //1、创建分享参数
    NSArray* imageArray = @[_model.goods_gallery.firstObject];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.xiaomabao.com/goods-%@.html",_model.goods_id]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_model.goods_name
                                         images:imageArray
                                            url:url
                                          title:@"小麻包母婴分享"
                                           type:SSDKContentTypeWebPage];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
    }
    
    
}
- (void)setupContentView
{
    self.islockObserveParam = YES;
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.delaysContentTouches = NO;
    [self.view addSubview:scrollView];
    
    scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView = scrollView;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(UISCREEN_WIDTH * 3, 0);
    scrollView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT- TOP_Y - 40);
    
    UITableView* table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, scrollView.mj_h)];
    table1.separatorStyle = UITableViewCellSeparatorStyleNone;
    table1.tag = 0;
    table1.delegate = self;
    table1.dataSource = self;
    
    table1.tableFooterView = [[UIView alloc] init];
    [scrollView addSubview:  table1];
    
    
    UITableView* table2 = [[UITableView alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH,0 , UISCREEN_WIDTH, scrollView.mj_h)];
    [table2 registerNib:[UINib nibWithNibName:@"MBGoodsPropertyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBGoodsPropertyTableViewCell"];
    table2.delegate = self;
    table2.dataSource = self;
    table2.tag = 1;
    table2.tableFooterView = [[UIView alloc] init];
    [scrollView addSubview:table2];
    
    
    
    UITableView* table3 = [[UITableView alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH*2,0 , UISCREEN_WIDTH, scrollView.mj_h)];
    [table3 registerNib:[UINib nibWithNibName:@"MBShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBShopTableViewCell"];
    table3.tag = 2;
    table3.delegate = self;
    table3.dataSource = self;
    table3.tableFooterView = [[UIView alloc] init];
    [scrollView addSubview: table3];
    
    
    _tableViews = @[table1,table2,table3];
    for (UITableView *table in _tableViews) {
        [table addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(scrollView)];
         table.scrollIndicatorInsets = UIEdgeInsetsMake(self.headViewHeight + 40, 0, 0, 0);
    }

    // 如何在加载前数据已经请求下来 要在这里加上拉加载方法
    if (_isCommentData) {
        MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getGoodsCommentsData)];
        footer.refreshingTitleHidden = YES;
        _tableViews.lastObject.mj_footer = footer;
    }
    
    
    
    
    [self.view addSubview:self.tempHeaderView];
    [self.view bringSubviewToFront:self.navBar];
    
    
    
}

- (void)setupHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, self.headViewHeight + 40)];
    headView.backgroundColor  = [UIColor    whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, self.headViewHeight)];
    [headView addSubview:view];
    
    
    self.headBackView = headView;
    self.headView = view;
    _goodsImageSDScrollView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    _goodsImageSDScrollView.autoScrollTimeInterval = 5.0f;
    _goodsImageSDScrollView.imageURLStringsGroup = _model.goods_gallery;
    [view addSubview:_goodsImageSDScrollView];
    
    
    
    _goodsName = [[UILabel alloc] init];
    _goodsName.textColor = [UIColor colorWithHexString:@"e8465e"];
    _goodsName.numberOfLines = 0;
    _goodsName.text = _model.goods_name;
    _goodsName.font = [UIFont boldSystemFontOfSize:13];
    [view addSubview:_goodsName];
    [_goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImageSDScrollView.mas_bottom).offset(10);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        
    }];
    
    _shopPriceFormatted = [[UILabel alloc] init];
    _shopPriceFormatted.textColor = [UIColor colorWithHexString:@"e8465e"];
    _shopPriceFormatted.text = _model.shop_price_formatted;
    _shopPriceFormatted.font = [UIFont boldSystemFontOfSize:22];
    [view addSubview:_shopPriceFormatted];
    [_shopPriceFormatted mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsName.mas_bottom).offset(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(35);
        
    }];
    
    
    _marketPriceFormatted = [[UILabel alloc] init];
    _marketPriceFormatted.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    _marketPriceFormatted.text = _model.market_price_formatted;
    _marketPriceFormatted.font = [UIFont systemFontOfSize:13];
    [view addSubview:_marketPriceFormatted];
    [_marketPriceFormatted mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_shopPriceFormatted);
        make.left.equalTo(_shopPriceFormatted.mas_right).offset(3);
        make.height.mas_equalTo(35);
        
    }];
    
    _goods_number = [[UILabel alloc] init];
    _goods_number.font = [UIFont systemFontOfSize:16];
    _goods_number.textAlignment = NSTextAlignmentCenter;
    _goods_number.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    _goods_number.text = [NSString stringWithFormat:@"库存: %@件",_model.goods_number];
    [view addSubview:_goods_number];
    [_goods_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_marketPriceFormatted);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(35);
    }];
    if ([_model.active_remainder_time integerValue] > 0) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
        UIButton *timeBtn = [[UIButton alloc] init];
        [timeBtn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
        timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        [timeBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
        _lettTimes = [_model.active_remainder_time intValue];
        NSInteger leftdays = [_model.active_remainder_time integerValue]/(24*60*60);
        NSInteger hour = ([_model.active_remainder_time integerValue]-leftdays*24*3600)/3600;
        NSInteger minute = ([_model.active_remainder_time integerValue] - hour*3600-leftdays*24*3600)/60;
        NSInteger second = ([_model.active_remainder_time integerValue] - hour *3600 - 60*minute-leftdays*24*3600);
        NSString *leftmessage;
        if (leftdays ==0 && hour == 0) {
            
            leftmessage = [NSString stringWithFormat:@"剩余%ld时%ld分%ld秒",hour,minute,second];
        }else
        {
            leftmessage = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",leftdays,hour,minute,second];
        }
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [timeBtn setTitle:leftmessage forState:UIControlStateNormal];
        [view addSubview: _timerButton =timeBtn];
        
        [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_marketPriceFormatted.mas_bottom);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(35);
        }];
        
    }
    
    
    //添加折扣 tag
    [self setTagButton:@"eeb94f" tagName:[NSString stringWithFormat:@"%@%@",_model.zhekou,@"折"] i:0 shopTimeView:view];
    
    
    //是否限时特卖
    if([_model.is_promote integerValue] > 0){
        [self setTagButton:@"e8465e" tagName:@"限时促销" i:2 shopTimeView:view];
    }
    
    //是否包邮
    if([_model.is_shipping isEqualToString:@"1"]){
        [self setTagButton:@"eeb94f" tagName:@"包邮" i:3 shopTimeView:view];
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lastButton.mas_bottom).offset(5);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(PX_ONE);
    }];
    
    
    
    UILabel *shopPackageView = [[UILabel alloc] init];
    shopPackageView.userInteractionEnabled = YES;
    shopPackageView.textColor = [UIColor colorWithHexString:@"323232"];
    shopPackageView.text = @"选择：套餐分类、规格";
    [view addSubview:shopPackageView];
    [shopPackageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.mas_equalTo(MARGIN_8);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"next"];
    imageview.image = image;
    imageview.userInteractionEnabled = YES;
    [shopPackageView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(UISCREEN_WIDTH - 8 - image.size.width*2);
        make.size.mas_equalTo(image.size);
    }];
    
    UITapGestureRecognizer *ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSpecifications)];
    [shopPackageView  addGestureRecognizer:ger];
    
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    [view addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shopPackageView.mas_bottom);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(PX_ONE);
    }];
    
    UIView *goodsInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headViewHeight+TOP_Y, UISCREEN_WIDTH, 40)];
    goodsInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_menuView = goodsInfoView];
    CGFloat width = UISCREEN_WIDTH / 3;
    
    _titles = @[
                @"商品介绍",
                @"规格参数",
                @"麻妈口碑"
                ];
    
    for (NSInteger i = 0 ; i < _titles.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(i * width, 0, width, 40);
        [goodsInfoView addSubview:view];
        
        MBShoppingBtn *btn = [MBShoppingBtn buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, width, 40);
        [btn addTarget:self action:@selector(changeItem:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        if (i == 0) {
            _lastButton = btn;
            btn.clickStatus = YES;
        }
        
        [self.goodsInfoViewArr addObject:btn];
        
        if (i != 2) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(width - PX_ONE, 10, PX_ONE,  20);
            lineView.backgroundColor = [UIColor colorWithHexString:@"898989"];
            [view addSubview:lineView];
        }
    }
    
    UIView *infoItemLineView = [[UIView alloc] init];
    infoItemLineView.frame = CGRectMake(0, 40 - 2, width, 2);
    infoItemLineView.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    [goodsInfoView addSubview:_infoItemLineView = infoItemLineView];
    self.pageIndex = 0 ;
    _tableViews[_pageIndex].tableHeaderView = _headBackView;
    
    
    
    
    self.islockObserveParam = false;
    
    
}

#pragma mark - 商品底部Tabbar
- (void)setupGoodsTabbar{
    UIView *tabbarView = [[UIView alloc] init];
    tabbarView.backgroundColor = [UIColor whiteColor];
    CGFloat height = 40;
    tabbarView.frame = CGRectMake(0, self.view.ml_height - height, self.view.ml_width, height);
    [self.view addSubview: tabbarView];
    //小能移动客服
    UIButton *customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customerBtn setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
    customerBtn.frame = CGRectMake(0, 0, 35, height);
    [tabbarView addSubview:customerBtn];
    [customerBtn addTarget:self action:@selector(service) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(CGRectGetMaxX(customerBtn.frame), 10, 1, height -20);
    lineView.backgroundColor = [UIColor colorWithHexString:@"898989"];
    [tabbarView addSubview:lineView];
    
    
    //收藏按钮
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_model.is_collect) {
        [collectionBtn setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
        
        
    } else {
        [collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    }
    
    
    collectionBtn.frame = CGRectMake(35, 0, 35, height);
    [collectionBtn addTarget:self action:@selector(ClickCollection:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:collectionBtn];
    
    [self addTopLineView:tabbarView];
    
    CGFloat width = (self.view.ml_width - CGRectGetMaxX(collectionBtn.frame) - MARGIN_20) * 0.5;
    CGFloat y = (tabbarView.ml_height - 30) / 2;
    //立即购买
    UIButton *purchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    purchaseBtn.tag = 2;
    purchaseBtn.frame = CGRectMake(CGRectGetMaxX(collectionBtn.frame) + MARGIN_10, y, width, 30);
    purchaseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    purchaseBtn.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    [purchaseBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [purchaseBtn addTarget:self action:@selector(purchaseGoods:) forControlEvents:UIControlEventTouchUpInside];
    purchaseBtn.layer.cornerRadius = 3.0;
    [tabbarView addSubview:purchaseBtn];
    //加入购物车
    UIButton *shopingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopingCartBtn.tag = 1;
    shopingCartBtn.frame = CGRectMake(CGRectGetMaxX(purchaseBtn.frame) + MARGIN_5, y, width, 30);
    shopingCartBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shopingCartBtn.backgroundColor = [UIColor colorWithHexString:@"eeb94f"];
    [shopingCartBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    shopingCartBtn.layer.cornerRadius = 3.0;
    [tabbarView addSubview:shopingCartBtn];
    [shopingCartBtn addTarget:self action:@selector(purchaseGoods:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)changeItem:(MBShoppingBtn *)btn{
    
    if (btn.isClickStatus) {
        return ;
    }
    MBShoppingBtn *latBtn = (MBShoppingBtn *)_lastButton;
    latBtn.clickStatus = false;
    btn.clickStatus = YES;
    _lastButton = btn;
    [UIView animateWithDuration:.25 animations:^{
        _infoItemLineView.ml_x = btn.tag * btn.ml_width;
    }];
    
    [self.scrollView setContentOffset:CGPointMake(UISCREEN_WIDTH * btn.tag, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.scrollView];
    
}
-(void)timeFireMethod:(NSTimer *)timer{
    
    
    _lettTimes--;
    if (_lettTimes > 0) {
        NSInteger leftdays = _lettTimes/(24*60*60);
        NSInteger hour = (_lettTimes-leftdays*24*3600)/3600;
        NSInteger minute = (_lettTimes - hour*3600-leftdays*24*3600)/60;
        NSInteger second = (_lettTimes - hour *3600 - 60*minute-leftdays*24*3600);
        NSString *leftmessage;
        if (leftdays ==0 && hour == 0) {
            leftmessage = [NSString stringWithFormat:@"剩余%ld时%ld分%ld秒",hour,minute,second];
            
        }else
        {
            leftmessage = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",leftdays,hour,minute,second];
            
        }
        
        [_timerButton setTitle:leftmessage forState:UIControlStateNormal];
    }
    
    if(_lettTimes==0){
        [_myTimer invalidate];
        _myTimer = nil;
    }
}
#pragma mark --云客服
- (void)service{
    
    
    NSArray *imgarr =    _model.goods_gallery;
    
    NSDictionary *itemInfo = @{
                               @"title" : _model.goods_name?:@"",
                               @"desc"  :  @"",
                               @"iconUrl" : imgarr?imgarr.firstObject:@"",
                               @"url" : [NSString stringWithFormat:@"http://www.xiaomabao.com/goods-%@.html",_model.goods_id]
                               };
    [[Unicall singleton] UnicallShowView:itemInfo];
    
    
    [self getUnicallSignature];
    
    
    
}

-(void)getUnicallSignature{
    NSString *privateKey =  [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             @"MIIBPAIBAAJBAMBrqadzplyUtQUXCP+VuDFWt0p9Kl+s3yrQ8PV+P89Bbt/UqN2/",
                             @"BzVNPoNgtQ2fI7Ob652limC/jqVf6slzPEUCAwEAAQJAOL7HXnGVqxHTvHeJmM4P",
                             @"bsVy8k2tNF/nxFmv5cXgjX7sd7BU9jyELGP4os3ID3tItdCHtmMM3KM91lTHYlkk",
                             @"dQIhAOWKnz0moWISa0S8cBYJI0k0PRoYMv6Xsty5aZpC9WM/AiEA1pmqSthbMUb2",
                             @"TrmRyJsHswLAYSHotTIS0kzHu655M3sCIQDLdWXUJCuj7EOcd5K6VXsrZdxLBuwc",
                             @"coYd01LhYzxyrQIhAIsqc6i9zcWTAz/iT4wMHV4VNrTGzKZUpqgCarRnXOnpAiEA",
                             @"pbZzKKXpVGNp2MMXRlpdzdGCKFMYSeqnqXuwd76iwco="
                             ];
    NSString *tenantId = UNICALL_TENANID;
    NSString *appKey = UNICALL_APPKEY;
    NSString *time = [self getCurrentTime];
    NSString *expireTime = @"60000";
    
    NSString *stringToSign = [NSString stringWithFormat:@"%@&%@&%@&%@",appKey,expireTime,tenantId,time];
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
    NSString *signature = [signer uncallString:stringToSign];
    NSDictionary *json = @{@"appKey":appKey,@"expireTime":expireTime,@"signature":signature,@"tenantId":tenantId,@"time":time};
    
    Unicall *unicall = [Unicall singleton];
    [unicall UnicallUpdateValidation:json];
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        [unicall UnicallUpdateUserInfo:@{@"nickname":@"未注册用户"}];
    }else{
        
        [unicall UnicallUpdateUserInfo:@{@"nickname": string(@"用户的sid:", sid)}];
    }
    
}

-(NSString*)getCurrentTime {
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    
    
    return dateTime;
    
}



#pragma mark 购买商品
- (void)purchaseGoods:(UIButton *)btn{
    switch (btn.tag) {
        case 1: [self presentSemiType:2];break;
          
        default: [self presentSemiType:3];break;
    }
}
#pragma mark - 商品收藏
-(void)ClickCollection:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
    [self getCollectionGoodsData];
}
//获取收藏数据
-(void)getCollectionGoodsData
{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (sid == nil && uid == nil) {
        [self loginClicksss:@"shop"];
        return;
    }
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/collect/collect_goods"] parameters:@{@"session":session,@"goods_id":self.GoodsId}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   
                   
                   [self show:@"加入收藏成功" time:1];
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   MMLog(@"%@",error);
                   [self show:@"请求失败！" time:1];
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
    [self.navigationController pushViewController:shoppingCartVc animated:YES];
}
#pragma MARK ---选择规格;
- (void)chooseSpecifications{
    
    if (_goodsSpecsModel) {
        
        [self presentSemiType:1];
    }else{
        _isSpecData = YES;
        [self getGoodsPropertyData];
    }
    
    
}
- (void)presentSemiType:(NSInteger )type{
    
    MBGoodsSpecsView * imagev = [[MBGoodsSpecsView alloc] initWithModel:_goodsSpecsModel type:type];
    imagev.VC = self;
    
    WS(weakSelf)
    imagev.getCarData = ^(){
        [weakSelf getShoppingCartNumber];
    
    };
    UIImageView * bgimgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    bgimgv.backgroundColor = [UIColor blackColor];
    [self presentSemiView:imagev withOptions:@{ KNSemiModalOptionKeys.backgroundView:bgimgv }];

}
- (void)setTagButton:(NSString *)color tagName:(NSString *)tagName i:(NSInteger)i shopTimeView:(UIView *)shopTimeView{
    CGFloat tagBtnheight = 20;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithHexString:color];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    CGFloat width = [tagName boundingRectWithSize:CGSizeMake(MAXFLOAT, tagBtnheight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size.width + 10;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:tagName forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.0f;
    [shopTimeView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goods_number.mas_bottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(tagBtnheight);
        if (!_lastButton) {
            make.right.mas_equalTo(-MARGIN_8);
        }else{
            make.right.equalTo(_lastButton.mas_left).offset(-MARGIN_8);
        }
    }];
    _lastButton = btn;
}
//获取购物车数量
- (void)getShoppingCartNumber{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    //更新购物车数量
    if (!uid) {
        return;
    }
    
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/flow/list_count") parameters:@{@"session":session} success:^(id responseObject) {
        
        //        MMLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] isKindOfClass:[NSDictionary class]]&&[responseObject[@"status"][@"succeed"] integerValue] == 1) {
            NSString * list_count = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"list_count"]];
            if(list_count != nil){
                if ([list_count integerValue]>0) {
                    [self.badge autoBadgeSizeWithString:list_count];
                    self.badge.hidden = NO;
                }else{
                    self.badge.hidden = YES;
                }
                
            }else{
                self.badge.hidden = YES;
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
}
#pragma mark 获取商品内容详情数据
-(void)getGoosInfoData
{
    
    [self show];
    
    
    if (self.GoodsId == nil) {
        
        return ;
    }
    if(self.actId == nil){
        self.actId = @"";
    }
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/goods/getgoodsinfo") parameters:@{@"session":session,@"goods_id":self.GoodsId,@"act_id":self.actId} success:^(id responseObject) {
        
        if (![responseObject[@"status"] isKindOfClass:[NSDictionary class]]){
            [self dismiss];
            [self show:responseObject[@"info"] time:.8];
            return ;
        }
        if ([responseObject[@"status"][@"succeed"] integerValue] == 1 ) {
            
            MMLog(@"获取商品内容详情数据成功%@",@"123");
            _model = [MBGoodsModel yy_modelWithDictionary:responseObject[@"data"]];
            CGFloat strHeight = [_model.goods_name sizeWithFont:[UIFont boldSystemFontOfSize:13]  withMaxSize:CGSizeMake(UISCREEN_WIDTH-16, MAXFLOAT)].height;
            self.headViewHeight = UISCREEN_WIDTH+strHeight+120;
            if ([_model.active_remainder_time integerValue] > 0) {
                self.headViewHeight = UISCREEN_WIDTH+strHeight+135;
            }
            NSMutableArray *imageScale = [NSMutableArray array];
            for (id url in _model.goods_desc) {
                [imageScale addObject: @([UIImage getImageSizeWithURL:url].height/[UIImage getImageSizeWithURL:url].width)];
            }
            _model.imageScale = imageScale;
            
            
            [self dismiss];
            
            [self setupContentView];
            [self setupHeadView];
            [self setupGoodsTabbar];
            
        }else{
            [self dismiss];
            [self show:responseObject[@"status"][@"error_desc"] time:.8];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}

#pragma mark -- 获取商品评价数据;
-(void)getGoodsCommentsData
{
    
    MMLog(@"%u--%ld",_isCommentData,(long)_pageIndex);
    if ( _isCommentData) {
    
        if (_pageIndex != 2) {
            
            [_tableViews.lastObject.mj_footer endRefreshing];
            return;
        }
        
        [self show];
    }
    
    [MBNetworking    POSTOrigin:string(BASE_URL_root, @"/goods/comments") parameters:@{@"goods_id":self.GoodsId,@"page":s_Integer(_page)} success:^(id responseObject) {
       
        if ([self checkData:responseObject]) {
            if (_isCommentData) {
                [self dismiss];
            }
            if (_page==1) {
                 _isCommentData = YES;
                if (_tableViews.count > 0) {
                    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getGoodsCommentsData)];
                    footer.refreshingTitleHidden = YES;
                    _tableViews.lastObject.mj_footer = footer;
                }
            }else{
                [_tableViews.lastObject.mj_footer endRefreshing];
            }
            if ([responseObject[@"status"][@"succeed"] integerValue] == 1) {
                
                 MMLog(@"获取评论成功%@",@"123");
                if (_page == 1) {
                    
                    _goodCommentModel = [MBGoodCommentModel yy_modelWithDictionary:responseObject[@"data"]];
                    
                    
                    
                }else{
                    [_goodCommentModel.commentsList addObjectsFromArray:[MBGoodCommentModel yy_modelWithDictionary:responseObject].commentsList];
                }
                
                if (_isCommentData) {
                    [_tableViews.lastObject reloadData];
                }
                
                if (_tableViews.count > 0) {
                    [_tableViews.lastObject reloadData];
                }
                if ([responseObject[@"data"][@"comments_list"] count] == 0) {
                    [_tableViews.lastObject.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                _page ++;
            }
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (_isCommentData) {
            [self show:@"请求失败，请检查你的网络连接！" time:.5];
        }
        
        MMLog(@"%@",error);
    }];
    
}
#pragma mark -- 请求规格数据
-(void)getGoodsPropertyData{
    if (_isSpecData) {
         [self show];
    }

    [MBNetworking  POSTOrigin:string(BASE_URL_root, @"/goods/getgoodsspecs") parameters:@{@"goods_id":self.GoodsId} success:^(id responseObject) {
        if (_isSpecData) {
            [self dismiss];
        }
        
        if ([self checkData:responseObject]&&[responseObject[@"status"][@"succeed"] integerValue] == 1) {
             MMLog(@"获取规格数据成功%@",@"123");
            MMLog(@"获取规格数据成功%@",responseObject);
            _goodsSpecsModel = [MBGoodsSpecsRootModel yy_modelWithDictionary:responseObject[@"data"]];
            if (_isSpecData) {
                [self presentSemiType:1];
            }
//            MMLog(@"%@",_goodsSpecsModel);
            _isSpecData = false;
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:.5];
    }];
    
}
#pragma mark -- 获取商品介绍数据;
-(void)getGoodsIntroduceData
{
    
    if (_isPropertyData) {
        [self show];
    }
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/goods/getgoodsproperty") parameters:@{@"goods_id":self.GoodsId} success:^(id responseObject) {
//        MMLog(@"获取商品介绍%@",responseObject);
        if (_isPropertyData) {
            [self dismiss];
        }
        if ([self checkData:responseObject]) {
            if ([responseObject[@"status"][@"succeed"] integerValue] == 1) {
                
                _goodsPropertyArray = [NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"MBGoodsPropertyModel"];
                MMLog(@"获取商品介绍数据成功%@",@"123");
                if (_tableViews.count >0) {
                    [_tableViews[1] reloadData];
                }
                
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        if (_isPropertyData) {
            [self show:@"请求失败，请检查你的网络连接！" time:.5];
        }
        MMLog(@"%@",error);
    }];
    
    
    
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    
    if (self.islockObserveParam)return;
    
    
    CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
    
    CGFloat y = self.headViewHeight + TOP_Y  - newValue;
    
    CGFloat deltaHeight = TOP_Y;
    
    if (y <= deltaHeight) {
        _menuView.ml_y = TOP_Y;
        self.contentOffsetDictionaryM[_pageIndex] = [NSString stringWithFormat:@"%f",newValue];
        
    }else{
        _menuView.ml_y = y;
        self.contentoffSetY = newValue;
        
        if ( (int)y  != 64) {
            self.contentOffsetDictionaryM[0] = @"null";
            self.contentOffsetDictionaryM[1] = @"null";
            self.contentOffsetDictionaryM[2] = @"null";
        }
        
        self.islockObserveParam = YES;
        for (UITableView *table in _tableViews) {
            
            if (![table isEqual:_tableViews[_pageIndex]]) {
                [table setContentOffset:CGPointMake([_tableViews indexOfObject:table]*UISCREEN_WIDTH, self.contentoffSetY) animated:false];
            }
            
        }
        self.islockObserveParam = false;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---dealloc
-(void)dealloc  {
    for (UITableView *table in _tableViews) {
        [table removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == self.scrollView)
    {
        
        
        self.islockObserveParam = YES;
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        
        NSInteger pageNum = contentOffsetX / UISCREEN_WIDTH;
        MBShoppingBtn *newBtn = _goodsInfoViewArr[pageNum];
        
        MBShoppingBtn *latBtn = (MBShoppingBtn *)_lastButton;
        latBtn.clickStatus = false;
        newBtn.clickStatus = YES;
        _lastButton = newBtn;
        [UIView animateWithDuration:.25 animations:^{
            _infoItemLineView.ml_x = pageNum * (UISCREEN_WIDTH/3);
        }];
        
        UITableView* contentView = _tableViews[pageNum];
        [self.tempHeaderView removeAllSubviews];
        [self.headBackView removeFromSuperview];
        contentView.tableHeaderView = nil;
        contentView.tableHeaderView = self.headBackView;
        
        self.pageIndex = pageNum;
        self.islockObserveParam = NO;
        
        if (![self.contentOffsetDictionaryM[_pageIndex] isEqualToString:@"null"]) {
            
            contentView.contentOffset = CGPointMake(0, [self.contentOffsetDictionaryM[_pageIndex] floatValue]);
        }else{
            if (_menuView.mj_y == TOP_Y) {
                contentView.contentOffset = CGPointMake(0, self.headViewHeight);
            }else{
                contentView.contentOffset = CGPointMake(0, self.contentoffSetY);
            }
            
        }
        switch (_pageIndex) {
            case 1:
            {
                if (!_goodsPropertyArray) {
                    _isPropertyData = true;
                    [self getGoodsIntroduceData];
                }
                
            }break;
            case 2:
            {
                if (!_goodCommentModel) {
                    _page = 1;
                    _isCommentData = true;
                    [self getGoodsCommentsData];
                }
                
            }break;
                
            default:
                break;
        }
        
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.scrollView]) {
        
        if (self.lastContentOffset.x > scrollView.contentOffset.x || self.lastContentOffset.x < scrollView.contentOffset.x){
            _islockObserveParam = false;
            self.tempHeaderView.mj_y = [self.headBackView convertRect:self.headBackView.frame toView:self.view].origin.y;
            
            if (self.headBackView.superview) {
                [self.headBackView removeFromSuperview];
            }
            
            [self.tempHeaderView addSubview: self.headBackView];
            
            
            self.lastContentOffset = scrollView.contentOffset;
        }
        
    }
    
}

#pragma mark ---UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 0:return _model.imageScale.count;
        case 1:return _goodsPropertyArray.count > 0?_goodsPropertyArray.count:1;
        case 2:return _goodCommentModel.commentsList.count;
        default:return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (tableView.tag) {
        case 2: return 30;
        default: return 0;
            
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 2:{
            UIView *commonView = [[UIView alloc] init];
            commonView.frame = CGRectMake(0, 0, self.view.ml_width, 30);
            UILabel *commonLbl = [[UILabel alloc] init];
            commonLbl.frame = CGRectMake(MARGIN_8, 0, commonView.ml_width, commonView.ml_height);
            commonLbl.font = [UIFont systemFontOfSize:14];
            commonLbl.textColor = [UIColor colorWithHexString:@"323232"];
            commonLbl.text = [NSString stringWithFormat:@"评论晒单 (%@人评论)",_goodCommentModel.comment_num];
            [commonView addSubview:commonLbl];
            
            UILabel *praiseTextLbl = [[UILabel alloc] init];
            praiseTextLbl.font = [UIFont systemFontOfSize:14];
            praiseTextLbl.text = @"好评率";
            praiseTextLbl.frame = CGRectMake(commonView.ml_width - 8 - 50, 0, 50, commonView.ml_height);
            [commonView addSubview:praiseTextLbl];
            
            UILabel *praiseLbl = [[UILabel alloc] init];
            praiseLbl.font = [UIFont systemFontOfSize:14];
            praiseLbl.textColor = [UIColor colorWithHexString:@"e8465e"];
            praiseLbl.text = _goodCommentModel.good_comment_rate;
            praiseLbl.frame = CGRectMake(commonView.ml_width - 8 - 100, 0, 50, commonView.ml_height);
            [commonView addSubview:praiseLbl];
            return commonView;
        }
            
            
            
        default:return [[UIView alloc] init];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    switch (tableView.tag) {
        case 0:return  [_model.imageScale[indexPath.row] doubleValue]*UISCREEN_WIDTH;
        case 1:return  [tableView fd_heightForCellWithIdentifier:@"MBGoodsPropertyTableViewCell" cacheByIndexPath:indexPath configuration:^(MBGoodsPropertyTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
            
        }];
        case 2:return  [tableView fd_heightForCellWithIdentifier:@"MBShopTableViewCell" cacheByIndexPath:indexPath configuration:^(MBShopTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
            
        }];
        default:return 0;
    }
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    if ([cell isKindOfClass:[MBShopTableViewCell class]]) {
        
        MBShopTableViewCell *commtCell  = (MBShopTableViewCell *)cell;
        commtCell.model = _goodCommentModel.commentsList[indexPath.row];
    }else{
        
        MBGoodsPropertyTableViewCell *PropertyCell  = (MBGoodsPropertyTableViewCell *)cell;
        [PropertyCell removeUIEdgeInsetsZero];
        if (_goodsPropertyArray.count > 0) {
            PropertyCell.model = _goodsPropertyArray[indexPath.row];
            PropertyCell.isShowImage = false;
        }else{
            PropertyCell.isShowImage = true;
            
        }
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 0:  {
            MBImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBImageTableViewCell"];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBImageTableViewCell" owner:self options:nil]firstObject];
            }
            cell.url = _model.goods_desc[indexPath.row];
            return cell;
            
        }
            
        case 1:  {
            
            
            MBGoodsPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBGoodsPropertyTableViewCell" forIndexPath:indexPath];
            
            [self configureCell:cell atIndexPath:indexPath];
            
            
            return cell;
            
        }
        case 2:  {
            
            
            
            MBShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBShopTableViewCell" forIndexPath:indexPath];
            [cell uiedgeInsetsZero];
            [self configureCell:cell atIndexPath:indexPath];
            return cell;
        }
            
            
        default:return nil;
    }
}

@end
