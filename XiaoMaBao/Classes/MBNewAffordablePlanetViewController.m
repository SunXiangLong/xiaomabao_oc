//
//  MBNewAffordablePlanetViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewAffordablePlanetViewController.h"
#import "MBAffordableCell.h"
#import "MBAffordablePlanetCell.h"
#import "SDCycleScrollView.h"
#import "MBCollectionHeadView.h"
#import "MBShopingViewController.h"
#import "MBActivityViewController.h"
#import "MBWebViewController.h"
#import "MBGroupShopController.h"
#import "MBCategoryViewController.h"
#import "MBAffordableCategoryCell.h"
#import "MBAffordableCategoryCollectionCell.h"
#import "MBAffordablePlanetMoreCell.h"
#import "MBCollectionHeadViewTo.h"
#import "MBLoginViewController.h"
#import "MBCheckInViewController.h"
#import "MBSharkViewController.h"
@interface MBNewAffordablePlanetViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    /**
     *  广告图数组
     */
    NSArray *_bandImageArray;
    /**
     *  商品分类数组
     */
    NSArray *_category;
    /**
     *  页数
     */
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  商品数组
 */
@property (copy, nonatomic) NSMutableArray  *today_recommend_bot;
/**
 *  记录每个tablecell中 uicollcell的滑动位置
 */
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation MBNewAffordablePlanetViewController

