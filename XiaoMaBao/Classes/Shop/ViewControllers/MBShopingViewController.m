//
//  MBShopingViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/29.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//
#import "MBShopingViewController.h"
#import "MBJoinCartViewController.h"
#import "NSString+BQ.h"
#import "MBShoppingBtn.h"
#import "MBShopCommon.h"
#import "MBShopCommonFrame.h"
#import "MBShopCommonTableViewCell.h"
#import "MBNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBUserDataSingalTon.h"
#import "MBSignaltonTool.h"
#import "MBLoginViewController.h"
#import <KVNProgress/KVNProgress.h>
#import "UIImageView+WebCache.h"
#import "MBShoppingCartViewController.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MBShopTableViewCell.h"
#import "MBNavigationViewController.h"
#import "DataSigner.h"
@interface MBShopingViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    
    NSTimer   *myTimer;
    NSInteger lettTimes;
    UIButton *_button;
    NSInteger _heighhh;
    NSInteger _page;
    NSMutableArray *_evaluationArray;
    NSDictionary *_dic;
    NSInteger _lengths;
    NSInteger _lesss;
    MBNavigationViewController *_nav;
}
@property (strong,nonatomic) UIScrollView *contentScrollView;
@property (strong,nonatomic) UIView *shopTitleView;
@property (strong,nonatomic) UIScrollView *headerScrollview;
@property (strong,nonatomic) UIView *shopTimeView;
@property (strong,nonatomic) UIView *shopDescView;
@property (strong,nonatomic) UILabel *shopDiscount;
@property (strong,nonatomic) UIView *shopFreightView;
@property (strong,nonatomic) UIView *shopPackageView;
@property (strong,nonatomic) UIView *shopInfoView;
@property (strong,nonatomic) UIView *tabbarView;
@property (strong,nonatomic) UIView*briefView;
@property (strong,nonatomic) NSMutableArray *infoItemViews;
@property (strong,nonatomic) UIView *infoItemLineView;
@property (strong,nonatomic) UIView *item0BriefView;
@property (strong,nonatomic) UIView *item1BriefView;
@property (strong,nonatomic) UIView *item2BriefView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *shops;
@property (strong,nonatomic) NSArray        *googBrandArray;
@property (strong,nonatomic) NSDictionary   *commentsdict;
@property (strong,nonatomic) UIPageControl  *pagecontrol;
@property (nonatomic,assign) NSInteger length;
@property (nonatomic,strong) UITableView *_shopTableView;
@property (nonatomic,strong) NSMutableArray *_shopImageArrat;
/**
 *  用来装top的scrollView
 */
@property (nonatomic, strong) UIView                     *topView;
@end

@implementation MBShopingViewController

- (NSMutableArray *)infoItemViews{
    if (!_infoItemViews) {
        _infoItemViews = [NSMutableArray array];
    }
    
    return _infoItemViews;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (myTimer == nil) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
    }

    [MobClick beginLogPageView:@"MBShopingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [myTimer invalidate];
     myTimer = nil;
    [MobClick endLogPageView:@"MBShopingViewController"];
}
- (void)viewDidAppear:(BOOL)animated{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *session = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    //更新购物车数量
    if (!uid) {
        return;
    }
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/list_count"] parameters:@{@"session":session}
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                   NSInteger status = [[[responseObject valueForKey:@"status"] valueForKey:@"succeed"] integerValue];
                   if(status == 1){
                       NSString * list_count = [NSString stringWithFormat:@"%@",[[responseObject valueForKeyPath:@"data"] valueForKey:@"list_count"]];
                       
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
                   MMLog(@"失败");
                   
               }];
}

- (void)viewDidLoad{

    [super viewDidLoad];
  
    [self.navigationController.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"address_add"]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getGoosInfo];
    
    self.contentScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([[[self.contentScrollView subviews] lastObject] frame]));
   
    _page = 1;
    _evaluationArray = [NSMutableArray array];
    [self getShareButton];
}
#pragma mark --设置分享按钮
-(void)getShareButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(UISCREEN_WIDTH - 2*NAV_BAR_W, NAV_BAR_Y, NAV_BAR_W, NAV_BAR_HEIGHT);
    [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0,0);
    [self.view addSubview:button];
    
}

