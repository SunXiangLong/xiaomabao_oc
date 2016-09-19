//
//  MBArticleViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBArticleViewController.h"
#import "MBArticleViewCell.h"
#import "MBVideoDetailsViewController.h"
#import "MBSearchArticleViewController.h"
#import "MBPhoneticDetailViewController.h"
@interface MBArticleViewController ()<UISearchBarDelegate>
{
    NSInteger _page ;
    NSString *_keyword;
 
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSMutableArray *dataArr;
@end

@implementation MBArticleViewController

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }

    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page   = 1;
    _keyword = @"";
    [self loadData];
    [self searchText];
    [self.tableView registerNib:    [UINib nibWithNibName:@"MBArticleViewCell" bundle:nil] forCellReuseIdentifier:@"MBArticleViewCell"];
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
}
- (void)loadData{
    [self show];
    
    [MBNetworking POSTOrigin:string(BASE_URL_root, @"/voice/voice_list") parameters:@{@"page":s_Integer(_page),@"keyword":_keyword} success:^(id responseObject) {
        [self dismiss];
        
         [self.tableView .mj_footer endRefreshing];
        
        if ([responseObject count] >0) {
            [self.dataArr addObjectsFromArray:responseObject];
            
            _page++;
           
        }else{
        
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
           
        }
        MMLog(@"%@",self.dataArr);
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];

}
- (void)searchText {
    UISearchBar    *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 25,UISCREEN_WIDTH -100 , 35)];
    searchBar.backgroundImage =  [UIImage saImageWithSingleColor: [UIColor clearColor]];
    searchBar.translucent = YES;
    searchBar.tintColor = UIcolor(@"ffffff");
    searchBar.delegate = self;
    searchBar.translucent = YES;
    searchBar.placeholder = @"请输入你感兴趣的问题";
    [searchBar setImage:[UIImage imageNamed:@"mm_searchto"]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
    [self.view addSubview:searchBar];
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:RGBACOLOR(255, 255, 255, 0.5)];
        searchField.layer.cornerRadius = 15.0f;
        searchField.textColor = UIcolor(@"ffffff");
        [searchField setValue:UIcolor(@"ffffff") forKeyPath:@"_placeholderLabel.textColor"];
        searchField.layer.masksToBounds = YES;
    }
}
-(void)rightTitleClick{
    
    MBVideoDetailsViewController *VC = [[MBVideoDetailsViewController alloc] init];
    [self pushViewController:VC Animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureCell:(MBArticleViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO;
    cell.dataDic = self.dataArr[indexPath.section];
    }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"MBArticleViewCell" cacheByIndexPath:indexPath configuration:^(MBArticleViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
        
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MBArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBArticleViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBPhoneticDetailViewController *VC = [[MBPhoneticDetailViewController alloc] init];
    VC.ID = _dataArr[indexPath.section][@"id"];
    [self pushViewController:VC Animated:YES];

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.dataArr removeAllObjects];
    _keyword = searchBar.text;
    _page = 1;
    [self loadData];
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
}

@end
