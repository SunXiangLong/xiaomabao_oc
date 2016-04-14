//
//  MBSmallCategoryViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/2.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSmallCategoryViewController.h"
#import "MBSmallCategoryCollectionViewCell.h"
#import "MBNetworking.h"
#import "MBCategoryViewTwoCell.h"
#import "UIImageView+WebCache.h"
#import "MBShopingViewController.h"
#import "MBLoginViewController.h"


#import "MBPickerViewController.h"
#import "MBCameraViewController.h"
#import "MBBabyViewController.h"
#import "MBCanulcircleHomeViewController.h"
#import "MBCanulPublishedViewController.h"
#import "MBNewHomeViewController.h"
@interface MBSmallCategoryViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSTimer *myTimer;
    NSInteger lettTimes;
    UIButton *timeBtn;
    
    NSString *_sortStr;
    NSString *_orderStr;
    BOOL _isSelBtn;
    NSMutableArray *_btnArray;
    NSInteger _selBtnIndex;
    NSMutableArray *_array;
    NSMutableArray *_array1;
    UIButton *_button;
    NSString *_GoodsId;
}
@property (strong,nonatomic) UICollectionView *collectionView;
@property (assign,nonatomic) NSInteger page;
@property (assign,nonatomic) NSInteger isPage;
@property (assign,nonatomic) BOOL havingGoods;
@end

@implementation MBSmallCategoryViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [myTimer invalidate];
    myTimer = nil;
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (myTimer == nil) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
    }
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"PageOne"];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];

    _isSelBtn = YES;
    // 初始化数据
    [self setupData];
    
    UICollectionViewFlowLayout *flowLayout = ({
        UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (UISCREEN_WIDTH - 9)/2.0;
        flowLayout.itemSize = CGSizeMake(width,(UISCREEN_WIDTH-29)/2+98);
        flowLayout.sectionInset = UIEdgeInsetsMake(3,3,3,3);
        
        flowLayout;
    });
  
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    if ([self.type isEqualToString:@"3"]||!self.type ) {
        if (self.type) {
            
        }else {
            
            
           collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-49) collectionViewLayout:flowLayout];
            
        }
        
    }
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"MBCategoryViewTwoCell" bundle:nil] forCellWithReuseIdentifier:@"MBCategoryViewTwoCell"];
    collectionView.backgroundColor = BG_COLOR;
    collectionView.ml_y = TOP_Y;
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    collectionView.ml_height -= TOP_Y;
    self.collectionView = collectionView;
    
   
    if (self.SearchArray.count>0) {
    
        if (self.collectionView.superview == nil) {
            [self.view addSubview:self.collectionView];
        }else{
        
        }
    }else{
        
        
        [self requestData];
    }

      __unsafe_unretained __typeof(self) weakSelf = self;

    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
           [self requestData];
            // 结束刷新
            [weakSelf.collectionView.mj_footer endRefreshing];
//            [weakSelf.collectionView reloadData];
     
    }];
    // 默认先隐藏footer
    self.collectionView.mj_footer.hidden = YES;
    // 显示商品头部View
    if ([self.type isEqualToString:@"3"]||!self.type ) {
        if (self.type) {
            flowLayout.headerReferenceSize = CGSizeMake(self.view.ml_width, (self.view.ml_width - 6)*334/750+70);
        }else {
        
           
            flowLayout.headerReferenceSize = CGSizeMake(self.view.ml_width, (self.view.ml_width)*334/750);
      
        }
        
    }

    if ([self.type isEqualToString:@"2" ]|| [self.type isEqualToString:@"3"]) {
        if (myTimer == nil) {
            myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
        }
    }
    //收藏品牌按钮
    if ([self.type isEqualToString:@"1"]) {
      
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(self.view.ml_width - NAV_BAR_W, NAV_BAR_Y, NAV_BAR_W, NAV_BAR_HEIGHT);
        [button addTarget:self action:@selector(CollectBrand:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button = button];
        
    }
    
}