-(void)share{
    
    //1、创建分享参数
    NSArray* imageArray = @[self.GoodsDict[@"goods_gallery"][0]];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.xiaomabao.com/goods-%@.html",self.GoodsDict[@"goods_id"]]];
    
    
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.GoodsDict[@"goods_name"]
                                         images:imageArray
                                            url:url
                                          title:@"小麻包母婴分享"
                                           type:SSDKContentTypeAuto];
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

#pragma mark 商品内容详情
-(void)getGoosInfo
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

    
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/goods/getgoodsinfo"] parameters:@{@"session":session,@"goods_id":self.GoodsId,@"act_id":self.actId} success:^(NSURLSessionDataTask *operation, id responseObject) {
       
         [self dismiss];
        self.GoodsDict = [responseObject valueForKeyPath:@"data"];
//      MMLog(@"商品详情---%@",self.GoodsDict);
        
        
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
        lettTimes = [[self.GoodsDict valueForKeyPath:@"active_remainder_time"] integerValue];
        //商品编码
        self.goods_sn = [self.GoodsDict valueForKeyPath:@"goods_sn"];
        self.goods_number = [self.GoodsDict valueForKeyPath:@"goods_number"];
        //品牌
        self.goods_brand = [self.GoodsDict valueForKeyPath:@"goods_name"];
        
        self.carriage_fee = [self.GoodsDict valueForKeyPath:@"carriage_fee"];
        self.salesnum = [self.GoodsDict valueForKeyPath:@"salesnum"];
       // MMLog(@"self.goods_desc---%@",self.goods_desc);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 商品内容ScrollView
            [self setupShopScrollView];
            // 商品图片
            [self setupShopImageView];
            
            // 商品标题/价格
            [self setupShopTitleView];
            // 商品时间/标签
            [self setupShopTimeView];
            // 商品套餐分类
            [self setupShopPackageView];
            // 商品介绍/规格参数/口碑
            [self setupShopInfoView];
            // 商品底部Tabbar
            [self setupShopTabbar];
        });
        
       
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
      
        [self show:@"请求失败" time:1];
          
       
        
    }];

}
#pragma mark 商品内容ScrollView
- (void)setupShopScrollView{
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - 40);
    contentScrollView.contentSize = CGSizeMake(self.GoodsDict.count *self.view.ml_width, self.view.ml_height);
    contentScrollView.delegate = self;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_contentScrollView = contentScrollView];

    
}

#pragma mark 商品图片
- (void)setupShopImageView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.ml_width, self.view.ml_width)];
    [self.contentScrollView addSubview:_topView];
    UIScrollView *headerScrollview = [[UIScrollView alloc] init];
    headerScrollview.showsHorizontalScrollIndicator = NO;
    NSArray *imageArray = [self.GoodsDict valueForKeyPath:@"goods_gallery"];
    headerScrollview.frame = CGRectMake(0, 0, self.view.ml_width, self.view.ml_width);
    headerScrollview.contentSize =CGSizeMake(self.view.ml_width *imageArray.count, 0);
    headerScrollview.scrollEnabled = YES;
    headerScrollview.pagingEnabled = YES;
    headerScrollview.delegate = self;
    for (int i =0 ; i<imageArray.count; i++) {
        UIImageView *shopImageView = [[UIImageView alloc] init];
        shopImageView.frame = CGRectMake(self.view.ml_width*i, 0, self.view.ml_width, self.view.ml_width);
        [shopImageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]]];
        [headerScrollview addSubview:shopImageView];
    }
    [self.topView addSubview:_headerScrollview = headerScrollview];
    
    _pagecontrol = [[UIPageControl alloc] init];
    _pagecontrol.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pagecontrol.currentPageIndicatorTintColor = [UIColor redColor];
    _pagecontrol.numberOfPages = imageArray.count;
    [_pagecontrol addTarget:self action:@selector(pagescrolled:) forControlEvents:UIControlEventValueChanged];
    _pagecontrol.frame = CGRectMake(headerScrollview.frame.size.width/2-20, self.view.ml_width-30, 30, 30);
    [self.contentScrollView addSubview:_pagecontrol];
    
}
//scrollview的委托方法，当滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{

    if ([scrollView isEqual:_headerScrollview]) {
        int page = _headerScrollview.contentOffset.x / 290;//通过滚动的偏移量来判断目前页面所对应的小白点
        _pagecontrol.currentPage = page;//pagecontroll响应值的变化
    }

}