-(NSMutableArray *)today_recommend_bot{
    
    if (!_today_recommend_bot) {
        
        _today_recommend_bot = [NSMutableArray array];
        
    }
    
    return _today_recommend_bot;
    
    
}
-(NSMutableDictionary *)contentOffsetDictionary{
    if (!_contentOffsetDictionary) {
        
        _contentOffsetDictionary  = [NSMutableDictionary dictionary
                                    ];
        
    }
    
    return _contentOffsetDictionary;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navBar removeFromSuperview];
    
    [self setData];
    
}
#pragma mark -- 请求数据
- (void)setData{
   
    [self show];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/AffordablePlanet/index2"];
    
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        if (responseObject) {
            _bandImageArray = [responseObject valueForKey:@"today_recommend_top"];
            
            [self.today_recommend_bot addObjectsFromArray:[responseObject valueForKeyPath:@"today_recommend_bot"]];
            _category = [responseObject valueForKey:@"category"];
            
            
            _tableView.tableHeaderView = ({
                NSMutableArray *urlImageArray= [NSMutableArray array];
                for (NSDictionary *dic in _bandImageArray) {
                    [urlImageArray addObject:dic[@"ad_img"]];
                }
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*35/75+95)];
                SDCycleScrollView *tableheaderView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH,UISCREEN_WIDTH*35/75) delegate:self     placeholderImage:[UIImage imageNamed:@"placeholder_num3"]];
                tableheaderView.imageURLStringsGroup = urlImageArray;
                tableheaderView.autoScrollTimeInterval = 3.0f;
                [headView addSubview:tableheaderView];
                MBCollectionHeadViewTo  *View = [MBCollectionHeadViewTo instanceView];
                
                [headView addSubview:View];
                
                @weakify(self);
                [[View.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *number) {
                    
                    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
                    if (!sid) {
                        [ self  loginClicksss];
                        return ;
                    }
                    
                    @strongify(self);
                    switch ([number integerValue]) {
                        case 0:
                        {
                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                            
                            MBCheckInViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBCheckInViewController"];
                         [self presentViewController:myView animated:YES completion:nil];

                            
                        }
                            break;
                        case 1:{
                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                            MBSharkViewController *myView = [story instantiateViewControllerWithIdentifier:@"MBSharkViewController"];
                            [self presentViewController:myView animated:YES completion:nil];
                            
                        }
                            break;
                        case 2: {
                            
                            MBWebViewController *VC = [[MBWebViewController alloc] init];
                            VC.url = URL(@"http://api.xiaomabao.com/circle/raffle");
                            VC.title =@"抽大奖";
                            VC.isloging = YES;
                            [self pushViewController:VC Animated:YES];
                        }
                            
                            break;
                        default:
                            break;
                    }
                }];
                [View mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tableheaderView.mas_bottom).offset(0);
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(95);
                }];

                headView;
            });
            

            [_tableView reloadData];

        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
        
        
    }];
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----- SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    NSInteger ad_type = [_bandImageArray[index][@"ad_type"] integerValue];
    
    
    switch (ad_type) {
        case 1: {
            MBActivityViewController *VC = [[MBActivityViewController alloc] init];
            VC.act_id = _bandImageArray[index][@"act_id"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 2: {
            
            MBShopingViewController *VC = [[MBShopingViewController alloc] init];
            VC.GoodsId = _bandImageArray[index][@"ad_con"];
            VC.title = _bandImageArray[index][@"ad_name"];
            [self pushViewController:VC Animated:YES];
        }break;
        case 3: {
            MBWebViewController *VC = [[MBWebViewController alloc] init];
            VC.url =  [NSURL URLWithString:_bandImageArray[index][@"ad_con"]];
            VC.title = _bandImageArray[index][@"ad_name"];
            VC.isloging = YES;
            
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 4: {
            
            MBGroupShopController *VC = [[MBGroupShopController alloc] init];
            VC.title = _bandImageArray[index][@"ad_name"];
            
            [self pushViewController:VC Animated:YES];
            
        }break;
        case 5: {
            
        }break;
        default: break;
    }
    
}
#pragma mark -----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return 1;
    }
    return _today_recommend_bot.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return   (UISCREEN_WIDTH-15-16)/2*213/348*4 +5*15;
    }
    return UISCREEN_WIDTH*35/75+155+10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.0001;
}
#pragma mark -----UITableViewDelagate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 50);
    [view addSubview:({
        MBCollectionHeadView  *headView = [MBCollectionHeadView instanceView];
        headView.frame = view.frame;
        if (section == 0) {
              headView.tishi.text = @"全部分类";
        }else{
             headView.tishi.text = @"精彩活动";
        }
    
        headView;
    })];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        
        static NSString *CellIdentifier = @"MBAffordableCategoryCell";
        MBAffordableCategoryCell *cell = (MBAffordableCategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[MBAffordableCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"CellIdentifier";
    MBAffordablePlanetCell *cell = (MBAffordablePlanetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[MBAffordablePlanetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    return cell;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(MBAffordablePlanetCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        MBAffordableCategoryCell *affCell = (MBAffordableCategoryCell *)cell;
        
        [affCell  setCollectionViewDataSourceDelegate:self];
        
        
    }else{
        
        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        
        [cell.showImage sd_setImageWithURL:URL(_today_recommend_bot[indexPath.item][@"ad_img"]) placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
        NSInteger index = cell.collectionView.indexPath.row;
        CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    }
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
    
    categoryVc.title = _today_recommend_bot[indexPath.row][@"act_name"];
    
    categoryVc.act_id = _today_recommend_bot[indexPath.row][@"act_id"];
    
    [self pushViewController:categoryVc Animated:YES];
    
    
}
#pragma mark --collectionViewDelagat

- (NSInteger)collectionView:(AFIndexedCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isKindOfClass:[BFIndexedCollectionView class]]) {
        
        return _category.count;
    }
    return [_today_recommend_bot[collectionView.indexPath.row][@"goods"] count]+1;
}
- (CGSize)collectionView:(AFIndexedCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[BFIndexedCollectionView class]]) {
        
         return CGSizeMake((UISCREEN_WIDTH-15-16)/2 , (UISCREEN_WIDTH-15-16)/2*213/348);
    }
    
    if (indexPath .item == [_today_recommend_bot[collectionView.indexPath.row][@"goods"] count]) {
        return  CGSizeMake(85,155);
    }
    return  CGSizeMake(120,155);
    
}
- (UICollectionViewCell *)collectionView:(AFIndexedCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[BFIndexedCollectionView class]]) {
        
        MBAffordableCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AffordableCategoryCollectionCell forIndexPath:indexPath];
        
        return cell;
       
    }
   

    
    NSInteger count =  [_today_recommend_bot[collectionView.indexPath.row][@"goods"] count];
    if (indexPath.item == count ) {
        
  
        MBAffordablePlanetMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBAffordablePlanetMoreCell" forIndexPath:indexPath];
        return cell;
    }
    
    MBAffordableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    return cell;
    
}
-(void)collectionView:(AFIndexedCollectionView *)collectionView willDisplayCell:(MBAffordableCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[BFIndexedCollectionView class]]) {
        MBAffordableCategoryCollectionCell *affCell = (MBAffordableCategoryCollectionCell *)cell;
        affCell.dataDic = _category[indexPath.item];
      
    }else{
        
        if (indexPath.item != [_today_recommend_bot[collectionView.indexPath.row][@"goods"] count]) {
            NSDictionary *dic  = _today_recommend_bot[collectionView.indexPath.row][@"goods"][indexPath.item];
            
            cell.dataDic = dic;
        }
        
    }
 

}
-(void)collectionView:(AFIndexedCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isKindOfClass:[BFIndexedCollectionView class]]) {
        
        MBCategoryViewController *VC = [[MBCategoryViewController alloc] init];
        VC.title = _category[indexPath.item][@"cat_name"];
        VC.cat_id = _category[indexPath.item][@"cat_id"];
        [self pushViewController:VC Animated:YES];
    }else{
        if (indexPath.item != [_today_recommend_bot[collectionView.indexPath.row][@"goods"] count]) {
            MBShopingViewController *shopDetailVc = [[MBShopingViewController alloc] init];
            shopDetailVc.GoodsId = _today_recommend_bot[collectionView.indexPath.row][@"goods"][indexPath.row][@"goods_id"];
            [self pushViewController:shopDetailVc Animated:YES];
        }else{
        
            MBActivityViewController *categoryVc = [[MBActivityViewController alloc] init];
            
            categoryVc.title = _today_recommend_bot[collectionView.indexPath.row][@"act_name"];
            
            categoryVc.act_id = _today_recommend_bot[collectionView.indexPath.row][@"act_id"];
            
            [self pushViewController:categoryVc Animated:YES];
        }
       
    }
  
    
    
    
}
#pragma mark --UIScrollViewDelagete
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    AFIndexedCollectionView *collectionView = (AFIndexedCollectionView *)scrollView;
    NSInteger index = collectionView.indexPath.row;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
   
}
@end
