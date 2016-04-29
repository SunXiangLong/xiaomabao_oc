//
//  MBFreeStoreViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBFreeStoreViewController.h"
#import "MBCollectionHeadView.h"
#import "MBFreeStoreViewOneCell.h"
#import "MBFreeStoreViewTwoCell.h"
#import "MBFreeStoreViewThreeCell.h"
#import "MBActivityViewController.h"
#import "MBShopingViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
@interface MBFreeStoreViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    NSArray *_brandAarray;
    NSArray *_today_recommend_bot;
    NSArray *_categoryArray;
    NSMutableArray *_recommend_goods;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBFreeStoreViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBFreeStoreViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBFreeStoreViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
      [self.navBar removeFromSuperview];
    _recommend_goods = [NSMutableArray   array];

    [self setData];
}

#pragma mark -- 请求数据
- (void)setData{
    
    [self show];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/TaxfreeStore/index"];
    
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];

        
        
        if (responseObject) {
            _brandAarray = [responseObject valueForKey:@"today_recommend_top"];
            _today_recommend_bot = [responseObject valueForKey:@"today_recommend_bot"];
            _categoryArray = [responseObject valueForKey:@"category"];
            [_recommend_goods addObjectsFromArray:[responseObject   valueForKey:@"recommend_goods"]];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.tableHeaderView = [self setShufflingFigure];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
/**
 *  广告轮播图
 *
 *  @return
 */
- (UIView *)setShufflingFigure{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_WIDTH*33/75) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
    NSMutableArray *urimageArray = [NSMutableArray array];
    for (NSDictionary *dic  in _brandAarray) {
        [urimageArray addObject:dic[@"ad_img"]];
    }
    cycleScrollView.imageURLStringsGroup = urimageArray;
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    return cycleScrollView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
    
    
    NSInteger ad_type = [_brandAarray[index][@"ad_type"] integerValue];
    
    
    switch (ad_type) {
        case 1: {
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _brandAarray[index][@"act_id"];
            VC.title = _brandAarray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            
            MBShopingViewController *VC = [[MBShopingViewController alloc] init];
            VC.GoodsId = _brandAarray[index][@"ad_con"];
            VC.title = _brandAarray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 3: {
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:_brandAarray[index][@"ad_con"]];
            VC.title = _brandAarray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 4: {
            
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            VC.title = _brandAarray[index][@"ad_name"];
            
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 5: {
            
        }break;
        default: break;
    }
    

//    NSLog(@"%ld",index);
//    NSInteger ad_type =  [ _brandAarray[index][@"ad_type"] integerValue];
//    switch (ad_type) {
//        case 1:
//        {
//            MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
//            
//
//            categoryVc.title = _brandAarray[index][@"act_name"];
//            categoryVc.act_id = _brandAarray[index][@"act_id"];
//            [self pushViewController:categoryVc Animated:YES];
//            
//        }
//            break;
//            
//        default:
//            break;
//    }

}
#pragma mark --UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return _today_recommend_bot.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 162;
    }else if (indexPath.section == 1){
        return (UISCREEN_WIDTH/4+21)*2+1;
    }else{
        return UISCREEN_WIDTH*33/75+10;
    }
    
}
#pragma mark --- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *view = [[UIView alloc] init];
    view.ml_size = CGSizeMake(UISCREEN_WIDTH, 31);
    
    MBCollectionHeadView *childView = [MBCollectionHeadView instanceView];
    if (section ==0) {
        childView.tishi.text = @"麻包推荐";
    }else if    (section==1){
         childView.tishi.text = @"国家馆";
    }else{
         childView.tishi.text = @"HIGH逛全球";
    }
    [view addSubview:childView];
    [childView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        MBFreeStoreViewOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBFreeStoreViewOneCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBFreeStoreViewOneCell" owner:nil options:nil]firstObject];
        }
        cell.dataArray = _recommend_goods;
        cell.VC = self;
        return cell;
    }else if(indexPath.section ==1){
        MBFreeStoreViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBFreeStoreViewTwoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBFreeStoreViewTwoCell" owner:nil options:nil]firstObject];
        }
        cell.VC =self;
        cell.dataArray = _categoryArray;
         return cell;
    }else{
        MBFreeStoreViewThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBFreeStoreViewThreeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBFreeStoreViewThreeCell" owner:nil options:nil]firstObject];
        }
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:_today_recommend_bot[indexPath.row][@"ad_img"]] placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
         return cell;
    
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
        
      
        categoryVc.title = _today_recommend_bot[indexPath.row][@"act_name"];
        categoryVc.act_id = _today_recommend_bot[indexPath.row][@"act_id"];
        [self pushViewController:categoryVc Animated:YES];
    }

}

#pragma mark ---让tabview的headview跟随cell一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 31;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    _tableView.editing = NO;
    
}

@end