-(void)pagescrolled:(UIPageControl *)pagecontrol
{
    NSInteger page = _pagecontrol.currentPage;//获取当前pagecontroll的值
    [_headerScrollview setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll
}
- (void)setupShopTitleView{
    UIView *shopTitleView = [[UIView alloc] init];
    NSInteger height = [self.goods_name sizeWithFont:[UIFont boldSystemFontOfSize:13]  withMaxSize:CGSizeMake(UISCREEN_WIDTH-16, MAXFLOAT)].height;
    shopTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerScrollview.frame) + 35, self.view.ml_width, 35+height);

    [self.contentScrollView addSubview:_shopTitleView  = shopTitleView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor colorWithHexString:@"e8465e"];
    titleLbl.numberOfLines = 0;
    titleLbl.text = self.goods_name;
    titleLbl.font = [UIFont boldSystemFontOfSize:13];
    [shopTitleView addSubview:titleLbl];

    
    // 现价
    UILabel *currentPriceLbl = [[UILabel alloc] init];
    currentPriceLbl.textColor = [UIColor colorWithHexString:@"e8465e"];
    currentPriceLbl.text = self.shop_price_formatted;
    currentPriceLbl.font = [UIFont boldSystemFontOfSize:22];
    [shopTitleView addSubview:currentPriceLbl];
    
    // 原价
    UILabel *originalPriceLbl = [[UILabel alloc] init];
    originalPriceLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    originalPriceLbl.text = self.market_price_formatted;
    originalPriceLbl.font = [UIFont systemFontOfSize:13];
    [shopTitleView addSubview:originalPriceLbl];
   // 库存
    UILabel *desclbl = [[UILabel alloc] init];
    desclbl.font = [UIFont systemFontOfSize:16];
    desclbl.textAlignment = NSTextAlignmentCenter;
    desclbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    desclbl.text = [NSString stringWithFormat:@"库存: %d件",[self.goods_number intValue]];
    [shopTitleView addSubview:desclbl];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        
    }];
    [currentPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).offset(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(35);
        
    }];
    [originalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(currentPriceLbl.mas_bottom);
        make.left.equalTo(currentPriceLbl.mas_right).offset(3);
        make.height.mas_equalTo(35);
        
    }];
    [desclbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(currentPriceLbl.mas_bottom);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(35);
    }];
    
    
}

