//
//  MBCanulcircleHomeViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/2/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCanulcircleHomeViewController.h"
#import "CanulaCircleHeadView.h"
#import "MBCanulaCircleDetailsViewController.h"
#import "XBCollectionViewController.h"
#import "MBCanulPublishedViewController.h"
#import "MBPersonalCanulaCircleViewController.h"
#import "XWCatergoryView.h"


#import "MBFocusOneCollectionViewCell.h"
#import "MBFocusTwoCollectionViewCell.h"
#import "MBFocusCollectionViewCell.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "MBShopingViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"

#import "APService.h"
#import "MBLoginViewController.h"

#import "MBLoginView.h"
@interface MBCanulcircleHomeViewController ()<UIScrollViewDelegate, XWCatergoryViewDelegate,SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIButton *_lastButton;
    CanulaCircleHeadView *_topView;
    UIView *_headView;
    BOOL _isHeadView;
    UIButton *_labtButton;
    NSMutableArray *_focusArray;
    
    /**
     *  广告位数据
     */
    NSArray *_bannerArray;
    UICollectionView *_mainView;
    NSInteger _page;
    UILabel     *_promptLable;
    
    BOOL _isRefresh;
    
    MBLoginView *_loginView;
}
@property(nonatomic,strong) UICollectionView *controller;
@property(nonatomic,strong) UICollectionView *centerController;
@property(nonatomic,strong) UITableView *tableView;
/**
 *  底层scrollview,存放视图控制器
 */
@property(nonatomic,strong) UIScrollView *scrollView;

/**
 *  菜单栏下内容scrollview
 */
@property(nonatomic,strong) UIScrollView *contentScrollView;

@property(nonatomic,strong) NSArray *menuArray;

@end

@implementation MBCanulcircleHomeViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBCanulcircleHomeViewController"];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBCanulcircleHomeViewController"];
   


      NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    if (!_bannerArray) {
         [self setheadData];
        
    }
    if (_loginView&&sid) {
        _loginView.hidden = YES;
        [self setFocus];
    }

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _focusArray = [NSMutableArray array];
    _page =1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(is_attention:) name:@"is_attention" object:nil];
    
}
- (void)is_attention:(NSNotification *)notificat{
    NSIndexPath *indexPath = notificat.userInfo[@"indexPath"];
    NSString *is_praise =  notificat.userInfo[@"is_praise"];
    
    
    NSInteger praise = [_focusArray[indexPath.item][@"praise"] integerValue];
    
    
    if ([is_praise isEqualToString:@"1"]) {
        praise++;
    }else{
        praise--;
    }
    _focusArray[indexPath.item][@"is_praise"] = is_praise;
    _focusArray[indexPath.item][@"praise"] = [NSString stringWithFormat:@"%ld",(long)praise];
    [self.controller    reloadData];
}
#pragma mark -- 跳转登陆页
- (void)loginClicksss{
    //跳转到登录页
  
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MBLoginViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
    myView.vcType = @"mabao";
    MBNavigationViewController *VC = [[MBNavigationViewController alloc] initWithRootViewController:myView];
    [self presentViewController:VC animated:YES completion:nil];
}

