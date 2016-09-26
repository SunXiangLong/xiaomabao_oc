//
//  MBSearchArticleViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBSearchArticleViewController.h"
#import "MBVoiceViewCell.h"
@interface MBSearchArticleViewController ()<UISearchBarDelegate>
{
    UISearchBar *_searchBar;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBSearchArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchText];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:    [UINib nibWithNibName:@"MBVoiceViewCell" bundle:nil] forCellReuseIdentifier:@"MBVoiceViewCell"];
    // Do any additional setup after loading the view from its nib.
}
- (void)searchText {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 25,UISCREEN_WIDTH - 70 , 35)];
    _searchBar.backgroundImage =  [[UIImage alloc] init];
    _searchBar.translucent = YES;
    _searchBar.tintColor = UIcolor(@"ffffff");
    _searchBar.delegate = self;
    _searchBar.translucent = YES;
    _searchBar.placeholder = @"请输入你感兴趣的文章";
    [_searchBar becomeFirstResponder];
    [_searchBar setImage:[UIImage imageNamed:@"mm_searchto"]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
    [self.view addSubview:_searchBar];
    
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:RGBACOLOR(255, 255, 255, 0.5)];
        searchField.layer.cornerRadius = 15.0f;
        searchField.textColor = UIcolor(@"ffffff");
        [searchField setValue:UIcolor(@"ffffff") forKeyPath:@"_placeholderLabel.textColor"];
        searchField.layer.masksToBounds = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureCell:(MBVoiceViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [tableView fd_heightForCellWithIdentifier:@"MBVoiceViewCell" cacheByIndexPath:indexPath configuration:^(MBVoiceViewCell *cell) {
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
    
    
    MBVoiceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBVoiceViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text = nil;
     _searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = YES;
    
    
    NSArray *subViews;
    
   
    subViews = [(_searchBar.subviews[0]) subviews];
    
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            cancelbutton.titleLabel.font = YC_YAHEI_FONT(11);
            break;
        }
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    _searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
@end
