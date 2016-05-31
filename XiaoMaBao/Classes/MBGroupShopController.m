//
//  MBGroupShopController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBGroupShopController.h"
#import "MBItemGroupTableViewCell.h"
#import "MBHomeMenuButton.h"
#import "MBBrandTableViewCell.h"
#import "MBBrandViewController.h"
#import "MBShopingViewController.h"
#import "MBTimeModel.h"
@interface MBGroupShopController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    BOOL _isbool;
    NSArray *_shuffArray;
    NSArray *_shopArray;
    NSArray *_brandArray;
    NSTimer *_m_timer;
    NSMutableArray *_shoptimeArray;
    NSMutableArray *_brandTimeArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;



@property (nonatomic, strong) UIView                     *topView;
/** 记录scrollView上次偏移的Y距离 */
@property (nonatomic, assign) CGFloat                    scrollY;
@end

@implementation MBGroupShopController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBGroup"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBGroup"];
    [_m_timer invalidate];
    _m_timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"团购";
    _top.constant   = TOP_Y;
    [self setData];
    _shoptimeArray = [NSMutableArray     array];
    _brandTimeArray = [NSMutableArray    array];

}
- (void)setData{
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/index/group_buy"] parameters:nil
               success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
                   
                   
                   if(1 == [[[responseObject valueForKey:@"status"] valueForKey:@"succeed"] intValue]){
                       [self dismiss];
                       NSDictionary *userData = [responseObject valueForKeyPath:@"data"];
                       _shuffArray = userData[@"top_ads"];
//                     NSLog(@"%@",userData);
                       _shopArray = userData[@"group_goods"];
                       _brandArray = userData[@"group_topics"];
                       [self setModel];
                        [self createTimer];
                       
                       
                   }else{
                       
                       NSString *errStr =[[responseObject valueForKey:@"status"] valueForKey:@"error_desc"];
                         NSLog(@"%@",errStr);
                         [self show:errStr time:1];
                   }
                   
               } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                   
                  [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    


}
#pragma mark - 倒计时
-(void)setModel{
    if (_isbool) {
        for (NSDictionary *dic in _brandArray ) {
            MBTimeModel *model = [[MBTimeModel alloc] init];
            model.timeNum = [dic[@"end_time"] integerValue]-(NSInteger)[[NSDate date] timeIntervalSince1970];
        
            [_brandTimeArray addObject:model];
        }
        
    }else{
        for (NSDictionary *dic in _shopArray ) {
            MBTimeModel *model = [[MBTimeModel alloc] init];
            model.timeNum = [dic[@"gmt_end_time"] integerValue]-(NSInteger)[[NSDate date] timeIntervalSince1970];
         
            [_shoptimeArray addObject:model];
        }
        
    }

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self setTableviewHeadView];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;


}
- (void)createTimer {
    
    _m_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_m_timer forMode:NSRunLoopCommonModes];
}
-(void)timerEvent{
    
   
    if (_isbool) {
        for (int i = 0 ; i<_brandArray.count; i++) {
            MBTimeModel *model = _brandTimeArray[i];
            [model countDown];
        }
    }else{
        for (int i = 0 ; i<_shopArray.count; i++) {
            MBTimeModel *model = _shoptimeArray[i];
            [model countDown];
        }
        
    }
    

    
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
}