#pragma mark --请求首页信息
- (void)setheadData{
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/index"];
  
    [self show];
    [MBNetworking POST:url parameters:nil
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                  NSLog(@"%@",responseObject.data);
                   
                    [self dismiss];
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                      
                       CanulaCircleHeadView *topView = [CanulaCircleHeadView   instanceView];
                       
                       [topView.recommendButton addTarget:self action:@selector(recommend:) forControlEvents:UIControlEventTouchUpInside];
                       _lastButton = topView.recommendButton;
                       [_lastButton setBackgroundColor:[UIColor colorR:213 colorG:98 colorB:97]];
                       [topView.attentionButton addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
                       [self.view addSubview:_topView = topView];
                       [topView mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.height.mas_equalTo(28);
                           make.left.mas_equalTo(0);
                           make.right.mas_equalTo(0);
                           make.top.mas_equalTo(TOP_Y);
                           
                       }];
                       
                       
                       
                       _bannerArray = responseObject.data[@"banner"];
                       self.menuArray = responseObject.data[@"talk_list"];
                       
                       
                       
                       
                       [self setScrollView];
                       
                   }else{
                        [self show:@"获取麻包圈数据失败" time:1];
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
#pragma mark --请求关注信息
- (void)setFocus{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talkattentionlist"];
    if (! sid) {
        [self loginView];
        return;
    }
    [self show];
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"page":page}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@",responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       [self dismiss];
                        if (_page==1) {
                           
                            if ([[responseObject valueForKey:@"data"] count]==0  ) {
                                //                           self.contentScrollView.hidden = YES;
                                self.scrollView.hidden = YES;
                                _promptLable = [[UILabel alloc] init];
                                _promptLable.text =  @"暂时没有关注数据";
                                _promptLable.textAlignment = 1;
                                _promptLable.font = [UIFont systemFontOfSize:14];
                                _promptLable.textColor = [UIColor colorR:146 colorG:147 colorB:148];
                                [self.view addSubview:_promptLable];
                                [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.centerX.equalTo(self.view.mas_centerX);
                                    make.centerY.equalTo(self.view.mas_centerY).offset(80);
                                }];
                                return;
                            }

                            
                           for (NSDictionary *dic in responseObject.data[@"data"]) {
                               NSMutableDictionary   *mudic  = [NSMutableDictionary dictionaryWithDictionary:dic];
                               [_focusArray addObject:mudic];
                           }
                         
                              [self setCollectionView];
                          
                         
                           _page ++;
                       }else{
                           if ([[responseObject valueForKey:@"data"] count]==0) {
                               [self.controller.mj_footer endRefreshingWithNoMoreData];
                               return ;
                           }else{
                               
                               for (NSDictionary *dic in responseObject.data[@"data"]) {
                                   NSMutableDictionary   *mudic  = [NSMutableDictionary dictionaryWithDictionary:dic];
                                   [_focusArray addObject:mudic];
                               }
                               
                               [self.controller .mj_footer endRefreshing];
                               [self.controller reloadData];
                               _page ++;
                           }
                           
                           
                       }
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   [self.controller .mj_footer endRefreshing];
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
#pragma mark -- 未登录界面
- (void)loginView{
    if (!_loginView) {
        _loginView = [MBLoginView instanceView];
        _loginView.frame = CGRectMake(0, TOP_Y+28, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y-28-49);
        [_loginView.button addTarget:self action:@selector(loginClicksss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginView];
    }else{
        _loginView.hidden = NO;
    }
   


}
#pragma mark --推荐
- (void)recommend:(UIButton *)button{
    
    if (_loginView) {
        _loginView.hidden = YES;
    }
    
    if (![_lastButton isEqual:button]) {
        if (_focusArray) {
            [_focusArray removeAllObjects];
        }
        [self setScrollView];
        [_lastButton setBackgroundColor:[UIColor colorR:221 colorG:150 colorB:128]];
        _lastButton = button;
        [_lastButton setBackgroundColor:[UIColor colorR:213 colorG:98 colorB:97]];
    }
    
}
#pragma mark --关注
- (void)attention:(UIButton *)button{
    
    
    if (![_lastButton isEqual:button]) {
        _page =1;
        [self setFocus];
        
        [_lastButton setBackgroundColor:[UIColor colorR:221 colorG:150 colorB:128]];
        _lastButton = button;
        [_lastButton setBackgroundColor:[UIColor colorR:213 colorG:98 colorB:97]];
    }
    
    
    
    
    
}
/**
 *  存放子视图控制器的容器
 */
- (void )setContentScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, lunboHeight+XWCatergoryViewHeight, UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y-28-49);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    
    for (NSInteger i = 0; i <_menuArray.count; i++) {
        XBCollectionViewController *VC = [[XBCollectionViewController alloc] init];
        CGFloat lblW = UISCREEN_WIDTH;
        CGFloat lblH = UISCREEN_HEIGHT-28-TOP_Y-49;
        CGFloat lblX = i * lblW;
        VC.view.frame = CGRectMake(lblX, 0, lblW, lblH);
        VC.VC = self;
        VC.cat_id = _menuArray[i][@"cat_id"];
        VC.dataArray = _menuArray[i][@"data"];
        [self addChildViewController:VC];
        [scrollView addSubview:VC.view];
        
        [VC addObserver:self forKeyPath:@"offsetY"options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"这是监控的文本"];
    }
    [self.scrollView addSubview:_contentScrollView = scrollView];
    scrollView.contentSize = CGSizeMake(UISCREEN_WIDTH*_menuArray.count,  0);
    
    
}