- (void)setupShopTimeView{

    UIView *shopTimeView = [[UIView alloc] init];
    shopTimeView.frame = CGRectMake(0, CGRectGetMaxY(self.shopTitleView.frame), self.view.ml_width, 35);
    [self.contentScrollView addSubview:_shopTimeView = shopTimeView];
    
    
    //倒计时
    // 原价
    UIButton *timeBtn = [[UIButton alloc] init];
    [timeBtn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [timeBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
    NSInteger leftdays = lettTimes/(24*60*60);
    NSInteger hour = (lettTimes-leftdays*24*3600)/3600;
    NSInteger minute = (lettTimes - hour*3600-leftdays*24*3600)/60;
    NSInteger second = (lettTimes - hour *3600 - 60*minute-leftdays*24*3600);
    NSString *leftmessage;
    if (leftdays ==0 && hour == 0) {
        
        leftmessage = [NSString stringWithFormat:@"剩余%ld时%ld分%ld秒",hour,minute,second];
    }else
    {
        leftmessage = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",leftdays,hour,minute,second];
    }
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [timeBtn setTitle:leftmessage forState:UIControlStateNormal];
    timeBtn.frame = CGRectMake(8, 0, 140, shopTimeView.ml_height);
    if (lettTimes != 0) {
          [shopTimeView addSubview: _button = timeBtn];
    }
  
    
    NSString *zhekou =[NSString stringWithFormat:@"%.1f", [[self.GoodsDict valueForKeyPath:@"zhekou"] floatValue]];
    
    //添加折扣 tag
    [self setTagButton:@"eeb94f" tagName:[NSString stringWithFormat:@"%@%@",zhekou,@"折"] i:0 shopTimeView:shopTimeView];
    
    
    //是否限时特卖
    if(self.active_remainder_time > 0){
        [self setTagButton:@"e8465e" tagName:@"限时促销" i:2 shopTimeView:shopTimeView];
    }
    
    //是否包邮
    if([self.is_shipping isEqualToString:@"1"]){
        [self setTagButton:@"eeb94f" tagName:@"包邮" i:3 shopTimeView:shopTimeView];
    }
    
    // 添加分割线
    [self addBottomLineView:shopTimeView];
}

- (void)setTagButton:(NSString *)color tagName:(NSString *)tagName i:(NSInteger)i shopTimeView:(UIView *)shopTimeView{
    CGFloat tagBtnheight = 20;
    CGFloat tagY = (shopTimeView.ml_height - tagBtnheight) * 0.5;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithHexString:color];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    CGFloat width = [tagName boundingRectWithSize:CGSizeMake(MAXFLOAT, tagBtnheight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size.width + 10;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:tagName forState:UIControlStateNormal];
    
    if (i > 0) {
        btn.frame = CGRectMake(self.view.ml_width - (self.view.ml_width - CGRectGetMinX([[[shopTimeView subviews] lastObject] frame])) - (width + MARGIN_10), tagY, width, tagBtnheight);
    }else{
        btn.frame = CGRectMake(self.view.ml_width - width - MARGIN_8, tagY,width,tagBtnheight);
    }
    [shopTimeView addSubview:btn];
    
    btn.layer.cornerRadius = 3.0f;
}



- (BOOL) isBlankString:(NSString *)string type:(NSInteger)type{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0){
        return YES;
    }
    if(type == 1){
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 1){
            return YES;
        }
    }
    return NO;
}

- (void)setupShopPackageView{
    UILabel *shopPackageView = [[UILabel alloc] init];
    shopPackageView.textColor = [UIColor colorWithHexString:@"323232"];
    shopPackageView.text = @"选择：套餐分类、规格";
    shopPackageView.frame = CGRectMake(MARGIN_8, CGRectGetMaxY(self.shopTimeView.frame), self.view.ml_width, 40);
    UIImageView *imageview = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"next"];
    imageview.image = image;
    imageview.frame = CGRectMake(CGRectGetWidth(shopPackageView.frame) - image.size.width*2, 10, image.size.width, image.size.height);
    [shopPackageView addSubview:imageview];
    shopPackageView.userInteractionEnabled = YES;
    imageview.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:_shopPackageView = shopPackageView];
    UITapGestureRecognizer *ger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GuigeClick:)];
    [shopPackageView  addGestureRecognizer:ger];
    
    // 添加分割线
    [self addBottomLineView:shopPackageView];
}
#pragma -mark 选择规格
-(void)GuigeClick:(UITapGestureRecognizer *)ger
{
  
    MBJoinCartViewController *joinCartVc = [[MBJoinCartViewController alloc] init];
    joinCartVc.isBuy = NO;
    joinCartVc.isSelectGuige = YES;
    joinCartVc.goods_name = self.goods_name;
    joinCartVc.goods_id = self.GoodsId;
    joinCartVc.shop_price = self.shop_price;
    joinCartVc.showPlayImageUrl = self.showPlayImageUrl;
    joinCartVc.goods_number = [self.GoodsDict valueForKeyPath:@"goods_number"];
    joinCartVc.title = @"商品规格";
    [self.navigationController pushViewController:joinCartVc animated:YES];
}
- (void)setupShopInfoView{
    UIView *shopInfoView = [[UIView alloc] init];
    shopInfoView.frame = CGRectMake(0, CGRectGetMaxY(self.shopPackageView.frame), self.view.ml_width, 40);
    [self.contentScrollView addSubview:_shopInfoView = shopInfoView];
    
    CGFloat width = shopInfoView.ml_width / 3;
    
    NSArray *titles = @[
                        @"商品介绍",
                        @"规格参数",
                        @"麻妈口碑"
                        ];
    
    for (NSInteger i = 0 ; i < titles.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(i * width, 0, width, shopInfoView.ml_height);
        [shopInfoView addSubview:view];
        
        MBShoppingBtn *btn = [MBShoppingBtn buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, width, view.ml_height);
        [view addSubview:btn];
        [btn addTarget:self action:@selector(changeItem:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.clickStatus = YES;
        }
        
        [self.infoItemViews addObject:btn];
        
        if (i != 3) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(view.ml_width - PX_ONE, 10, PX_ONE, view.ml_height - 20);
            lineView.backgroundColor = [UIColor colorWithHexString:@"898989"];
            [view addSubview:lineView];
        }
    }
    
    UIView *infoItemLineView = [[UIView alloc] init];
    infoItemLineView.frame = CGRectMake(0, shopInfoView.ml_height - 2, width, 2);
    infoItemLineView.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    [shopInfoView addSubview:_infoItemLineView = infoItemLineView];
    
    [self addBottomLineView:shopInfoView];
    
    [self loadItemViewWithIndex:0];
    
}

