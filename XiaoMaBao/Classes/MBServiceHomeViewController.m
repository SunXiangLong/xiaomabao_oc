//
//  MBServiceHomeViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBServiceHomeViewController.h"
#import "MBServiceShopsViewController.h"
#import "MBServiceHomeHeadView.h"
#import "MBServiceCell.h"
#import "MBServiceModel.h"
#import "MBServiceCollCell.h"
#import "MBServiceShopsTableFootView.h"
#import "MBServiceSearchViewController.h"
#import "MBServiceSubtypeViewController.h"
#import "MBServiceDetailsViewController.h"
@interface MBServiceHomeViewController ()
{
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) MBServiceModel *serviceModel;

@end

@implementation MBServiceHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = UIcolor(@"f3f3f3");
    self.collectionView.ml_height = 0;
    _page = 1;
    [self setheadData];
    [self setRefresh];
    
}
- (void)setRefresh{
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setheadData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = UIcolor(@"666666");
    
    
}
#pragma mark -- 上拉加载数据
- (void)setheadData{
    NSString *urlStr = string(BASE_URL_root, @"/service/index");
    NSDictionary *parameters = @{@"page":s_Integer(_page)};
    if (self.cat_id) {
        urlStr = string(BASE_URL_root, @"/service/c_index");
        parameters = @{@"page":s_Integer(_page),@"pid":self.cat_id};
    }
    [self show];
    [MBNetworking POSTOrigin:urlStr parameters:parameters success:^(id responseObject) {
        [self dismiss];
        [self.tableView.mj_footer endRefreshing];
        if (responseObject) {
            if (_page == 1) {
                self.serviceModel = [MBServiceModel yy_modelWithJSON:responseObject];
                [self setCollectionViewFlowLayout];
                [self.collectionView reloadData];
            }else{
                [self.serviceModel.shopsArray addObjectsFromArray:[MBServiceModel yy_modelWithJSON:responseObject].shopsArray];
            }
            if ([responseObject[@"shops"] count] == 0) {
                [self.tableView.mj_footer  endRefreshingWithNoMoreData];
                return ;
            }
            _page++;
            [self.tableView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:.8];
    }];
    
}
- (void)setCollectionViewFlowLayout{

    if (self.cat_id) {
        if (_serviceModel.categoryArray.count > 0) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            NSInteger itemspa = (UISCREEN_WIDTH - (UISCREEN_WIDTH -132 -90)/3*4 )/5;
            layout.sectionInset = UIEdgeInsetsMake(20, itemspa, 20, itemspa);
            layout.minimumLineSpacing = 25;
            layout.minimumInteritemSpacing = itemspa;
            layout.itemSize = CGSizeMake((UISCREEN_WIDTH - 90-132)/3,(UISCREEN_WIDTH - 90-132)/3);
            self.collectionView.collectionViewLayout = layout;
            self.collectionView.scrollEnabled = NO;
            NSInteger cont = _serviceModel.categoryArray.count/4;
            NSInteger num = _serviceModel.categoryArray.count%4;
            if (num != 0) {
                cont ++;
            }
            if (cont == 1) {
                self.collectionView.ml_height = cont*(UISCREEN_WIDTH - 90-132)/3 + 40;
            }else{
                self.collectionView.ml_height = cont*(UISCREEN_WIDTH - 90-132)/3 + 40 + (cont - 1)*25;
            }
            
            
        }
        
        return;
    }
    if (_serviceModel.categoryArray.count > 0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(20, 45, 20, 45);
        layout.minimumLineSpacing = 25;
        layout.minimumInteritemSpacing =  66;
        layout.itemSize = CGSizeMake((UISCREEN_WIDTH - 90-132)/3,(UISCREEN_WIDTH - 90-132)/3);
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.scrollEnabled = NO;
        NSInteger cont = _serviceModel.categoryArray.count/3;
        NSInteger num = _serviceModel.categoryArray.count%3;
        if (num != 0) {
            cont ++;
        }
        if (cont == 1) {
            self.collectionView.ml_height = cont*(UISCREEN_WIDTH - 90-134)/3 + 40;
        }else{
            self.collectionView.ml_height = cont*(UISCREEN_WIDTH - 90-134)/3 + 40 + (cont - 1)*25;
        }
        
        
    }

}
-(NSString *)titleStr{
    return  self.cat_name?:@"麻包服务";
}
- (NSString *)rightImage{
    return @"search_image";
}