/**
 *   底层视图
 */
- (void )setScrollView{
    if (!self.scrollView) {
        
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 28+TOP_Y, UISCREEN_WIDTH, UISCREEN_HEIGHT-28-TOP_Y-49)];
        scrollview = scrollview;
        scrollview.delegate =self;
        [self.view addSubview:self.scrollView = scrollview];
        [self setScrollViewUI];
    }else{
        _promptLable.hidden = YES;
        self.controller.hidden = YES;
        self.scrollView.hidden = NO;
      
        
    }
    
    
}
/**
 *  设置广告图和菜单栏以及top上用户信息
 */
- (void)setScrollViewUI{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,lunboHeight)];
    view.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:view];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, view.ml_height) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *dic in _bannerArray) {
        [imageArray addObject:dic[@"ad_img"]];
    }
    cycleScrollView.imageURLStringsGroup = imageArray;
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    [view addSubview:cycleScrollView];
    
    self.scrollView.contentSize = CGSizeMake(0,self.scrollView.ml_height +lunboHeight+XWCatergoryViewHeight);
    
    
    [self setContentScrollView];
    
    
    
    
    
    XWCatergoryView * catergoryView = [[XWCatergoryView alloc] initWithFrame:CGRectMake(0, lunboHeight, UISCREEN_WIDTH, XWCatergoryViewHeight)];
    NSMutableArray *titArray = [NSMutableArray array];
    for (NSDictionary *dic in _menuArray) {
        
        [titArray addObject:dic[@"cat_name"]];
        
        
    }
    
    catergoryView.titles = titArray;
    catergoryView.scrollView =self.contentScrollView;
    catergoryView.delegate = self;
    catergoryView.titleColor = [UIColor colorR:134 colorG:134 colorB:134];
    catergoryView.titleSelectColor = [UIColor whiteColor];
    catergoryView.itemSpacing = 15;
    catergoryView.backEllipseColor = NavBar_Color;
    /**开启背后椭圆*/
    catergoryView.backEllipseEable = YES;
    catergoryView.scrollWithAnimaitonWhenClicked = NO;
    catergoryView.holdLastIndexAfterUpdate = YES;
    catergoryView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:_headView = catergoryView];
    [catergoryView xw_realoadData];
    
    
    
    
}

- (void)setCollectionView{
    
    if (!self.controller) {
        
        self.scrollView.hidden = NO;
        
        JCCollectionViewWaterfallLayout *flowLayout = ({
            JCCollectionViewWaterfallLayout *flowLayout =  [[JCCollectionViewWaterfallLayout alloc] init];
            flowLayout.sectionInset = UIEdgeInsetsMake(8,5,8,5);
            flowLayout.minimumLineSpacing = 8;
            flowLayout.columnCount = 1;
            flowLayout;
        });
        
        UICollectionView *collectionView = ({
            UICollectionView *collectionView   = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
            collectionView.backgroundColor =BG_COLOR;
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"MBFocusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBFocusCollectionViewCell"];
            
            [collectionView registerNib:[UINib nibWithNibName:@"MBFocusOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBFocusOneCollectionViewCell"];
            
            [collectionView registerNib:[UINib nibWithNibName:@"MBFocusTwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBFocusTwoCollectionViewCell"];
            collectionView.ml_y = TOP_Y+28;
            collectionView.ml_height -= TOP_Y;
            collectionView.ml_height -= 28;
            self.controller= collectionView;
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setFocus)];
            
            // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
            //    footer.triggerAutomaticallyRefreshPercent = 0.5;
            
            // 隐藏刷新状态的文字
            footer.refreshingTitleHidden = YES;
            
            // 设置footer
            self.controller.mj_footer = footer;
            collectionView;
            
            
        });
        
        [self.view addSubview:collectionView];
        
    }else{
         [self.controller    reloadData];
        self.scrollView.hidden = YES;
        self.controller.hidden = NO;
    }
    
}
-(NSString *)titleStr{
    return @"麻包圈";
}
-(NSString *)rightImage{
    return @"crame_image";
}
- (void)rightTitleClick{
   
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (! sid) {
        [self loginClicksss];
        return;
    }
    MBCanulPublishedViewController *VC = [[MBCanulPublishedViewController alloc] init];
    [self pushViewController:VC Animated:YES];
    
}
- (void)droPdown{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - <UICollectionViewDataSource>
- (void)catergoryView:(XWCatergoryView *)catergoryView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.item);
    
    
}