- (void)loadItemViewWithIndex:(NSInteger)index{
    if (index == 0) {
        
        [self addItem0View];
        
    }else if(index == 1){
       
        [self getGoodBrand];
    }else{
     
        [self getcomments];
    }

}
#pragma mark -- 妈妈口碑
-(void)getcomments
{
    
    [self show];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary *pagination =[NSDictionary dictionaryWithObjectsAndKeys:page,@"page",@"10",@"count", nil];;
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/goods/comments"] parameters:@{@"goods_id":self.GoodsId,@"pagination":pagination} success:^(NSURLSessionDataTask *operation, id responseObject) {
//            MMLog(@"获取评论成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
            [self dismiss];
            
            NSDictionary *dic = [responseObject valueForKeyPath:@"data"];
                 _commentsdict = [responseObject valueForKeyPath:@"data"];
            [_evaluationArray addObjectsFromArray:dic[@"comments_list"]];
            if ([dic isEqualToDictionary:_dic ]) {
                [ self.contentScrollView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            _dic = [responseObject valueForKeyPath:@"data"];
            [self addItem2View];
            _page ++;
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
       
            MMLog(@"%@",error);
            [self show:@"请求失败" time:1];
            [self addItem2View];
        }];

    
    
    
}
#pragma mark －－－－－－－－商品介绍
- (void)addItem0View{
    if (self.contentScrollView.mj_footer) {
        [self.contentScrollView.mj_footer removeFromSuperview];
        self.contentScrollView.mj_footer = nil;
        _dic = nil;
    }
    
    [_item1BriefView removeFromSuperview];
    [_item2BriefView removeFromSuperview];
    [_item0BriefView removeFromSuperview];
    _item0BriefView = nil;
    
    if (_item0BriefView == nil) {
        self.briefView = [[UIView alloc] init];
        __block int imageH = 0;
        __block int heigth;
        
        __unsafe_unretained __typeof(self) weakSelf = self;
        if ([self.goods_desc isKindOfClass:[NSArray class]]) {
            
            
            for ( NSInteger i = 0; i < self.goods_desc.count; i++) {
                UIImageView *imageView = [[UIImageView alloc] init];
                NSString *urlstring = [NSString stringWithFormat:@"%@",[self.goods_desc objectAtIndex:i]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlstring]]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        
                                        CGSize size = image.size;
                                        heigth = self.view.ml_width*size.height/size.width;
                                        imageView.image = image;
                                        imageView.frame = CGRectMake(0, imageH, self.view.ml_width, heigth);
                                        [weakSelf.briefView addSubview:imageView];
                                        imageH += heigth;
                                        if(_length >= 0){
                                            _length++;
                                        }
                                        
                                        
                                        if(_length == self.goods_desc.count){
                                            _length = -1;
                                            [weakSelf addItem0View];
                                            
                                        }
                                        
                                    }];
                
                
            }
        }
        self.briefView .frame = CGRectMake(0, CGRectGetMaxY(self.shopInfoView.frame), self.view.ml_width, CGRectGetMaxY([[self.briefView .subviews lastObject] frame]));
        _item0BriefView = self.briefView ;
        [self.contentScrollView addSubview:self.briefView ];
        
    }
    
    self.contentScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_item0BriefView.frame));
   
    
}
- (void)addItem1View
{
    if (self.contentScrollView.mj_footer) {
        [self.contentScrollView.mj_footer removeFromSuperview];
        self.contentScrollView.mj_footer = nil;
        _dic = nil;
    }

    [_item0BriefView removeFromSuperview];
    [_item2BriefView removeFromSuperview];
    
    if (_item1BriefView == nil) {
        NSArray *titles = @[];
        NSMutableArray *titlearr;
        if (self.GoodsDict) {
            titlearr = [NSMutableArray arrayWithCapacity:_googBrandArray.count];
            for (NSArray  *arr in _googBrandArray) {
                NSString *name = [arr valueForKeyPath:@"name"];
                NSString *value = [arr valueForKeyPath:@"value"];
                NSString *title = [NSString stringWithFormat:@"%@: %@",name,value];
                [titlearr addObject:title];
            }
        }
        UIView *briefView = [[UIView alloc] init];
        if (titlearr.count>0) {
            for (NSInteger i = 0; i < titlearr.count; i++) {
                UILabel *titleLabel = [[UILabel alloc] init];
                titleLabel.text = titlearr[i];
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.frame = CGRectMake(8, i * 25 + MARGIN_10, self.view.ml_width - 16, 15);
                titleLabel.textColor = [UIColor colorWithHexString:@"433f3e"];
                [briefView addSubview:titleLabel];
            }
        }else{
            for (NSInteger i = 0; i < titles.count; i++) {
                UILabel *titleLabel = [[UILabel alloc] init];
                titleLabel.text = titles[i];
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.frame = CGRectMake(8, i * 25 + MARGIN_10, self.view.ml_width - 16, 15);
                titleLabel.textColor = [UIColor colorWithHexString:@"433f3e"];
                [briefView addSubview:titleLabel];
            }
            
        }
        briefView.frame = CGRectMake(0, CGRectGetMaxY(self.shopInfoView.frame), self.view.ml_width, CGRectGetMaxY([[briefView.subviews lastObject] frame]));
        
        
        
        
        [self.contentScrollView addSubview:_item1BriefView = briefView];
    }
    
    self.contentScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_item1BriefView.frame));
    
}