- (void)setupData{
    if (_SearchArray) {
        self.page =2;
    }else{
       self.page = 1;
    }
 
    self.goodsDicts     = [NSMutableArray array];
    self.shop_price     = [NSMutableArray array];
    self.market_price   = [NSMutableArray array];
    self.short_name     = [NSMutableArray array];
    self.goods_thumb    = [NSMutableArray array];
    _array = [NSMutableArray array];
    _array1 = [NSMutableArray array];
    _btnArray = [NSMutableArray array];
    _sortStr = @"salesnum";
    _orderStr = @"desc";
    self.havingGoods = NO;
}
- (void)CollectBrand:(UIButton *)button{

    
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
    
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"user/collectBrands/create"] parameters:@{@"session":session,@"brand_id":_GoodsId}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   
                   // NSLog(@"成功---responseObject%@",[responseObject valueForKeyPath:@"data"]);
                   [self show:@"加入收藏成功" time:1];
                   [_button setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"%@",error);
                [self show:@"请求失败！" time:1];
               }];


}
- (void)requestData{
    [self show];
    NSString *havingGoods = self.havingGoods == YES ? @"true" : @"false";
    if ([self.type isEqualToString:@"1"]) {//按品牌
       
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/listGoodsByBId"] parameters:@{@"brand_id":self.ID, @"Order":_orderStr, @"Sort":_sortStr,@"Having_goods":havingGoods,@"page_now":@(self.page)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self dismiss];
            if (self.collectionView.superview == nil) {
                [self.view addSubview:self.collectionView];
            }
            
            NSDictionary *dict = [responseObject valueForKeyPath:@"data"];
            NSLog(@"%@",dict);
            
            
            NSString *is  = dict[@"is_collect"];
            _GoodsId = dict[@"id"];
            if ([is integerValue] == 0) {
                [_button setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            } else {
                [_button setImage:[UIImage imageNamed:@"nice"] forState:UIControlStateNormal];
            }
            
            
            if ([[dict valueForKeyPath:@"goods"] count] == 0) {
                
                 [_collectionView.mj_footer endRefreshingWithNoMoreData];
                 return ;
            }else{
                self.page += 1;
            }
            
            if ([[dict valueForKeyPath:@"goods"] isKindOfClass:[NSArray class]]) {
                [self.goodsDicts addObjectsFromArray:[dict valueForKeyPath:@"goods"]];
            }
            

            self.shop_price =[NSMutableArray array];
            self.market_price =[NSMutableArray array];
            self.short_name =[NSMutableArray array];
            self.goods_thumb =[NSMutableArray array];
            self.goods_id =[NSMutableArray array];
            self.salesnum =[NSMutableArray array];

            for (NSDictionary *dict in self.goodsDicts) {
                [self.shop_price addObject:[dict valueForKeyPath:@"shop_price"]];
                [self.market_price addObject:[dict valueForKeyPath:@"market_price"]];
                [self.short_name addObject:[dict valueForKeyPath:@"short_name"]];
                [self.goods_thumb addObject:[dict valueForKeyPath:@"goods_thumb"]];
                [self.goods_id addObject:[dict valueForKeyPath:@"goods_id"]];

            }
            
             [self.collectionView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
                  [self show:@"请求失败" time:1];
        }];
    }else if ([self.type isEqualToString:@"0"])//按分类
    {
        
        NSString *page = [NSString stringWithFormat:@"%ld",self.page];
        NSDictionary *pagination = @{@"page":page, @"count":@"20"};
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/listGoodsByCId"] parameters:@{@"cat_id":self.ID, @"order":_orderStr, @"sort":_sortStr,@"having_goods":havingGoods,@"page_now":page,@"pagination":pagination} success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self dismiss];
            if (self.collectionView.superview == nil) {
                [self.view addSubview:self.collectionView];
            }
            
            NSDictionary *dict = [responseObject valueForKeyPath:@"data"];
            NSLog(@"%@",dict);
            NSArray *arr = [dict valueForKeyPath:@"goods"];
            self.titleStr = [dict valueForKey:@"name"];
            
            if ([arr count] == 0) {
               
                [_collectionView.mj_footer  endRefreshingWithNoMoreData];
                return ;
            }else{
                self.page += 1;
            }
            
           
        [self.goodsDicts addObjectsFromArray:[dict valueForKeyPath:@"goods"]];
            
            
          
            self.shop_price =[NSMutableArray array];
            self.market_price =[NSMutableArray array];
            self.short_name =[NSMutableArray array];
            self.goods_thumb =[NSMutableArray array];
            self.goods_id =[NSMutableArray array];
            self.shop_price_formatted =[NSMutableArray array];
            self.market_price_formatted =[NSMutableArray array];

            for (NSDictionary *dict in self.goodsDicts) {
                [self.shop_price addObject:[dict valueForKeyPath:@"shop_price"]];
                [self.market_price addObject:[dict valueForKeyPath:@"market_price"]];
                [self.short_name addObject:[dict valueForKeyPath:@"goods_name"]];
                [self.goods_thumb addObject:[dict valueForKeyPath:@"goods_thumb"]];
                [self.goods_id addObject:[dict valueForKeyPath:@"goods_id"]];
                [self.shop_price_formatted addObject:[dict valueForKeyPath:@"shop_price_formatted"]];
                [self.market_price_formatted addObject:[dict valueForKeyPath:@"market_price_formatted"]];

            }
             [self.collectionView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
           [self show:@"请求失败" time:1];
        }];
        
        
    }else if ([self.type isEqualToString:@"3"] ||[self.type isEqualToString:@"2"])//最新特卖
    {
       
        NSString  *page  = [NSString stringWithFormat:@"%ld",self.page];
        NSDictionary *pagination = @{@"page":page, @"count":@"10"};
       
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getGoodsListByActId"] parameters:@{@"act_id":self.act_id, @"order":_orderStr, @"sort":_sortStr,@"having_goods":havingGoods,@"pagination":pagination} success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [self dismiss];
          
            if (self.collectionView.superview == nil) {
                [self.view addSubview:self.collectionView];
            }else{
                }
            
            NSDictionary *dict = [responseObject valueForKeyPath:@"data"];
            

            
            NSArray *array = [dict valueForKeyPath:@"goods_list"];
            
            self.act_img = [dict valueForKeyPath:@"act_img"];
            self.act_name = [dict valueForKeyPath:@"act_name"];
            self.titleStr = self.act_name;
            NSString *str1 = [array lastObject][@"brief"];
            NSString *str2 = [self.goodsDicts lastObject][@"brief"];
            if ([str1 isEqualToString:str2]) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }else{
                self.page += 1;
            }
            [self.goodsDicts addObjectsFromArray:[dict valueForKeyPath:@"goods_list"]];
            self.shop_price =[NSMutableArray array];
            self.market_price =[NSMutableArray array];
            self.short_name =[NSMutableArray array];
            self.goods_thumb =[NSMutableArray array];
            self.goods_id =[NSMutableArray array];
            self.salesnum =[NSMutableArray array];
            self.current_server_time = [dict valueForKeyPath:@"current_server_time"];
            self.end_time =  [dict valueForKeyPath:@"end_time"];
            for (NSDictionary *dict in self.goodsDicts) {
                [self.shop_price addObject:[dict valueForKeyPath:@"shop_price"]];
                [self.market_price addObject:[dict valueForKeyPath:@"market_price"]];
                [self.short_name addObject:[dict valueForKeyPath:@"name"]];
                [self.goods_thumb addObject:[dict valueForKeyPath:@"thumb"]];
                [self.goods_id addObject:[dict valueForKeyPath:@"id"]];
                [self.salesnum addObject:[dict valueForKeyPath:@"sales_num"]];
            }
                [self.collectionView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self show:@"请求失败" time:1];
            
        }];   

    }else if(!_type&&!_SearchArray) {//免税数据
    
        
        NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    
        
       self.topButton = @"no";
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getCrossBorder"] parameters:@{@"page":page} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
             [self dismiss];
            if (self.collectionView.superview == nil) {
                [self.view addSubview:self.collectionView];
            }else{
            }
            NSArray *arr = [responseObject valueForKeyPath:@"data"];
            self.act_img = [responseObject valueForKeyPath:@"img"];
         
            
            
            if (arr.count==0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
                
                return;
            }
       
            NSMutableArray *indexArray = [NSMutableArray array];
            if (_array1.count==0) {
                 [_array1 addObjectsFromArray:arr];
                [self.collectionView reloadData];
            }else{
                
                for (NSInteger i =_array1.count; i<arr.count+_array1.count; i++) {
                    [indexArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                }
                
                [_array1 addObjectsFromArray:arr];
                [self.collectionView insertItemsAtIndexPaths:indexArray];
            
            }
            
           
            
            self.page += 1;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self show:@"请求失败" time:1];
        }];
    }else{//搜索数据
        NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
        NSDictionary *params = @{@"keywords":self.title,@"having_goods":@"false"};
        NSDictionary *pagination = @{@"coun":@"20",@"page":page};
        [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"search"] parameters:@{@"filter":params,@"pagination":pagination} success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
            [self dismiss];
          
            NSArray *arr = [responseObject valueForKeyPath:@"data"];
            
            
            if (arr.count==0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
                
                return;
            }else{
                NSString *str1 = [arr lastObject][@"goods_id"];
                NSString *str2 = [self.SearchArray lastObject][@"goods_id"];
                
                
                
                
                if ([str1 isEqualToString:str2]) {
                    
                    
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                    
                    return;
                }
            
            }
          
            NSMutableArray *indexArray = [NSMutableArray array];
            for (NSInteger i =_SearchArray.count; i<arr.count+_SearchArray.count; i++) {
                [indexArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            }
            
             [_SearchArray addObjectsFromArray:arr];
            [self.collectionView insertItemsAtIndexPaths:indexArray];
  
            
            self.page += 1;
                    
                    
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self show:@"请求失败" time:1];
        }];

    
    }
}
-(void)timeFireMethod:(NSTimer *)timer{
    //    NSLog(@"倒计时-1");
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
        
        [timeBtn setTitle:leftmessage forState:UIControlStateNormal];
    }
    
    if(lettTimes==0){
        [myTimer invalidate];
        myTimer = nil;
    }
}
- (void)leftTitleClick{
   MBNewHomeViewController *VC = [[MBNewHomeViewController alloc] init];
   
    [self pushViewController:VC Animated:YES];

}
#pragma mark --UICollectionViewdelegate
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
//    return insets;
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if ([self.type isEqualToString:@"3"]||!self.type ) {
            
            
            if (self.type) {
                UIView *choniceView = [[UIView alloc] init];
                choniceView.backgroundColor = [UIColor whiteColor];
                choniceView.frame = CGRectMake(0, 0, self.view.ml_width, 28);
                [reusableview addSubview:choniceView];
                
                NSArray *titles = @[
                                    @"销量",
                                    @"价格",
                                    @"折扣",
                                    @"只看有货"
                                    ];
                
                CGFloat width = self.view.ml_width / titles.count;
                
                for (NSInteger i = 0; i < titles.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i;
                    [btn setTitleColor:[UIColor colorWithHexString:@"323333"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(i * width, 0, width, choniceView.ml_height);
                    if(i == 0){
                        if (_selBtnIndex == 0) {
                            if (_isSelBtn) {
                                [btn setImage:[UIImage imageNamed:@"saleMinus"] forState:UIControlStateNormal];
                            } else {
                                [btn setImage:[UIImage imageNamed:@"saleAdd"] forState:UIControlStateNormal];
                            }
                        } else if (_selBtnIndex == 2 || _selBtnIndex == 1) {
                            [btn setImage:nil forState:UIControlStateNormal];
                        }
                        
                    }
                    else if (i == 1) {
                        if (_selBtnIndex == 1) {
                            if (_isSelBtn) {
                                [btn setImage:[UIImage imageNamed:@"saleMinus"] forState:UIControlStateNormal];
                            } else {
                                [btn setImage:[UIImage imageNamed:@"saleAdd"] forState:UIControlStateNormal];
                            }
                        } else if (_selBtnIndex == 2 || _selBtnIndex == 0) {
                            [btn setImage:nil forState:UIControlStateNormal];
                        }
                    }else if (i == 2){
                        if (_selBtnIndex == 1 || _selBtnIndex == 0) {
                            [btn setImage:nil forState:UIControlStateNormal];
                        } else if (_selBtnIndex == 2){
                            if (_isSelBtn) {
                                [btn setImage:[UIImage imageNamed:@"saleMinus"] forState:UIControlStateNormal];
                            } else {
                                [btn setImage:[UIImage imageNamed:@"saleAdd"] forState:UIControlStateNormal];
                            }
                        }
                    }else if (i == 3){
                        UIView *redView = [[UIView alloc] init];
                        redView.frame = CGRectMake(5, (btn.ml_height - 8) * 0.5, 8, 8);
                        redView.layer.cornerRadius = 4;
                        if(self.havingGoods){
                            redView.backgroundColor = [UIColor redColor];
                        }
                        
                        [btn addSubview:redView];
                        
                        UIView *redBorderView = [[UIView alloc] init];
                        redBorderView.frame = CGRectMake(3, (btn.ml_height - 12) * 0.5, 12, 12);
                        redBorderView.layer.cornerRadius = 6;
                        redBorderView.layer.borderColor = [UIColor grayColor].CGColor;
                        redBorderView.layer.borderWidth = 1.0;
                        redBorderView.backgroundColor = [UIColor clearColor];
                        [btn addSubview:redBorderView];
                    }
                    btn.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN_8, 0, 0);
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn setTitle:titles[i] forState:UIControlStateNormal];
                    
                    [btn addTarget:self action:@selector(clickLimitBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                    [choniceView addSubview:btn];
                    
                    if (i != titles.count - 1) {
                        UIView *lineView = [[UIView alloc] init];
                        lineView.frame = CGRectMake(CGRectGetMaxX(btn.frame) - PX_ONE, 4, PX_ONE,(btn.ml_height - 8));
                        lineView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
                        [choniceView addSubview:lineView];
                    }
                }
                
                UIImageView *shopImgView = [[UIImageView alloc] init];
                shopImgView.frame = CGRectMake(3, CGRectGetMaxY(choniceView.frame) + 3, self.view.ml_width - 6, (self.view.ml_width - 6)*334/750);
                if (self.act_img) {
                    NSURL *url = [NSURL URLWithString:self.act_img];
                    [shopImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num1"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        shopImgView.alpha = 0.3f;
                        [UIView animateWithDuration:1
                                         animations:^{
                                             shopImgView.alpha = 1.0f;
                                         }
                                         completion:nil];
                    }];
                    
                }else{
                    
                    shopImgView.image = [UIImage imageNamed:@"placeholder_num1"];
                }
                [reusableview addSubview:shopImgView];
                
                UIView *priceView = [[UIView alloc] init];
                priceView.backgroundColor = [UIColor whiteColor];
                priceView.frame = CGRectMake(3, CGRectGetMaxY(shopImgView.frame), self.view.ml_width - 6, 32);
                [reusableview addSubview:priceView];
                
                UILabel *priceTagView = [[UILabel alloc] init];
                priceTagView.textColor = [UIColor whiteColor];
                priceTagView.textAlignment = NSTextAlignmentCenter;
                priceTagView.font = [UIFont systemFontOfSize:14];
               
                
                priceTagView.frame = CGRectMake(10, (priceView.ml_height - 18) * 0.5, 38, 18);
                [priceView addSubview:priceTagView];
                
                priceTagView.layer.masksToBounds = YES;
                priceTagView.layer.cornerRadius = 3.0f;
                
                //特卖名称
                UILabel *priceBriefLbl = [[UILabel alloc] init];
                priceBriefLbl.textColor = [UIColor colorWithHexString:@"524c4a"];
                priceBriefLbl.textAlignment = NSTextAlignmentCenter;
                priceBriefLbl.frame = CGRectMake(MARGIN_10, 0, 120, priceView.ml_height);
                priceBriefLbl.font = [UIFont systemFontOfSize:12];
                if (self.favourable_name) {
                    priceBriefLbl.text = self.favourable_name;
                }else{
                    priceBriefLbl.text = self.act_name;
                }
                [priceView addSubview:priceBriefLbl];
                
                //倒计时
                timeBtn = [[UIButton alloc] init];
                [timeBtn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
                timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
                [timeBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
                lettTimes =[self.end_time integerValue] - [self.current_server_time integerValue];
                
                
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
                [timeBtn setTitle:leftmessage forState:UIControlStateNormal];
                timeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                timeBtn.frame = CGRectMake(CGRectGetMaxX(priceBriefLbl.frame), 0, 180, 30);
                timeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
                [priceView addSubview:timeBtn];
                return reusableview;
                
            }else {
                
                UIImageView *shopImgView = [[UIImageView alloc] init];
                shopImgView.frame = CGRectMake(0,0, self.view.ml_width , self.view.ml_width*334/750);
                if (self.act_img) {
                    NSURL *url = [NSURL URLWithString:self.act_img];
                    [shopImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num1"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        shopImgView.alpha = 0.3f;
                        [UIView animateWithDuration:1
                                         animations:^{
                                             shopImgView.alpha = 1.0f;
                                         }
                                         completion:nil];
                    }];
                    
                }else{
                    
                    shopImgView.image = [UIImage imageNamed:@"placeholder_num1"];
                }
                [reusableview addSubview:shopImgView];
                
                return reusableview;
                }
            
        }
    }
                return nil;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.SearchArray.count>0) {
        return self.SearchArray.count;
    }else if(_array1.count>0){
        return _array1.count;
        
    }else{
    return self.goodsDicts.count;
    
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
 MBCategoryViewTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBCategoryViewTwoCell" forIndexPath:indexPath];
//    MBSmallCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBSmallCategoryCollectionViewCell" forIndexPath:indexPath];
    if (self.SearchArray.count >indexPath.row && self.SearchArray.count>0) {
//        cell.shop_price.text = [[self.SearchArray objectAtIndex:indexPath.item] valueForKeyPath:@"shop_price_formatted"];
//        cell.market_price.text = [[self.SearchArray objectAtIndex:indexPath.item] valueForKeyPath:@"market_price_formatted"];
//        cell.describeLabel.text = [[self.SearchArray objectAtIndex:indexPath.item] valueForKeyPath:@"goods_name"];
//        cell.describeLabel.numberOfLines = 2;
//        cell.SaleNumber.text = [NSString stringWithFormat:@"总销量:%@",[[self.SearchArray objectAtIndex:indexPath.item] valueForKey:@"salesnum"]];
       
        cell.shop_price.text = [[self.SearchArray objectAtIndex:indexPath.item] valueForKeyPath:@"shop_price_formatted"];
        cell.describeLabel.text = [[self.SearchArray objectAtIndex:indexPath.item] valueForKeyPath:@"goods_name"];
        NSString *urlstr = [[self.SearchArray objectAtIndex:indexPath.item] valueForKeyPath:@"goods_thumb"];
        NSURL *url = [NSURL URLWithString:urlstr];
        
        [cell.showImageVIew sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.showImageVIew.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.showImageVIew.alpha = 1.0f;
                             }
                             completion:nil];
        }];

    }else if(_array1.count >indexPath.row && _array1.count>0){
    
        
        NSString *str = [[_array1 objectAtIndex:indexPath.item] valueForKeyPath:@"shop_price"];
        cell.shop_price.text = str;
        cell.describeLabel.text = [[_array1  objectAtIndex:indexPath.item] valueForKeyPath:@"goods_name"];
//        cell.shop_price.text = [NSString stringWithFormat:@"￥%@",str];
//        cell.market_price.text = [[_array1 objectAtIndex:indexPath.item] valueForKeyPath:@"market_price"];
//        cell.describeLabel.text = [[_array1  objectAtIndex:indexPath.item] valueForKeyPath:@"goods_name"];
//        cell.describeLabel.numberOfLines = 2;
//        cell.SaleNumber.text = [NSString stringWithFormat:@"总销量:%@",[[_array1  objectAtIndex:indexPath.item] valueForKeyPath:@"salesnum"]];
        NSString *urlstr = [[_array1 objectAtIndex:indexPath.item] valueForKeyPath:@"goods_thumb"];
        NSURL *url = [NSURL URLWithString:urlstr];
        [cell.showImageVIew sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.showImageVIew.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.showImageVIew.alpha = 1.0f;
                             }
                             completion:nil];
        }];

        
    }
    else
    {
        cell.shop_price.text = [NSString stringWithFormat:@"￥%@",[self.shop_price objectAtIndex:indexPath.item]];
        cell.describeLabel.text =  [NSString stringWithFormat:@"%@",[self.short_name objectAtIndex:indexPath.item]];
//        cell.shop_price.text = [NSString stringWithFormat:@"￥%@",[self.shop_price objectAtIndex:indexPath.item]];
        if (!self.shop_price) {
           cell.shop_price.text = [NSString stringWithFormat:@"￥"];
            
        }
//        
//        cell.market_price.text = [NSString stringWithFormat:@"%@",[self.market_price objectAtIndex:indexPath.item]];
//        cell.describeLabel.text = [NSString stringWithFormat:@"%@",[self.short_name objectAtIndex:indexPath.item]];
//        cell.describeLabel.numberOfLines = 2;
//        if (self.salesnum.count>indexPath.row) {
//            
//            cell.SaleNumber.text = [NSString stringWithFormat:@"总销量:%@",[self.salesnum objectAtIndex:indexPath.item]];
//        }
        [cell.showImageVIew sd_setImageWithURL:[self.goods_thumb objectAtIndex:indexPath.item] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.showImageVIew.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.showImageVIew.alpha = 1.0f;
                             }
                             completion:nil];
        }];

    }
    return cell;
    
}