- (UIView *)setTableviewHeadView{
    if (!_topView) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*35/75);
        NSMutableArray *UrlStringArray = [NSMutableArray array];
        for (NSDictionary *dic in _shuffArray) {
            [UrlStringArray addObject:dic[@"ad_code"]];
            
            
        }
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, view.ml_height) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
        cycleScrollView.imageURLStringsGroup = UrlStringArray;
        cycleScrollView.autoScrollTimeInterval = 3.0f;
        [view addSubview:cycleScrollView];
    return self.topView  = view;
    }
   
    return self.topView ;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MBBrandViewController *VC = [[MBBrandViewController alloc] init];
            VC.goodId =[_shuffArray[index][@"ad_link"]isNSString];
            VC.titles = _shuffArray[index][@"title"];
            [self pushViewController:VC Animated:YES];
}
- (UIView *)setupTabTuiChu{
    UIView *tabView = [[UIView alloc] init];
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.frame = CGRectMake(0, 0, self.view.ml_width, 36);
    

    MBHomeMenuButton *btn1 = [MBHomeMenuButton buttonWithType:UIButtonTypeCustom];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn1 setTitle:@"单品团" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, self.view.ml_width * 0.5, tabView.ml_height);
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(clickTuiChuTab:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tabLineView = [[UIView alloc] init];
    tabLineView.frame = CGRectMake(btn1.ml_width, 0, PX_ONE, btn1.ml_height);
    tabLineView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa"];
    [tabView addSubview:tabLineView];
    
    MBHomeMenuButton *btn2 = [MBHomeMenuButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    [btn2 setTitle:@"品牌团" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(btn1.ml_width, 0, btn1.ml_width,tabView.ml_height);
    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
  
    [btn2 addTarget:self action:@selector(clickTuiChuTab:) forControlEvents:UIControlEventTouchUpInside];
    
    [tabView addSubview:btn1];
    [tabView addSubview:btn2];
    
    
    if (_isbool) {
         btn2.currentSelectedStatus = YES;
    }else{
        btn1.currentSelectedStatus = YES;
    }
    UIView *linview1 = [[UIView alloc] init];
    linview1.backgroundColor = [UIColor grayColor];
    linview1.frame = CGRectMake(0, tabView.ml_height-2, self.view.ml_width * 0.5, 2);
    UIView *linview2 = [[UIView alloc] init];
    linview2.backgroundColor = [UIColor grayColor];
    linview2.frame = CGRectMake(0, tabView.ml_height-2, self.view.ml_width * 0.5, 2);
    [btn1 insertSubview:linview1 belowSubview:btn1.lineView];
    [btn2 insertSubview:linview2 belowSubview:btn2.lineView];

    
    return  tabView;
}

#pragma mark - 单品团和品牌团
- (void)clickTuiChuTab:(MBHomeMenuButton *)btn{
    
    btn.currentSelectedStatus = YES;
    
    if (btn.tag == 1) {
        _isbool = NO;
      MBHomeMenuButton *btn2 = (MBHomeMenuButton *)[btn.superview viewWithTag:2];
        [UIView animateWithDuration:.25 animations:^{
            btn2.currentSelectedStatus = NO;
            
        }];
       
    }else if (btn.tag == 2){
        _isbool =YES;
        [ self setModel];
        // 即将推出
        MBHomeMenuButton *btn1 = (MBHomeMenuButton *)[btn.superview viewWithTag:1];
        [UIView animateWithDuration:.25 animations:^{
            btn1.currentSelectedStatus = NO;
        }];
       
        
    }
    [_tableView reloadData];
}

#pragma mark --UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isbool) {
    return _brandArray.count;
   
    }
    return _shopArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isbool) {
        return (UISCREEN_WIDTH*35/75+30);
    }
       return 116;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        return [self setupTabTuiChu];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return 36;
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isbool) {
        MBBrandTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"MBBrandTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBBrandTableViewCell" owner:self options:nil]firstObject];
        }
//        NSNumber *end_time =_brandArray[indexPath.row][@"end_time"];
        cell.nameLable.text = [_brandArray[indexPath.row][@"title"] isNSString];
//        cell.timeStr = [NSString stringWithFormat:@"%@",end_time];
        
        [cell loadData:_brandTimeArray[indexPath.row] indexPath:indexPath];
        [cell.shopImageView sd_setImageWithURL:[NSURL URLWithString:_brandArray[indexPath.row][@"ad_code"]] placeholderImage:[UIImage imageNamed:@"placeholder_num3"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.shopImageView.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.shopImageView.alpha = 1.0f;
                             }
                             completion:nil];
            
        }];

        return cell;
    }else{
        MBItemGroupTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"MBItemGroupTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBItemGroupTableViewCell" owner:self options:nil]firstObject];
        }
        [cell loadData:_shoptimeArray[indexPath.row] indexPath:indexPath];
//       cell.timeStr = [NSString stringWithFormat:@"%@", _shopArray[indexPath.row][@"gmt_end_time"]];

        cell.shopNamelable.text = [_shopArray[indexPath.row][@"name"] isNSString];
        cell.shopIntroductionLable.text = [_shopArray [indexPath.row][@"brief"] isNSString];
        cell.presentPriceLabel.text = [_shopArray[indexPath.row][@"promote_price"] isNSString];
        cell.originalPriceLable.text = [_shopArray[indexPath.row][@"market_price"] isNSString];
        NSString *salesnum =  [_shopArray[indexPath.row][@"salesnum"] isNSString];
        cell.salesnumLabel.text = [NSString stringWithFormat:@"%@件已付款",salesnum];
        [cell.shopImageView sd_setImageWithURL:[NSURL URLWithString:_shopArray[indexPath.row][@"thumb"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.shopImageView.alpha = 0.3f;
            [UIView animateWithDuration:1
                             animations:^{
                                 cell.shopImageView.alpha = 1.0f;
                             }
                             completion:nil];
            
        }];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isbool) {
        MBBrandViewController *VC = [[MBBrandViewController alloc] init];
        VC.goodId = _brandArray[indexPath.row][@"ad_link"];
       VC.titles = [_brandArray[indexPath.row][@"title"] isNSString];
        
        
        [self pushViewController:VC Animated:YES];
    }else{
    
        MBShopingViewController *VC = [[MBShopingViewController alloc] init];
        VC.GoodsId = [_shopArray[indexPath.row][@"id"]isNSString];
        [self pushViewController:VC Animated:YES];
    }

}


@end
