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
#import "MBGoodsEvaluationViewController.h"
#import "MBNavigationViewController.h"
#import "DataSigner.h"
#import "MBGoodsPropertyTableViewCell.h"
#import "RatingBar.h"
@interface MBGoodsDetailsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_goodsName;
    UILabel *_shopPriceFormatted;
    UILabel *_marketPriceFormatted;
    UILabel *_goods_number;
    UIView  *_infoItemLineView;
    NSTimer *_myTimer;
    UIButton  *_lastButton;
   
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
//    [_myTimer invalidate];
//    _myTimer = nil;
    
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
    
    [self getGoodsIntroduceData];
    [self getGoodsPropertyData];
    
    
    
    
    
    
}
#pragma mark --设置收藏按钮
-(void)getShareButton{
    //收藏按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(UISCREEN_WIDTH - 2*NAV_BAR_W, NAV_BAR_Y, NAV_BAR_W, NAV_BAR_HEIGHT);
    if (_model.is_collect) {
        [button setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        
        
    } else {
        [button setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
    }

    [button addTarget:self action:@selector(ClickCollection:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0,0);
    [self.navBar addSubview:button];
    
}
-(NSString *)rightImage{
    return @"share";
}
-(void)rightTitleClick{
    [self goodShare];

}

- (void)setupContentView
{
    self.islockObserveParam = YES;
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.delaysContentTouches = NO;
    [self.view addSubview:scrollView];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(UISCREEN_WIDTH * 3, 0);
    scrollView.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT- TOP_Y - 50 );
    
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
    
    
    

    
    
    _tableViews = @[table1,table2];
    for (UITableView *table in _tableViews) {
        [table addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(scrollView)];
        table.scrollIndicatorInsets = UIEdgeInsetsMake(self.headViewHeight + 40, 0, 0, 0);
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
    _goodsName.textColor = [UIColor colorWithHexString:@"000000"];
    _goodsName.numberOfLines = 0;
    _goodsName.text = _model.goods_name;
    _goodsName.font = [UIFont boldSystemFontOfSize:16];
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
    

//    if ([_model.active_remainder_time integerValue] > 0) {
//        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
//        UIButton *timeBtn = [[UIButton alloc] init];
//        [timeBtn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
//        timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
//        [timeBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
//        _lettTimes = [_model.active_remainder_time intValue];
//        NSInteger leftdays = [_model.active_remainder_time integerValue]/(24*60*60);
//        NSInteger hour = ([_model.active_remainder_time integerValue]-leftdays*24*3600)/3600;
//        NSInteger minute = ([_model.active_remainder_time integerValue] - hour*3600-leftdays*24*3600)/60;
//        NSInteger second = ([_model.active_remainder_time integerValue] - hour *3600 - 60*minute-leftdays*24*3600);
//        NSString *leftmessage;
//        if (leftdays ==0 && hour == 0) {
//            
//            leftmessage = [NSString stringWithFormat:@"剩余%ld时%ld分%ld秒",hour,minute,second];
//        }else
//        {
//            leftmessage = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",leftdays,hour,minute,second];
//        }
//        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [timeBtn setTitle:leftmessage forState:UIControlStateNormal];
//        [view addSubview: _timerButton =timeBtn];
//        
//        [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_marketPriceFormatted.mas_bottom);
//            make.left.mas_equalTo(8);
//            make.width.mas_equalTo(140);
//            make.height.mas_equalTo(35);
//        }];
//        
//    }
    
    
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
        make.top.equalTo(_shopPriceFormatted.mas_bottom).offset(5);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(PX_ONE);
    }];
    _goods_number = [[UILabel alloc] init];
    _goods_number.textColor = [UIColor colorWithHexString:@"323232"];
    _goods_number.text = [NSString stringWithFormat:@"库存: %@件",_model.goods_number];
    [view addSubview:_goods_number];
    [_goods_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.mas_equalTo(MARGIN_8);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    UIView *lineView11 = [[UIView alloc] init];
    lineView11.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    [view addSubview:lineView11];
    [lineView11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goods_number.mas_bottom);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(PX_ONE);
    }];
    
    UILabel *shopPackageView = [[UILabel alloc] init];
    shopPackageView.userInteractionEnabled = YES;
    shopPackageView.textColor = [UIColor colorWithHexString:@"323232"];
    shopPackageView.text = @"选择：套餐分类、规格";
    [view addSubview:shopPackageView];
    [shopPackageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView11.mas_bottom);
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
    [view layoutIfNeeded];
     self.headViewHeight = CGRectGetMaxY(lineView1.frame);
    if (_model.is_collect) {
        
        UILabel *commentsLabel = [[UILabel alloc] init];
        commentsLabel.userInteractionEnabled = YES;
        commentsLabel.textColor = [UIColor colorWithHexString:@"323232"];
        
        commentsLabel.text = [NSString stringWithFormat:@"评价（%@）",_model.comments.total];
        [view addSubview:commentsLabel];
        [commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView1.mas_bottom);
            make.left.mas_equalTo(MARGIN_8);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        UIImageView *commentsImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"next"];
        commentsImageView.image = image;
        commentsImageView.userInteractionEnabled = YES;
        [commentsLabel addSubview:commentsImageView];
        [commentsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(13);
            make.left.mas_equalTo(UISCREEN_WIDTH - 8 - image.size.width*2);
            make.size.mas_equalTo(image.size);
        }];
        
        UITapGestureRecognizer *commentsGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreEvaluation)];
        [commentsLabel  addGestureRecognizer:commentsGer];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(commentsLabel.mas_bottom);
            make.right.left.mas_equalTo(0);
            make.height.mas_equalTo(PX_ONE);
        }];
        
        
        
        
        UILabel *user_name = [[UILabel alloc] init];
        user_name.font  = SYSTEMFONT(14);
        user_name.textColor = UIcolor(@"696969");
        user_name.text = _model.comments.comment.user_name;
        [view addSubview:user_name];
        [user_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.left.mas_equalTo(10);

        }];
        
        UILabel *comment_time = [[UILabel alloc] init];
        comment_time.font  = SYSTEMFONT(14);
        comment_time.textColor = UIcolor(@"696969");
        comment_time.text = _model.comments.comment.comment_time;
        [view addSubview:comment_time];
        [comment_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.right.mas_equalTo(-10);
            
        }];
        
        [view layoutIfNeeded];
        RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(user_name.frame)+10, 0, 100, 20)];
        bar.ml_centerY = user_name.ml_centerY;
        bar.enable = NO;
        bar.starNumber = [_model.comments.comment.rank integerValue];
        [view addSubview:bar];
        
        
        
        UILabel *content = [[UILabel alloc] init];
        content.numberOfLines = 0;
        content.font  = SYSTEMFONT(12);
        content.textColor = UIcolor(@"696969");
        content.text = _model.comments.comment.content;
        [view addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(user_name.mas_bottom).offset(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            
        }];
    

        UIView *lineView3 = [[UIView alloc] init];
        lineView3.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [view addSubview:lineView3];
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(content.mas_bottom).offset(10);
            make.right.left.mas_equalTo(0);
            make.height.mas_equalTo(PX_ONE);
        }];
        
        [view layoutIfNeeded];
        self.headViewHeight = CGRectGetMaxY(lineView3.frame);
        
    }
   
    
    view.mj_h =  self.headViewHeight;
    headView.mj_h =  self.headViewHeight + 40;
    
    UIView *goodsInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headViewHeight+TOP_Y, UISCREEN_WIDTH, 40)];
    goodsInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_menuView = goodsInfoView];
    
    
    _titles = @[
                @"商品介绍",
                @"规格参数",
                ];
    CGFloat width = UISCREEN_WIDTH / _titles.count;
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
        
        if (i != 1) {
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

/**更多评价数据*/
-(void)moreEvaluation{
    MBGoodsEvaluationViewController *VC = [[MBGoodsEvaluationViewController alloc] init];
    VC.GoodsId = self.GoodsId;
    [self pushViewController:VC Animated:true];
}
#pragma mark - 商品底部Tabbar
- (void)setupGoodsTabbar{
    UIView *tabbarView = [[UIView alloc] init];
    tabbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: tabbarView];
    [tabbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [self addTopLineView:tabbarView];
    
    
    //小能移动客服
    UIButton *customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [customerBtn setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
    [customerBtn setTitle:@"客服" forState:UIControlStateNormal];
    customerBtn.titleLabel.font  = SYSTEMFONT(12);
    [customerBtn setTitleColor:UIcolor(@"686d6f") forState:UIControlStateNormal];
    [customerBtn addTarget:self action:@selector(service) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:customerBtn];
    [customerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(0);
        make.width.mas_equalTo(UISCREEN_WIDTH/4 - PX_ONE);
    }];
    [customerBtn layoutIfNeeded];
    [customerBtn setButtonContentCenter:10];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIcolor(@"dfe1e9");
    [tabbarView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.left.equalTo(customerBtn.mas_right);
        make.width.mas_equalTo(PX_ONE);
    }];
    
    UIButton *goodsCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsCarBtn setImage:[UIImage imageNamed:@"shoppingCart"] forState:UIControlStateNormal];
    [goodsCarBtn setTitleColor:UIcolor(@"686d6f") forState:UIControlStateNormal];
    [goodsCarBtn setTitle:@"购物车" forState:UIControlStateNormal];
    goodsCarBtn.titleLabel.font  = SYSTEMFONT(12);
    [tabbarView addSubview:goodsCarBtn];
    [goodsCarBtn addTarget:self action:@selector(careClick) forControlEvents:UIControlEventTouchUpInside];
    [goodsCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(lineView.mas_right);
        make.width.mas_equalTo(UISCREEN_WIDTH/4);
    }];
    [goodsCarBtn layoutIfNeeded];
     [goodsCarBtn setButtonContentCenter:10];
       [goodsCarBtn.imageView layoutIfNeeded];
    self.badge = [CustomBadge customBadgeWithString:@"0" withStyle:[BadgeStyle defaultStyle]];
    self.badge.center =  CGPointMake(34+25, 10);
    self.badge.size  = CGSizeMake(20, 20);
    self.badge.hidden = true;
    [goodsCarBtn.imageView.superview addSubview:self.badge];

    
    //立即购买
    UIButton *purchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    purchaseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    purchaseBtn.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    [purchaseBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [purchaseBtn addTarget:self action:@selector(purchaseGoods:) forControlEvents:UIControlEventTouchUpInside];
    //    purchaseBtn.layer.cornerRadius = 3.0;
    [tabbarView addSubview:purchaseBtn];
    [purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.equalTo(goodsCarBtn.mas_right);
    }];
   
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
//-(void)timeFireMethod:(NSTimer *)timer{
//    
//    
//    _lettTimes--;
//    if (_lettTimes > 0) {
//        NSInteger leftdays = _lettTimes/(24*60*60);
//        NSInteger hour = (_lettTimes-leftdays*24*3600)/3600;
//        NSInteger minute = (_lettTimes - hour*3600-leftdays*24*3600)/60;
//        NSInteger second = (_lettTimes - hour *3600 - 60*minute-leftdays*24*3600);
//        NSString *leftmessage;
//        if (leftdays ==0 && hour == 0) {
//            leftmessage = [NSString stringWithFormat:@"剩余%ld时%ld分%ld秒",hour,minute,second];
//            
//        }else
//        {
//            leftmessage = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",leftdays,hour,minute,second];
//            
//        }
//        
//        [_timerButton setTitle:leftmessage forState:UIControlStateNormal];
//    }
//    
//    if(_lettTimes==0){
//        [_myTimer invalidate];
//        _myTimer = nil;
//    }
//}
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
    [btn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
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

-(void)careClick{
    
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
    imagev.inventoryNum =  [_model.goods_number integerValue];
    WS(weakSelf)
    imagev.getCarData = ^(){
        
        
    [weakSelf getShoppingCartNumber];

    };
    [self presentSemiView:imagev];
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
//        make.top.equalTo(_goods_number.mas_bottom);
        make.centerY.equalTo(_shopPriceFormatted.mas_centerY);
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
            [self getShareButton];
            CGFloat strHeight = [_model.goods_name sizeWithFont:[UIFont boldSystemFontOfSize:13]  withMaxSize:CGSizeMake(UISCREEN_WIDTH-16, MAXFLOAT)].height;
            self.headViewHeight = UISCREEN_WIDTH+strHeight+120 + 40 + (_model.is_collect?60:0);
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
        default:return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    switch (tableView.tag) {
        case 0:return  [_model.imageScale[indexPath.row] doubleValue]*UISCREEN_WIDTH;
        case 1:return  [tableView fd_heightForCellWithIdentifier:@"MBGoodsPropertyTableViewCell" cacheByIndexPath:indexPath configuration:^(MBGoodsPropertyTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
            
        }];
       
        default:return 0;
    }
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    
        
        MBGoodsPropertyTableViewCell *PropertyCell  = (MBGoodsPropertyTableViewCell *)cell;
        [PropertyCell removeUIEdgeInsetsZero];
        if (_goodsPropertyArray.count > 0) {
            PropertyCell.model = _goodsPropertyArray[indexPath.row];
            PropertyCell.isShowImage = false;
        }else{
            PropertyCell.isShowImage = true;
            
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
            
            
        default:return nil;
    }
}

@end