- (void)addItem2View{
  
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 上拉刷新
    self.contentScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getcomments];
        [weakSelf.contentScrollView.mj_footer endRefreshing];
        
    }];
    // 默认先隐藏footer
    self.tableView.mj_footer.hidden = YES;
    
    

    [_item0BriefView removeFromSuperview];
    [_item1BriefView removeFromSuperview];
    [_item2BriefView removeFromSuperview];
    _item2BriefView = nil;
    
    
    if (_item2BriefView == nil) {
        
        UIView *briefView = [[UIView alloc] init];
        UIView *commonView = [[UIView alloc] init];
        commonView.frame = CGRectMake(0, 0, self.view.ml_width, 30);
        [briefView addSubview:commonView];
        
        UILabel *commonLbl = [[UILabel alloc] init];
        commonLbl.frame = CGRectMake(MARGIN_8, 0, commonView.ml_width, commonView.ml_height);
        commonLbl.font = [UIFont systemFontOfSize:14];
        commonLbl.textColor = [UIColor colorWithHexString:@"323232"];
        NSString *comment_num = [_commentsdict valueForKeyPath:@"comment_num"];
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
        NSString *good_comment_rate = [_commentsdict valueForKeyPath:@"good_comment_rate"];
        praiseLbl.text = good_comment_rate;
        praiseLbl.frame = CGRectMake(commonView.ml_width - 8 - 100, 0, 50, commonView.ml_height);
        [commonView addSubview:praiseLbl];
        [self addBottomLineView:commonView];
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.userInteractionEnabled = YES;
       
        
        NSInteger num = 0;
        for (NSDictionary *dic in _evaluationArray) {
            NSArray *arr = dic[@"img_path"];
            NSString *str = dic[@"content"];
            NSInteger height = [str sizeWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height;
            
           
                if (arr.count>0){
                    num+=(50+height+(UISCREEN_WIDTH-40)/5+20);
              }else{
                
                num+=(50+height);
            }
            
            
        }
        
        
    
        tableView.frame = CGRectMake(0, CGRectGetMaxY(commonView.frame), self.view.ml_width, num);
        tableView.backgroundColor = [UIColor redColor];
        tableView.dataSource = self,tableView.delegate = self;
           tableView.scrollEnabled =NO;
        [briefView addSubview:_tableView = tableView];
        
        briefView.frame = CGRectMake(0, CGRectGetMaxY(self.shopInfoView.frame), self.view.ml_width, CGRectGetMaxY([[briefView.subviews lastObject] frame]));
        [self.contentScrollView addSubview:_item2BriefView = briefView];
    }
   
    self.contentScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_item2BriefView.frame));
    
}