- (void)rightTitleClick{
    MBServiceSearchViewController *searchViewController = [[MBServiceSearchViewController alloc] init:true];
    searchViewController.hotSearches = @[@""];
    searchViewController.hotSearchStyle =  PYHotSearchStyleColorfulTag;
    searchViewController.searchBar.placeholder = @"请输入要搜索服务名称";
    searchViewController.hotSearchHeader.text = @"大家都在搜";
    
    MBNavigationViewController *nav = [[MBNavigationViewController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"mm_navGroundImage"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:nav  animated:NO completion:nil];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    if ([segue.identifier isEqualToString:@"MBServiceHomeViewController"]) {
        MBServiceHomeViewController *VC = (MBServiceHomeViewController *)segue.destinationViewController;
        VC.cat_id = _serviceModel.categoryArray[indexPath.item].cat_id;
        VC.cat_name = _serviceModel.categoryArray[indexPath.item].cat_name;
    }else if([segue.identifier isEqualToString:@"MBServiceShopsViewController"]){
        MBServiceShopsViewController *VC = (MBServiceShopsViewController *)segue.destinationViewController;
        VC.shop_id = _serviceModel.shopsArray[indexPath.section].shop_id;
        VC.title = _serviceModel.shopsArray[indexPath.section].shop_name;
    
    }else if([segue.identifier isEqualToString:@"MBServiceSubtypeViewController"]) {
    
        MBServiceSubtypeViewController *VC = (MBServiceSubtypeViewController *)segue.destinationViewController;
        VC.cat_id = _serviceModel.categoryArray[indexPath.item].cat_id;
        VC.cat_name = _serviceModel.categoryArray[indexPath.item].cat_name;
    }
    
}

#pragma mark -- 更多服务
- (void)moreService:(UITapGestureRecognizer *)ges{
    if ([ges.view isKindOfClass:[MBServiceHomeHeadView class]]) {
    
        [self performSegueWithIdentifier:@"MBServiceShopsViewController" sender:[NSIndexPath indexPathForRow:0 inSection:ges.view.tag]];
        return;
    }
    NSUInteger section = ges.view.tag;
    _serviceModel.shopsArray[section].isMoreService =  !_serviceModel.shopsArray[section].isMoreService;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ges.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (_serviceModel.shopsArray[section].isMoreService) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }else{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!_serviceModel) {
       return 0;
    }
    return _serviceModel.shopsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = _serviceModel.shopsArray[section].productArray.count - 2;
    
    if (num >0 ) {
        if (_serviceModel.shopsArray[section].isMoreService) {
            
            return _serviceModel.shopsArray[section].productArray.count;
        }
      
        return 2;
    }
    
    
    return _serviceModel.shopsArray[section].productArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return  72;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 88;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MBServiceHomeHeadView *headView = [MBServiceHomeHeadView instanceView];
    headView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 72);
    headView.model = _serviceModel.shopsArray[section];
    headView.tag = section;
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreService:)]];
    return headView;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MBServiceShopsTableFootView *footView = [MBServiceShopsTableFootView instanceView];
    footView.tag = section;
    footView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 40);
    NSInteger num = _serviceModel.shopsArray[section].productArray.count - 2;
    if (num > 0) {
        if (_serviceModel.shopsArray[section].isMoreService) {
            num = 0;
            footView.name.text = [NSString stringWithFormat:@"查看其它%ld个服务",num];
            footView.image.image = [UIImage imageNamed:@"dupward_image"];
        }else{
            footView.name.text = [NSString stringWithFormat:@"查看其它%ld个服务",num];
            footView.image.image = [UIImage imageNamed:@"down_image"];
        }
        [footView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreService:)]];
    }else{
        footView.name.text = @"暂无更多服务";
        footView.image.image = [UIImage imageNamed:@""];
    }
    return footView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceCell" forIndexPath:indexPath];
    cell.model = _serviceModel.shopsArray[indexPath.section].productArray[indexPath.row];
    [cell removeUIEdgeInsetsZero];
    return cell;
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBServiceDetailsViewController *VC  = [[MBServiceDetailsViewController alloc] init];
    VC.product_id = _serviceModel.shopsArray[indexPath.section].productArray[indexPath.row].product_id;
    [self pushViewController:VC Animated:true];


}

#pragma mark --UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_serviceModel) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _serviceModel.categoryArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    MBServiceCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBServiceCollCell" forIndexPath:indexPath];
    cell.model = _serviceModel.categoryArray[indexPath.row];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cat_id) {
        [self performSegueWithIdentifier:@"MBServiceSubtypeViewController" sender:indexPath];
        return;
    }
    [self performSegueWithIdentifier:@"MBServiceHomeViewController" sender:indexPath];
    
}
@end