#pragma mark - <UIScrollViewDataSource>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 取出对应的子控制器
    //    int index = scrollView.contentOffset.x /UISCREEN_WIDTH;
    //
    //    NSLog(@"%d %lu",index,(unsigned long)self.childViewControllers.count);
    //
    //
    //    if (self.childViewControllers.count<index+1) {
    //        XBCollectionViewController *VC = [[XBCollectionViewController alloc] init];
    //
    //        CGFloat lblW = UISCREEN_WIDTH;
    //        CGFloat lblH = UISCREEN_HEIGHT-118-TOP_Y-XWCatergoryViewHeight;
    //        CGFloat lblX = index * lblW;
    //        VC.view.frame = CGRectMake(lblX, 0, lblW, lblH);
    //        VC.VC = self;
    //        VC.cat_id = _menuArray[index][@"cat_id"];
    //
    //
    //        VC.dataArray = [NSMutableArray arrayWithArray:_menuArray[index][@"data"]];
    //
    //
    //        [self addChildViewController:VC];
    //
    //
    //
    //        [_scrollView addSubview:VC.view];
    //
    //        [VC addObserver:self forKeyPath:@"offsetY"options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"这是监控的文本"];
    //    }
    
    //    [self.scrollView setContentOffset:CGPointMake(0, _lastOffsetY)];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if ([scrollView isEqual:_scrollView]) {
        if (offsetY>=lunboHeight) {
            _headView.mj_y = offsetY;
            
            //            _contentScrollView.mj_y = lunboHeight+XWCatergoryViewHeight - offsetY;
        }else{
            
            _headView.mj_y = lunboHeight;
            //            _contentScrollView.mj_y = lunboHeight+XWCatergoryViewHeight ;
        }
    }
    
    
    
}
#pragma mark --SDCycleScrollViewDelegate(轮播图代理方法)
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSInteger ad_type = [_bannerArray[index][@"ad_type"] integerValue];
    
    
    switch (ad_type) {
        case 1: {
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _bannerArray[index][@"act_id"];
            VC.title = _bannerArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            
            MBShopingViewController *VC = [[MBShopingViewController alloc] init];
            VC.GoodsId = _bannerArray[index][@"ad_con"];
            VC.title = _bannerArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 3: {
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:_bannerArray[index][@"ad_con"]];
            VC.title = _bannerArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 4: {
            
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            VC.title = _bannerArray[index][@"ad_name"];
            
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 5: {
            
        }break;
        default: break;
    }
    
}
#pragma mark --kVO监听(监听子控制器里UICollectionView的偏移量改变_scrollView的偏移量)
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    //只要监听的属性内容发生了变化,就会马上触发这个方法
    
    
    NSString *offsetY = change[@"new"];
    
    
    [_scrollView setContentOffset:CGPointMake(0, [offsetY floatValue])];
    
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _focusArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = _focusArray[indexPath.row][@"content"];
    CGFloat bootomView_h = 0.0;
    if ([_focusArray[indexPath.item][@"praise_list"] count]>0) {
        bootomView_h = 30.0;
    }
    CGFloat heght = [str sizeWithFont:[UIFont systemFontOfSize:13] withMaxSize:CGSizeMake(UISCREEN_WIDTH-40, MAXFLOAT)].height;
    
    if ([_focusArray[indexPath.item][@"imglist"] count]==0) {
        return CGSizeMake(UISCREEN_WIDTH-10, 160 +bootomView_h+22);
        
    }else if([_focusArray[indexPath.item][@"imglist"] count]==1 ){
        
        
        return CGSizeMake(UISCREEN_WIDTH-10, (360-204-15-40)+(UISCREEN_WIDTH-20)*40/61+heght+bootomView_h+12);
    }
    
    else{
        return CGSizeMake(UISCREEN_WIDTH-10, (360-204-15-40)+(UISCREEN_WIDTH-20)*40/61+45+heght+bootomView_h+12);
        
    }
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = _focusArray[indexPath.item];
    if ([dic[@"imglist"] count]==0 ) {
        MBFocusTwoCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBFocusTwoCollectionViewCell" forIndexPath:indexPath];
        [cell.userImageview sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.userName.text = dic[@"username"];
        cell.userDay.text = dic[@""];
        cell.userTime.text = dic[@"addtime"];
        cell.userweizhi.text = dic[@"position"];
        cell.userCenter.text = dic[@"content"];
        cell.userZhan.text = [NSString stringWithFormat:@"%@个赞",dic[@"praise"]];
        cell.userPinglun.text =  [NSString stringWithFormat:@"%@个评论",dic[@"comment"]];
        cell.talk_id = dic[@"tid"];
        cell.is_praise = dic[@"is_praise"];
        [cell setprase:dic[@"praise_list"]];
        cell.VC =self;
        cell.user_id =dic[@"user_id"];
        if ([dic[@"is_praise"] isEqualToString:@"0"]) {
            cell.dianzanButton.selected = NO;
        }else{
            
            cell.dianzanButton.selected = YES;
        }
        cell.indexPath = indexPath;
        [cell setprase:dic[@"praise_list"]];
        return cell;
        
    }else if([dic[@"imglist"] count]==1){
        
        MBFocusCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBFocusCollectionViewCell" forIndexPath:indexPath];
        
        [cell.userImageview sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.userName.text = dic[@"username"];
        cell.userDay.text = dic[@""];
        cell.userTime.text = dic[@"addtime"];
        cell.userweizhi.text = dic[@"position"];
        cell.userCenter.text = dic[@"content"];
        cell.userZhan.text = [NSString stringWithFormat:@"%@个赞",dic[@"praise"]];
        cell.userPinglun.text =  [NSString stringWithFormat:@"%@个评论",dic[@"comment"]];
        cell.talk_id = dic[@"tid"];
        cell.is_praise = dic[@"is_praise"];
        cell.indexPath = indexPath;
        cell.VC =self;
        cell.user_id =dic[@"user_id"];
        if ([dic[@"is_praise"] isEqualToString:@"0"]) {
            cell.dianzanButton.selected = NO;
        }else{
            
            cell.dianzanButton.selected = YES;
        }
        [cell setprase:dic[@"praise_list"]];
        NSDictionary *sss = dic[@"imglist"][0];
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:sss[@"origin"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.showImageView .contentMode =  UIViewContentModeScaleAspectFill;
        cell.showImageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell.showImageView .clipsToBounds  = YES;
        [cell setprase:dic[@"praise_list"]];
        return cell;
    }else{
        MBFocusOneCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBFocusOneCollectionViewCell" forIndexPath:indexPath];
        [cell.userImageview sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.userName.text = dic[@"username"];
        cell.userDay.text = dic[@""];
        cell.userTime.text = dic[@"addtime"];
        cell.userweizhi.text = dic[@"position"];
        cell.userCenter.text = dic[@"content"];
        cell.userZhan.text = [NSString stringWithFormat:@"%@个赞",dic[@"praise"]];
        cell.userPinglun.text =  [NSString stringWithFormat:@"%@个评论",dic[@"comment"]];
        cell.talk_id = dic[@"tid"];
        cell.is_praise = dic[@"is_praise"];
        cell.indexPath = indexPath;
        cell.VC =self;
        cell.user_id =dic[@"user_id"];
        if ([dic[@"is_praise"] isEqualToString:@"0"]) {
            cell.dianzanButton.selected = NO;
        }else{
            
            cell.dianzanButton.selected = YES;
        }
        
        [cell setprase:dic[@"praise_list"] image:dic[@"imglist"]];
        NSDictionary *sss = dic[@"imglist"][0];
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:sss[@"origin"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.showImageView .contentMode =  UIViewContentModeScaleAspectFill;
        cell.showImageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell.showImageView .clipsToBounds  = YES;
        return cell;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MBCanulaCircleDetailsViewController *VC = [[MBCanulaCircleDetailsViewController alloc] init];
    VC.tid = _focusArray[indexPath.item][@"tid"];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --销毁界面
-(void)dealloc{
    
    //移除监听
    for (XBCollectionViewController *VC in self.childViewControllers) {
        [VC removeObserver:self forKeyPath:@"offsetY"];
    }
}


@end