- (void)clickLimitBtn:(UIButton *)btn{
    
    if (_isSelBtn) {
        _isSelBtn = NO;
    } else {
        _isSelBtn = YES;
    }
    
    if ([_orderStr isEqualToString:@"desc"]) {
        _orderStr = @"asc";
    } else {
        _orderStr = @"desc";
    }
    if (btn.tag == 3) {
        _selBtnIndex = 3;
        // 只看有货
        if (self.havingGoods) {
            self.havingGoods = NO;
        } else {
            self.havingGoods = YES;
        }
        
        [self requestData];
    } else if (btn.tag == 0) {
        _selBtnIndex = 0;
        _sortStr = @"salesnum";
        self.page = 1;
        [self.goodsDicts removeAllObjects];
        
        
        [self requestData];
    }  else if (btn.tag == 1) {
        _selBtnIndex = 1;
        _sortStr = @"shop_price";
        self.page = 1;
        [self.goodsDicts removeAllObjects];
        [self requestData];
    }  else if (btn.tag == 2) {
        _selBtnIndex = 2;
        _sortStr = @"zhekou";
        self.page = 1;
        [self.goodsDicts removeAllObjects];
        [self requestData];
    }
    


}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];

    
    if (!self.goods_id) {
        if (self.SearchArray) {
             shopDetailVc.GoodsId =  self.SearchArray[indexPath.row][@"goods_id"];
        }else{
         shopDetailVc.GoodsId =  _array1[indexPath.row][@"goods_id"];
        }
   
        
    }else{
    
    shopDetailVc.GoodsId = self.goods_id[indexPath.item];
    }
    
    shopDetailVc.actId = self.act_id;

    
    [self.navigationController pushViewController:shopDetailVc animated:YES];
}
- (NSString *)titleStr{
    
//    return self.title?:self.act_name?:
    if (self.title) {
        
        return self.title;
    }else{
        if (self.act_name) {
            return self.act_name;
        }else{
            if (!_type) {
                return @"免税";

            }else{
               return @"哈罗闪品牌特卖专场";
            }
         
        }
    }
    
}
- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray {
    for (UIImage * image in imageArray) {
        NSLog(@"%@",image);
    }
}
@end
