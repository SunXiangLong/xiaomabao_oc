//
//  MBServiceSearchViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/4.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBServiceSearchViewController.h"
#import "MBServiceSearchCell.h"
#import "MBServiceModel.h"
#import "MBTopView.h"
#import "MBServiceDetailsViewController.h"
@interface MBServiceSearchViewController ()
{
    NSArray *_meunArray;
    
}
@property (strong,nonatomic) NSString *searchText;
@property (assign, nonatomic) NSInteger page;
@property (strong,nonatomic) MBTopView *topView;
@property (strong,nonatomic) NSString *sort;
@end

@implementation MBServiceSearchViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = true;
}
-(MBTopView *)topView{
    if  (!_topView){
        _topView = [MBTopView instanceView];
        [self addBottomLineView:_topView.sortView];
        WS(weakSelf)
        _topView.block = ^(id value){
            
            if ([value isKindOfClass:[NSString class]]) {
                if ([value isEqualToString:@"back"]) {
                    weakSelf.topView.serviceViewNull.hidden = true;
                    [weakSelf.view bringSubviewToFront:weakSelf.baseSearchTableView];
                    weakSelf.searchBar.text = @"";
                    [weakSelf.searchBar becomeFirstResponder];
                    return ;
                }
                weakSelf.sort = value;
                weakSelf.page = 1;
                [weakSelf.topView.productModelArray removeAllObjects];
                [weakSelf.topView.tableView reloadData];
                [weakSelf searchData];
            }else{
                MBServiceDetailsViewController *VC  = [[MBServiceDetailsViewController alloc] init];
                VC.product_id = ((ServiceProductsModel *)value).product_id;
                [weakSelf pushViewController:VC Animated:true];
            }
        };
        [self.view addSubview:_topView];
        [self.view sendSubviewToBack:self.topView];
        
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
    
    }
    return _topView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    
    _sort = @"normal";
    [self.navBar removeFromSuperview];

    [self refreshData];
    
    WS(weakSelf)
    self.didSearchBlock =  ^(MBSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        weakSelf.page = 1;
        weakSelf.searchText = searchText;
        [weakSelf.topView.productModelArray removeAllObjects];
        [weakSelf.topView.tableView reloadData];
        [weakSelf searchData];
    
    };

}

- (void)refreshLoading{
    
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = UIcolor(@"666666");
    self.topView .tableView.mj_footer = footer;
}
-(void)refreshData{
    [self show];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/service/search_keys"];
    
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        
        MMLog(@"%@",responseObject);
        if (responseObject) {
            self.baseSearchTableView.hidden = false;
            self.hotSearches = responseObject[@"data"];
            self.hotSearchStyle =  PYHotSearchStyleColorfulTag;
            self.searchBar.placeholder = @"请输入要搜索服务名称";
            self.hotSearchHeader.text = @"大家都在搜";
           
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
}
-(void)searchData{
    [self show];
    [MBNetworking   POSTOrigin:string(BASE_URL_root, @"/service/search") parameters:@{@"page":s_Integer(_page),@"search_key":self.searchText,@"sort":_sort} success:^(id responseObject) {
       
        [self dismiss];
        if (_page == 1) {
            [self refreshLoading];
            if ([responseObject[@"data"] count] == 0){
                self.topView.hidden = false;
                [self.view bringSubviewToFront:self.topView];
                self.topView.serviceViewNull.hidden = false;
            }
        }else{
        [self.topView.tableView .mj_footer endRefreshing];
        }
        
        if (responseObject) {
            [self.topView.productModelArray addObjectsFromArray:[NSArray modelDictionary:responseObject modelKey:@"data" modelClassName:@"ServiceProductsModel"]];
            
        }
        
        if ([responseObject[@"data"] count] == 0){
            [self.topView.tableView.mj_footer  endRefreshingWithNoMoreData];
            return ;
        }
        _page++;
        self.topView.hidden = false;
        self.topView.tableView.tableFooterView = [[UIView alloc] init];
        [self.view bringSubviewToFront:self.topView];
        [self.topView.tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败" time:.8];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
