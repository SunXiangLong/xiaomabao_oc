//
//  MBMoreCirclesController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMoreCirclesController.h"
#import "MBMycircleTableViewCell.h"
#import "MBLoginViewController.h"
#import "MBDetailsCircleController.h"
@interface MBMoreCirclesController ()<UITextFieldDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UISearchBar *_SearchBar;
    NSArray *_OneLevel;
    NSInteger _number;
    
    

    NSMutableArray *_searchArray;
    NSMutableArray *_is_joinArray;
    NSMutableArray *_search_is_joinArray;
    
    /**
     *  判断是否是搜索的tableView
     */
    BOOL _isSearchTableView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewTwo;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOne;
@property (strong, nonatomic) UITableView *searchTableView;
@property (nonatomic ,strong) UISearchBar *SearchBar;
@end

@implementation MBMoreCirclesController
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBMoreCirclesController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBMoreCirclesController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    self.navBar = nil;
    
   
    _searchArray = [NSMutableArray array];
    _is_joinArray = [NSMutableArray array];
    _search_is_joinArray = [NSMutableArray array];
    
    [self.MinView addSubview:self.SearchBar];
    [self.MinView addSubview:self.searchTableView];
    [self setCircleData];
    
    
    @weakify(self);
    [[self.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *num) {
        @strongify(self);
    
        if ([num integerValue] == 0) {
            self.SearchBar.hidden = YES;
        }else{
            self.SearchBar.hidden = NO;
            
        }
    }];
}
#pragma mark -- 请求圈子数据
- (void)setCircleData{
    
    [self show];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/get_all_cat"];
   
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];

        if (responseObject) {
           _OneLevel = [responseObject valueForKeyPath:@"data"];
            for (NSDictionary *dic in _OneLevel) {
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *child_cats in dic[@"child_cats"]) {
                    
                   
                   NSString *is_join=  [NSString stringWithFormat:@"%@",child_cats[@"is_join"]];
                    
                    if ([is_join isEqualToString:@"1"]) {
                        [arr addObject:@1];
                    }else{
                        [arr addObject:@0];
                    }
                }
                [_is_joinArray addObject:arr];
            }
            [self.tableViewOne reloadData];
            [self.tableViewTwo reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
#pragma mark -- 加入圈子和取消加入圈子请求数据
/**
 *  加入圈子和取消加入圈子请求数据
 *
 *  @param circle_id 圈子id
 *  @param indexPath 操作cell的indexPath
 *  @param is_join   判断是取消加入还是加入圈子
 */
- (void)setJoin_circle:(NSString *)circle_id indexPath:(NSIndexPath *)indexPath is_join:(BOOL )is_join{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        [self loginClicksss];
        return;
    }
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/join_circle"];
   
    [self show];
    
    [MBNetworking   POSTOrigin:url parameters:@{@"session":sessiondict,@"circle_id":circle_id} success:^(id responseObject) {
        if ([[responseObject  valueForKeyPath:@"status"]isEqualToNumber:@1]) {
          
            if (is_join) {
                if (_isSearchTableView) {
                    NSString *str = _searchArray[indexPath.row][@"circle_name"];
                    [self show:@"成功加入" and:str time:1];
                     _search_is_joinArray[indexPath.row] = @1;
                    [self.searchTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    NSString *str = _OneLevel[_number][@"child_cats"][indexPath.row][@"circle_name"];
                    [self show:@"成功加入" and:str time:1];
                     _is_joinArray[_number][indexPath.row] = @1;
                    [self.tableViewTwo reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            }else{
                if (_isSearchTableView) {
                     NSString *str = _searchArray[indexPath.row][@"circle_name"];
                    [self show:@"成功退出 " and:str time:1];
                   _search_is_joinArray[indexPath.row] = @0;
                    [self.searchTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    NSString *str = _OneLevel[_number][@"child_cats"][indexPath.row][@"circle_name"];
                    [self show:@"成功退出 " and:str time:1];
                    _is_joinArray[_number][indexPath.row] = @0;
                    [self.tableViewTwo reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            }
       
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
   

}
#pragma mark -- 根据关键字搜索圈子数据
- (void)setSearchCircleData:(NSString *)searcText{
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        [self loginClicksss];
        return;
    }
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/search_circle"];
    NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self show];
    
    [MBNetworking   POSTOrigin:str parameters:@{@"session":sessiondict,@"keyword":searcText} success:^(id responseObject) {
        [self dismiss];
        NSLog(@"%@",responseObject);
        if (responseObject) {
            
            _searchArray = [NSMutableArray arrayWithArray:[responseObject valueForKeyPath:@"data"]];
            if (_searchArray.count>0) {
                for (NSDictionary *dic in _searchArray) {
                    
                    NSString *is_join=  [NSString stringWithFormat:@"%@",dic[@"is_join"]];
                    
                    if ([is_join isEqualToString:@"1"]) {
                        [_search_is_joinArray addObject:@1];
                    }else{
                        [_search_is_joinArray addObject:@0];
                    }
                }
                [_searchTableView reloadData];
            }else{
            
                [self show:@"没有和关键字相关的圈子！" time:1];
            }
            
            
        }
       
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
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
- (UITableView *)searchTableView{
    if (!_searchTableView) {
        UITableView *tableview = [[UITableView alloc] init];
        tableview.separatorStyle  =  UITableViewCellSeparatorStyleNone;
        tableview.tableFooterView = [[UIView alloc] init];
        tableview.frame = CGRectMake(0, 75, UISCREEN_WIDTH, UISCREEN_HEIGHT-75-49);
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.hidden = YES;
        tableview.backgroundColor = [UIColor whiteColor];
        _searchTableView = tableview;
    }
    
    return  _searchTableView;

}
- (UISearchBar *)SearchBar{
    if (!_SearchBar) {
       
        _SearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,TOP_Y+31, UISCREEN_WIDTH , 55)];
        _SearchBar.backgroundImage =  [UIImage saImageWithSingleColor:[UIColor whiteColor]];
        _SearchBar.translucent = YES;
        _SearchBar.tintColor = UIcolor(@"a8a8b0");
        _SearchBar.delegate = self;
        _SearchBar.translucent = YES;
        _SearchBar.placeholder = @"找圈子";
    
        UITextField *searchField = [_SearchBar valueForKey:@"searchField"];
        if (searchField) {
            
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.borderColor = UIcolor(@"a8a8b0").CGColor;
            searchField.layer.borderWidth = 1;
            searchField.layer.masksToBounds = YES;
            
        }
        
        // 把监听到的通知转换信号
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(id x) {
            NSLog(@"键盘收回");
          
                [self searchBarCancelButtonClicked:_SearchBar];

            
        }];
        
       
    }
//    _SearchBar.hidden = NO;
    return _SearchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self clickSearch];
    return YES;
}


#pragma mark --UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   
    _SearchBar.showsCancelButton = YES;
    [UIView animateWithDuration:.2f animations:^{
        _SearchBar.frame = CGRectMake(0, 20,UISCREEN_WIDTH, 55);
        _searchTableView.hidden = NO;
       
    }];
    
    NSArray *subViews;
    
    if (iOS_7) {
        subViews = [(_SearchBar.subviews[0]) subviews];
    }
    else {
        subViews = _SearchBar.subviews;
    }
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            
            break;
        }
    }
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀

    return YES;
}
#pragma mark --点击取消按钮的代理方法
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  
    
    if ([searchBar isFirstResponder]) {
    
        [UIView animateWithDuration:0.2 animations:^{
            _SearchBar.frame = CGRectMake(0, TOP_Y+31, UISCREEN_WIDTH, 55);
            _searchTableView.hidden = YES;
            
        }];
        
        _SearchBar.showsCancelButton = NO;
        [_searchArray removeAllObjects];
        [_searchTableView reloadData];
        [searchBar resignFirstResponder];
        if (_isSearchTableView) {
            _isSearchTableView = NO;
        }
    }
    
    
}

#pragma mark --点击键盘搜索的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
   _isSearchTableView = YES;
   
  
   ;
    if ( searchBar.text.length>0) {
        [self setSearchCircleData:searchBar.text];
    }else{
        [self show:@"请输入搜索关键字" time:1];
    }

        searchBar.text = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:_tableViewOne]) {
        return _OneLevel.count;
    }else if([tableView isEqual:_tableViewTwo]){
        return [_OneLevel[_number][@"child_cats"] count];
    }
       return _searchArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:_tableViewOne]) {
        return 30;
    }
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tableViewOne]) {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sssssss"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell    alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sssssss"];
    }
        cell.textLabel.text = _OneLevel[indexPath.row][@"cat_name"];
        cell.textLabel.font = SYSTEMFONT(12);
        if (_number == indexPath.row) {
            cell.textLabel.textColor = UIcolor(@"d66263");
        }else{
             cell.textLabel.textColor = UIcolor(@"575c65");
        }
    return cell;
    }
    
    NSDictionary *dic = _OneLevel[_number][@"child_cats"][indexPath.row];
    BOOL is_Join = NO;
    if ([tableView isEqual:_searchTableView]) {
        dic = _searchArray[indexPath.row];
        if ([_search_is_joinArray[indexPath.row]isEqualToNumber:@1]) {
            is_Join = YES;
        }
    }else{
        if ([_is_joinArray[_number][indexPath.row] isEqualToNumber:@1]) {
            is_Join = YES;
        }
        
    }
    MBMycircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMycircleTableViewCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBMycircleTableViewCell"owner:nil options:nil]firstObject];
    }
    cell.indexPath = indexPath;
    [cell.user_button setBackgroundColor:[UIColor whiteColor]];
    cell.user_name.text = dic[@"circle_name"];
    cell.user_center.text = dic[@"circle_desc"];
    [cell.user_image sd_setImageWithURL:[NSURL URLWithString:dic[@"circle_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
    
    
    if (is_Join) {
        [cell.user_button setTitle:@"-" forState:UIControlStateNormal];
        cell.user_button.titleLabel.font = SYSTEMFONT(30);
    }else{
        [cell.user_button setTitle:@"+" forState:UIControlStateNormal];
        cell.user_button.titleLabel.font = SYSTEMFONT(30);
        
    }
  
    @weakify(self);
    [[cell.myCircleCellSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        if (_isSearchTableView) {
            if ([_search_is_joinArray[indexPath.row] isEqualToNumber:@1]) {
                    [self prompt:indexPath];
            }else{
                NSString *ID = _searchArray[indexPath.row][@"circle_id"];
             [self setJoin_circle:ID indexPath:indexPath is_join:YES];
            }
        }else{
            if ([_is_joinArray[_number][indexPath.row] isEqualToNumber:@1]) {
                [self prompt:indexPath];
                
            }else{
                NSString *ID = _OneLevel[_number][@"child_cats"][indexPath.row][@"circle_id"];
                [self setJoin_circle:ID indexPath:indexPath is_join:YES];
                
                
            }
        }
        
    }];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_tableViewOne isEqual:tableView]) {
        
        if (_number !=indexPath.row) {
            _number = indexPath.row;
            [_tableViewOne reloadData];
            [_tableViewTwo reloadData];
        }
        return;
    }
    NSDictionary *dic = _OneLevel[_number][@"child_cats"][indexPath.row];
    NSNumber *number = _is_joinArray[_number][indexPath.row];
    if (_isSearchTableView) {
        dic = _searchArray[indexPath.row];
        number = _is_joinArray[_number][indexPath.row];
    }
    
    NSString *str ;
    if ([number isEqualToNumber:@1]) {
        str = @"1";
    }else{
        str = @"0";
    }
    
    MBDetailsCircleController * VC = [[MBDetailsCircleController alloc]init];
    VC.circle_id = dic[@"circle_id"];
    VC.circle_user_cnt = dic[@"circle_user_cnt"];
    VC.circle_name = dic[@"circle_name"];
    VC.circle_logo = dic[@"circle_logo"];
    VC.is_join = str;
    [self pushViewController:VC Animated:YES];
        
    
}
-(void)show:(NSString *)str1 and:(NSString *)str2 time:(NSInteger)timer{
    
    NSString *comment_content = [NSString stringWithFormat:@"%@ %@",str1,str2];
    NSRange range = [comment_content rangeOfString:str2];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
    [att addAttributes:@{NSForegroundColorAttributeName:UIcolor(@"d66263")}  range:NSMakeRange(range.location, range.length)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(range.location, range.length )];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    UILabel *lable =    [hud valueForKeyPath:@"label"];
    
    hud.color = RGBCOLOR(219, 171, 171);
    hud.mode = MBProgressHUDModeText;
    hud.labelText = comment_content;
    hud.labelColor = UIcolor(@"575c65");
    lable.attributedText = att;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(235, 70);
    [hud hide:YES afterDelay:timer];
    [self dismiss];
    
}
- (void)prompt:(NSIndexPath *)indexPath{
    
    NSString *str = _OneLevel[_number][@"child_cats"][indexPath.row][@"circle_name"];
    if (_isSearchTableView) {
        str = _searchArray[indexPath.row][@"circle_name"];

    }
    NSString *str1 = [NSString stringWithFormat:@"你确定退出%@?",str];
    NSRange range = [str1 rangeOfString:str];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str1];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:UIcolor(@"d66263") range:NSMakeRange(range.location, range.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(range.location, range.length)];
    
    
    UIAlertController *alertCancel = [UIAlertController alertControllerWithTitle:str1 message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCancel setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *ID = _OneLevel[_number][@"child_cats"][indexPath.row][@"circle_id"];
        if (_isSearchTableView) {
            ID = _searchArray[indexPath.row][@"circle_id"];

        }
        
       [self setJoin_circle:ID indexPath:indexPath is_join:NO];
        
    }];
    [reloadAction setValue:UIcolor(@"575c65") forKey:@"titleTextColor"];
    
    UIAlertAction *reloadAction1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCancel addAction:reloadAction];
    [alertCancel addAction:reloadAction1];
    [reloadAction1 setValue:UIcolor(@"d66263") forKey:@"titleTextColor"];
    [self presentViewController:alertCancel animated:YES completion:nil];
}
@end