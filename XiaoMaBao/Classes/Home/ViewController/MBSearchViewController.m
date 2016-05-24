//
//  MBSearchViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/8/23.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSearchViewController.h"
#import "MBSearchShowViewController.h"
#import "MobClick.h"
#import "SKTagView.h"


@interface MBSearchViewController () <UITextFieldDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *_SearchBar;
    UITableView *_tabView;
    UIView *_topView;
    NSMutableArray *_HotSearchArray;
    NSArray *_SearchHistoryArray;
    NSArray *_SearchArray;
    UIView *_view;
    UILabel *_lable1;
    UILabel *_lable2;
    UILabel *_lable3;
    UIImageView *_imageview;
    UIButton *_button;
}
@property (nonatomic,weak) UITextField *searchField;
@property (strong,nonatomic) NSString *searchString;
@property (nonatomic, strong) NSArray *colorPool;
@property (strong, nonatomic) SKTagView *tagView;
@end

@implementation MBSearchViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBSearchViewController"];
 
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"shuju"];
    _HotSearchArray = [NSMutableArray arrayWithArray:arr];
    
        
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBSearchViewController"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_HotSearchArray forKey:@"shuju"];
}
- (void)viewDidLoad{
    [super viewDidLoad];

    [self setHeacView];
}
- (UIView *)headView{
    UIView  *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.ml_width, 180);
    _view = view;
    UILabel *lable = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 12, 100, 23)];
    lable.text  = @"大家都在搜";
    lable .font = [UIFont systemFontOfSize:17];
    lable.textColor = [UIColor blackColor];
    [view addSubview:_lable3 = lable];
    
    
    UILabel *lable3 = [[UILabel alloc] init];
    lable3.frame = CGRectMake(UISCREEN_WIDTH-70, 15, 50, 14.5);
    lable3.text = @"换一批";
    lable3.font = [UIFont systemFontOfSize:15];
    lable3.textColor = [UIColor grayColor];
    [view addSubview:_lable2 = lable3];
    UIImageView *imagView1 = [[UIImageView alloc] init];
    imagView1.frame = CGRectMake(CGRectGetMinX(lable3.frame)-14.5, 15, 14.5, 14.5);
    imagView1.image = [UIImage imageNamed:@"refresh"];
    [view addSubview:_imageview = imagView1];
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(UISCREEN_WIDTH-70-14.5, 0, 50+14.5, 25);
    [button1 addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_button = button1];
    
    
    _topView = [[UIView alloc] init];//WithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame)+10, self.view.ml_width,100)];
    [view addSubview:_topView];
    
    
    UILabel *lable1 = [[UILabel alloc] init];
    
    lable1.text  = @"搜索历史";
    lable1 .font = [UIFont systemFontOfSize:17];
    lable1.textColor = [UIColor blackColor];
    [view addSubview:_lable1 = lable1];
    
    UILabel *lable2 = [[UILabel alloc] init];
    lable2.text = @"清空 ";
    lable2.font = [UIFont systemFontOfSize:15];
    lable2.textColor = [UIColor grayColor];
    [view addSubview:_lable2 = lable2];
    
    UIImageView *imagView = [[UIImageView alloc] init];
    imagView.image = [UIImage imageNamed:@"delete"];
    [view addSubview:_imageview = imagView];
    
    UIButton *button = [[UIButton alloc] init];
    
    [button addTarget:self action:@selector(HistoryRemove) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_button = button];
    
    
    return view;
}