- (void)changeItem:(MBShoppingBtn *)btn{
    
    if (btn.isClickStatus) {
        return ;
    }
    
    [self.infoItemViews enumerateObjectsUsingBlock:^(MBShoppingBtn *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MBShoppingBtn class]]) {
            obj.clickStatus = NO;
        }
    }];
    btn.clickStatus = YES;
    
    [UIView animateWithDuration:.25 animations:^{
        self.infoItemLineView.ml_x = btn.tag * btn.ml_width;
    }];
    
    [self loadItemViewWithIndex:btn.tag];
    
}

#pragma mark - 商品底部Tabbar
- (void)setupShopTabbar{
    UIView *tabbarView = [[UIView alloc] init];
    tabbarView.backgroundColor = [UIColor whiteColor];
    CGFloat height = 40;
    tabbarView.frame = CGRectMake(0, self.view.ml_height - height, self.view.ml_width, height);
    [self.view addSubview:_tabbarView = tabbarView];
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
    if ([self.GoodsDict[@"is_collect"] integerValue] == 0) {
        [collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    } else {
        [collectionBtn setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
    }
    
    
    collectionBtn.frame = CGRectMake(35, 0, 35, height);
    [collectionBtn addTarget:self action:@selector(ClickCollection:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:collectionBtn];
    
    [self addTopLineView:tabbarView];
    
    CGFloat width = (self.view.ml_width - CGRectGetMaxX(collectionBtn.frame) - MARGIN_20) * 0.5;
    CGFloat y = (tabbarView.ml_height - 30) / 2;
    
    UIButton *purchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    purchaseBtn.frame = CGRectMake(CGRectGetMaxX(collectionBtn.frame) + MARGIN_10, y, width, 30);
    purchaseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    purchaseBtn.backgroundColor = [UIColor colorWithHexString:@"eeb94f"];
    [purchaseBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    //立即购买
    [purchaseBtn addTarget:self action:@selector(goNowBuy) forControlEvents:UIControlEventTouchUpInside];
    purchaseBtn.layer.cornerRadius = 3.0;
    [tabbarView addSubview:purchaseBtn];
    
    UIButton *shopingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopingCartBtn.frame = CGRectMake(CGRectGetMaxX(purchaseBtn.frame) + MARGIN_5, y, width, 30);
    shopingCartBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shopingCartBtn.backgroundColor = [UIColor colorWithHexString:@"e8465e"];
    [shopingCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    shopingCartBtn.layer.cornerRadius = 3.0;
    [tabbarView addSubview:shopingCartBtn];
    //加入购物车
    [shopingCartBtn addTarget:self action:@selector(goJoinCart) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --云客服
- (void)service{
    
    


    NSDictionary *itemInfo = @{
                               @"title" : self.GoodsDict[@"goods_name"],
                               @"desc" : self.goods_brief,
                               @"iconUrl" : @"http://www.xiaomabao.com/images/20160224/20165902241620595989.jpg",
                               @"url" : [NSString stringWithFormat:@"http://www.xiaomabao.com/goods-%@.html",self.GoodsDict[@"goods_id"]]
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
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
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

#pragma -mark  加入购物车
- (void)goJoinCart{
    MBJoinCartViewController *joinCartVc = [[MBJoinCartViewController alloc] init];
    joinCartVc.isBuy = NO;
    joinCartVc.isSelectGuige = NO;
    joinCartVc.goods_name = self.goods_name;
    joinCartVc.goods_id = self.GoodsId;
    joinCartVc.shop_price = self.shop_price;
    joinCartVc.showPlayImageUrl = self.showPlayImageUrl;
    joinCartVc.goods_number = [self.GoodsDict valueForKeyPath:@"goods_number"];
    joinCartVc.title = @"商品规格";
    [self.navigationController pushViewController:joinCartVc animated:YES];

}
#pragma -mark -UialrtDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

    }else if (buttonIndex == 1)
    {
        //加入购物车
        MBJoinCartViewController *joinCartVc = [[MBJoinCartViewController alloc] init];
        NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
        NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
        
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/flow/addtocart"] parameters:@{@"session":dict, @"goods_id":self.GoodsId,@"number":@"1",@"spec":@""} success:^(NSURLSessionDataTask *operation, id responseObject) {
           // MMLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"status"]);
            
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            MMLog(@"失败");
        }];
        
        joinCartVc.isBuy = YES;
        joinCartVc.goods_name = self.goods_name;
        joinCartVc.goods_id = self.GoodsId;
        joinCartVc.shop_price = self.shop_price;
        [self.navigationController pushViewController:joinCartVc animated:YES];

    }
}
- (void)goNowBuy{
    MBJoinCartViewController *joinCartVc = [[MBJoinCartViewController alloc] init];
    joinCartVc.isBuy = YES;
    joinCartVc.isSelectGuige = NO;
    joinCartVc.goods_name = self.goods_name;
    joinCartVc.goods_id = self.GoodsId;
    joinCartVc.shop_price = self.shop_price;
    joinCartVc.showPlayImageUrl = self.showPlayImageUrl;
    joinCartVc.goods_number = [self.GoodsDict valueForKeyPath:@"goods_number"];
    joinCartVc.title = @"商品规格";
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
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (sid == nil && uid == nil) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

        MBLoginViewController *myViewVc = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
        myViewVc.vcType = @"shop";
        [self.navigationController pushViewController:myViewVc animated:YES];
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

//获取规格参数
-(void)getGoodBrand
{
    if (_googBrandArray) {
         [self addItem1View];
    }else{
    
        [self show];
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/goods/getgoodsproperty"] parameters:@{@"goods_id":self.GoodsId}
                   success:^(NSURLSessionDataTask *operation, id responseObject) {
                       [self dismiss];
//                       MMLog(@"规格参数成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                       _googBrandArray = [responseObject valueForKeyPath:@"data"];
                       [self addItem1View];
                       
                   } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                       [self show:@"请求失败" time:1];
                   }];
        

    }
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
-(void)timeFireMethod:(NSTimer *)timer{
    //    MMLog(@"倒计时-1");
    //倒计时-1
    
    lettTimes--;
    if (lettTimes>0) {
        NSInteger leftdays = lettTimes/(24*60*60);
        NSInteger hour = (lettTimes-leftdays*24*3600)/3600;
        NSInteger minute = (lettTimes - hour*3600-leftdays*24*3600)/60;
        NSInteger second = (lettTimes - hour *3600 - 60*minute-leftdays*24*3600);
        NSString *leftmessage;
        if (leftdays ==0 && hour == 0) {
            leftmessage = [NSString stringWithFormat:@"剩余%ld时%ld分%ld秒",hour,minute,second];
            
        }else
        {
            leftmessage = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",leftdays,hour,minute,second];
            
        }
        
        [_button setTitle:leftmessage forState:UIControlStateNormal];
    }
    
    if(lettTimes==0){
        [myTimer invalidate];
        myTimer = nil;
    }
}

#pragma mark ---UITableViewdelegate;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    return _evaluationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MBShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBShopTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBShopTableViewCell" owner:self options:nil]firstObject];
    }
    
   cell.dic = _evaluationArray[indexPath.row];
 
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =_evaluationArray[indexPath.row];
    NSString *str = dic[@"content"];
    NSInteger height = [str sizeWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height;
    
       NSArray *arr = dic[@"img_path"];

        if (arr.count>0) {
            return 50+height+(UISCREEN_WIDTH-40)/5+20;
        }
    
    
    return 50+height;
}
@end
