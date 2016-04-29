//
//  MBMoreCirclesController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMoreCirclesController.h"
#import "MBMycircleTableViewCell.h"
@interface MBMoreCirclesController ()<UITextFieldDelegate,UISearchBarDelegate>

{
    UISearchBar *_SearchBar;
    NSMutableArray *_OneLevel;
    NSInteger _number;
    
    
    NSMutableArray *arrrrr;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewTwo;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOne;
@end

@implementation MBMoreCirclesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
    self.navBar = nil;
    arrrrr = [NSMutableArray array];
    _OneLevel = [NSMutableArray array];
    for (NSInteger  i = 0; i<10 ; i++) {
        [arrrrr  addObject:@"德玛西亚"];
     NSMutableArray *arr = [NSMutableArray arrayWithObjects:@1,@2,@3,@4,@5,@6, nil];
        [_OneLevel addObject:arr];
    }
    
    [self.MinView addSubview:self.SearchBar];
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
            
            
            [self searchBarSearchButtonClicked:_SearchBar];
        }];
    }

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
//        _tabView.frame = CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), self.view.ml_width, self.view.ml_height-TOP_Y-55);
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
    [UIView animateWithDuration:0.2 animations:^{
        _SearchBar.frame = CGRectMake(0, TOP_Y+31, UISCREEN_WIDTH, 55);
//        _tabView.frame = CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), self.view.ml_width, self.view.ml_height-TOP_Y-55);
    }];
    
    _SearchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
#pragma mark --点击键盘搜索的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [UIView animateWithDuration:0.2 animations:^{
        _SearchBar.frame = CGRectMake(0, TOP_Y+31, UISCREEN_WIDTH, 55);
//        _tabView.frame = CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), self.view.ml_width, self.view.ml_height-TOP_Y-55);
    }];
    
    _SearchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
//    self.searchString = searchBar.text ;
//    BOOL is = false;
//    for (NSString *str in _HotSearchArray) {
//        if ([self.searchString isEqualToString:str]) {
//            is = YES;
//        }
//        
//    }
//    if (!is) {
//        [_HotSearchArray insertObject:self.searchString atIndex:0];
//    }
//    
//    [_tabView reloadData];
//    [self clickSearch];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:_tableViewOne]) {
        return _OneLevel.count;
    }
    return [_OneLevel[_number] count];
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
        cell.textLabel.text = arrrrr[indexPath.row];
        cell.textLabel.font = SYSTEMFONT(12);
        if (_number == indexPath.row) {
            cell.textLabel.textColor = UIcolor(@"d66263");
        }else{
             cell.textLabel.textColor = UIcolor(@"575c65");
        }
    return cell;
    }
    MBMycircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMycircleTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBMycircleTableViewCell"owner:nil options:nil]firstObject];
    }
    cell.indexPath = indexPath;
    
    [cell.user_button setBackgroundColor:[UIColor whiteColor]];
    [cell.user_button setTitle:@"+" forState:UIControlStateNormal];
       cell.user_button.titleLabel.font = SYSTEMFONT(30);
    if (indexPath.row%2==0) {
    [cell.user_button setTitle:@"-" forState:UIControlStateNormal];
        cell.user_button.titleLabel.font = SYSTEMFONT(40);
    }
  
    
    @weakify(self);
    [[cell.myCircleCellSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        if (indexPath.row%2==0) {
            [self prompt:indexPath];
            
        }else{
           
            [self show:@"成功加入 " and:@"1-3岁宝宝" time:1];
            [self.tableViewTwo reloadData];
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
        
    }
}
-(void)show:(NSString *)str1 and:(NSString *)str2 time:(NSInteger)timer{
    
    NSString *comment_content = [NSString stringWithFormat:@"%@ %@",str1,str2];
    NSRange range = [comment_content rangeOfString:str2];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:comment_content];
    [att addAttributes:@{NSForegroundColorAttributeName:UIcolor(@"d66263")}  range:NSMakeRange(5, range.length)];
    [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(5, range.length )];
    
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
    
    NSString *str = @"1-3岁宝宝";
    NSString *str1 = [NSString stringWithFormat:@"你确定退出%@?",str];
    NSRange range = [str1 rangeOfString:str];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str1];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:UIcolor(@"d66263") range:NSMakeRange(range.location, range.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(range.location, range.length)];
    
    
    UIAlertController *alertCancel = [UIAlertController alertControllerWithTitle:str1 message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCancel setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       
        [self show:@"成功退出 " and:@"1-3岁宝宝" time:1];
        [self.tableViewTwo reloadData];
        
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