#pragma mark --headView布局
- (void)setHeacView{

    self.colorPool = @[@"07ecef4", @"084ccc9", @"88abda",@"7dc1dd",@"b6b8de"];
    _SearchHistoryArray = @[@"美德乐", @"花王", @"跨境购", @"婴儿车", @"玩具",@"围巾", @"尿不湿",@"诺优能",@"特福芬",@"麦婴",@"奶瓶",@"行李箱",@"智高chicco"];
  
    _SearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, TOP_Y, self.view.frame.size.width , 55)];
    _SearchBar.backgroundImage =  [UIImage saImageWithSingleColor:[UIColor whiteColor]];
    _SearchBar.translucent = YES;
    _SearchBar.tintColor = UIcolor(@"a8a8b0");
    _SearchBar.delegate = self;
    _SearchBar.translucent = YES;
    _SearchBar.placeholder = @"请输入商品名";
    [self.view addSubview:_SearchBar];
    
    UITextField *searchField = [_SearchBar valueForKey:@"searchField"];
    if (searchField) {
     
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.borderColor = UIcolor(@"a8a8b0").CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
    }
    
  
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), self.view.ml_width, self.view.ml_height-TOP_Y-55)];
    _tabView.backgroundColor = [UIColor whiteColor];
     _tabView.tableHeaderView=[self headView];
    _tabView.tableFooterView = [[UIView alloc] init];
    _tabView.delegate =self;
    _tabView.dataSource = self;
    [self.view addSubview:_tabView];
    [self setupTagView];


}
- (void)setupTagView
{
    self.tagView = ({
        SKTagView *view = [[SKTagView alloc] init];
        view.backgroundColor = UIColor.whiteColor;
        view.padding    = UIEdgeInsetsMake(10, 10, 0, 0);
        view.insets    = 6;
        view.lineSpace = 10;
       
        view.didClickTagAtIndex = ^(NSUInteger index){
       

            self.searchString = _SearchArray[index];
            BOOL is = false;
            for (NSString *str in _HotSearchArray) {
                if ([self.searchString isEqualToString:str]) {
                    is = YES;
                }
                
            }
            if (!is) {
                [_HotSearchArray insertObject:self.searchString atIndex:0];
            }
            
            [self clickSearch];
            [_tabView reloadData];
        };
        view;
    });
    [_topView addSubview:self.tagView];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = _topView;
        make.left.equalTo(superView).with.offset(0);
        make.top.equalTo(superView).with.offset(0);
        make.right.equalTo(superView).with.offset(0);
   
        
    }];
    
    //Add Tags
    [[self getRandomArray:_SearchHistoryArray andCount:10] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.fontSize = 13;
         tag.padding = UIEdgeInsetsMake(6, 6, 6, 6);
        
         tag.bgColor = [UIColor colorWithHexString:self.colorPool[idx % self.colorPool.count]];
         tag.cornerRadius = 5;
         [self.tagView addTag:tag];
         
     
        
     }];
    [_lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@10);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lable3.mas_bottom).offset(10);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.equalTo(_tagView.mas_bottom).offset(10);
    }];
    
  [_lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(_tagView.mas_bottom).offset(20);
      make.left.equalTo(@10);
  }];
    
    [_lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(_tagView.mas_bottom).offset(25);
        make.right.equalTo(@-20);
    }];
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_tagView.mas_bottom).offset(27);
         make.right.equalTo(_lable2.mas_left).offset(0);
         make.size.mas_equalTo(CGSizeMake(14.5, 14.5));
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_tagView.mas_bottom).offset(10);
         make.right.mas_equalTo(-20);
         make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    
    
   
}
#pragma mark --搜索数据;
- (void)clickSearch{
 
       NSLog(@"%f",_lable1.ml_y);
    
    NSDictionary *params = @{@"keywords":self.searchString,@"having_goods":@"false"};
    NSDictionary *pagination = @{@"coun":@"20",@"page":@"1"};
    [self show];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"search"] parameters:@{@"filter":params,@"pagination":pagination} success:^(NSURLSessionDataTask *operation, MBModel *responseObject) {
        [self dismiss];
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            if (responseObject.data.count >0) {
               // NSLog(@"%@",responseObject.data);
                
                
                MBSearchShowViewController *categroy = [[MBSearchShowViewController alloc] init];
                categroy.dataArr = [responseObject valueForKey:@"data"];
                categroy.title = self.searchString;
                [self.navigationController pushViewController:categroy animated:YES];
            }else{
                [self show:@"没有该类的商品，请换个关键词搜索" time:1];
            }
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
     
        [self show:@"请求失败" time:1];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickSearch];
    return YES;
}

- (NSString *)titleStr{
    return @"搜索商品";
}
#pragma mark --UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _SearchBar.showsCancelButton = YES;
    [UIView animateWithDuration:.2f animations:^{
         _SearchBar.frame = CGRectMake(0, 20, self.view.ml_width, 55);
        _tabView.frame = CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), self.view.ml_width, self.view.ml_height-TOP_Y-55);
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
          _SearchBar.frame = CGRectMake(0, TOP_Y, self.view.ml_width, 55);
        _tabView.frame = CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), self.view.ml_width, self.view.ml_height-TOP_Y-55);
    }];

   _SearchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
#pragma mark --点击键盘搜索的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [UIView animateWithDuration:0.2 animations:^{
        _SearchBar.frame = CGRectMake(0, TOP_Y, self.view.ml_width, 55);
        _tabView.frame = CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), self.view.ml_width, self.view.ml_height-TOP_Y-55);
    }];
    
    _SearchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    self.searchString = searchBar.text ;
    BOOL is = false;
    for (NSString *str in _HotSearchArray) {
        if ([self.searchString isEqualToString:str]) {
            is = YES;
        }
        
    }
    if (!is) {
        [_HotSearchArray insertObject:self.searchString atIndex:0];
    }

    [_tabView reloadData];
    [self clickSearch];
    
}
#pragma mark --UItableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _HotSearchArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"sssss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"icon_nav03_press"];
    cell.textLabel.text = _HotSearchArray[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    self.searchString = _HotSearchArray[indexPath.row];
    [self clickSearch];

}
#pragma mark --清空历史&&刷新数据
- (void)HistoryRemove{
    _view.frame =CGRectMake(0, 0, UISCREEN_WIDTH, 500);
    [_HotSearchArray removeAllObjects];
    [_tabView reloadData];
}

- (void)Refresh{
    [_tagView removeAllTags];
    [[self getRandomArray:_SearchHistoryArray andCount:10] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor whiteColor];
         tag.fontSize = 13;
         tag.padding = UIEdgeInsetsMake(6, 6, 6, 6);
         
         tag.bgColor = [UIColor colorWithHexString:self.colorPool[idx % self.colorPool.count]];
         tag.cornerRadius = 5;
         [self.tagView addTag:tag];
         
         
         
     }];
    
}
- (NSArray *)getRandomArray:(NSArray *)array andCount:(NSInteger)num{

    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    
    while ([randomSet count] < num) {
        int r = arc4random() % [array count];
        [randomSet addObject:[array objectAtIndex:r]];
    }
    
    NSArray *randomArray = [randomSet allObjects];
    _SearchArray = randomArray;
    return randomArray;

}
@end
