//
//  MBSearchViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/8/23.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBSearchPostController.h"
#import "MBSearchShowViewController.h"
#import "MobClick.h"
#import "SKTagView.h"
#import "MBDetailsCircleTbaleViewCell.h"

@interface MBSearchPostController () <UITextFieldDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    /**
     *    搜索框
     */
    UISearchBar *_SearchBar;
    /**
     *   搜索结果列表
     */
    UITableView *_tabView;
    /**
     *  表头view 显示大家都在搜数据
     */
    UIView *_topView;
    /**
     *  大家都字搜数据
     */
    NSArray *_SearchHistoryArray;
    /**
     *   大家都在搜
     */
    UILabel *_lable3;
    /**
     *   页数
     */
    NSInteger _page;
    
   
  
    
}
/**
 *  更改_SearchBar里面的searchField
 */
@property (nonatomic,weak) UITextField *searchField;
/**
 *  搜索关键字
 */
@property (strong,nonatomic) NSString *searchString;
/**
 *  背景颜色
 */
@property (nonatomic, strong) NSArray *colorPool;
/**
 *  大家都在搜标签
 */
@property (strong, nonatomic) SKTagView *tagView;
/**
 *  大家都在搜关键字数组
 */
@property (strong, nonatomic) NSArray *historydataArray;
/**
 *   搜索帖子结果数据
 */
 @property (copy, nonatomic) NSMutableArray *dataArray;
@end

@implementation MBSearchPostController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBSearchPostController"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBSearchPostController"];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    _page = 1;
    [self everyoneData];
   
}
- (UIView *)headView{
    UIView  *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 180);

    UILabel *lable = [[UILabel alloc] init];
    lable.text  = @"大家都在搜";
    lable .font = [UIFont systemFontOfSize:17];
    lable.textColor =  UIcolor(@"575c65");
    [view addSubview:_lable3 = lable];
    
    _topView = [[UIView alloc] init];
    
    [view addSubview:_topView];
    
   

    
    return view;
}
/**
 *   大家都在搜数据
 *
 *  @return nil
 */
#pragma mark -- 大家都在搜数据
- (void)everyoneData{
    
    [self show];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/get_hot_search_words"];
    
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
         NSLog(@"%@",responseObject);
        
        if (responseObject) {
            if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                _SearchHistoryArray = [responseObject   valueForKeyPath:@"data"];
                 [self setHeacView];
                               return ;
            }
            
        }
        
        [self show:@"没有相关数据" time:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}

#pragma mark --headView布局
- (void)setHeacView{
    
    self.colorPool = @[@"07ecef4", @"084ccc9", @"88abda",@"7dc1dd",@"b6b8de"];
    
    _SearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, TOP_Y, UISCREEN_WIDTH , 55)];
    _SearchBar.backgroundImage =  [UIImage saImageWithSingleColor:[UIColor whiteColor]];
    _SearchBar.translucent = YES;
    _SearchBar.tintColor = UIcolor(@"a8a8b0");
    _SearchBar.delegate = self;
    _SearchBar.translucent = YES;
    _SearchBar.placeholder = @"请输入关键字";
    [self.view addSubview:_SearchBar];
    
    UITextField *searchField = [_SearchBar valueForKey:@"searchField"];
    if (searchField) {
        
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.borderColor = UIcolor(@"a8a8b0").CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
    }
    

    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y-55)];
    _tabView.backgroundColor = [UIColor whiteColor];
    _tabView.tableHeaderView=[self headView];
    _tabView.tableFooterView = [[UIView alloc] init];
    _tabView.delegate =self;
    _tabView.dataSource = self;
    [self.view addSubview:_tabView];
    [self setupTagView];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setSearchCircleData)];
    footer.refreshingTitleHidden = YES;
   _tabView.mj_footer = footer;
    
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
            

            _SearchBar.text = _SearchHistoryArray[index];

            [self searchBarTextDidBeginEditing:_SearchBar];
            [self  searchBarSearchButtonClicked:_SearchBar];
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
    [_SearchHistoryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
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
    

    
}

#pragma mark -- 根据关键字搜索圈子数据
- (void)setSearchCircleData{
       
        NSString *page  = s_Integer(_page);
    
        NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/circle/search_post"];
        NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self show];
        
        [MBNetworking   POSTOrigin:str parameters:@{@"page":page,@"keyword":self.searchString} success:^(id responseObject) {
            [self dismiss];
            NSLog(@"%@",responseObject);
            if (responseObject) {
                if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                    if (_page ==1) {
                     _tabView.tableHeaderView=[[UIView alloc] init];
                    }
                  
                    [self.dataArray addObjectsFromArray:[responseObject valueForKeyPath:@"data"]];
                    
                   
                    _page++;
                    [_tabView reloadData];
                    [_tabView .mj_footer endRefreshing];
                    
                }else{
                    [_tabView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                
            }else{
                [self show:@"没有相关数据" time:1];
            }

            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self show:@"请求失败 " time:1];
            NSLog(@"%@",error);
        }];
    }


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    return YES;
}

- (NSString *)titleStr{
    return @"搜索帖子";
}
#pragma mark --UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _SearchBar.showsCancelButton = YES;
    [UIView animateWithDuration:.2f animations:^{
        _SearchBar.frame = CGRectMake(0, 20, UISCREEN_WIDTH, 55);
        _tabView.frame = CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), UISCREEN_WIDTH, UISCREEN_HEIGHT-20-55);
 
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
        _SearchBar.frame = CGRectMake(0, TOP_Y, UISCREEN_WIDTH, 55);
        _tabView.frame = CGRectMake(0, CGRectGetMaxY(_SearchBar.frame), UISCREEN_WIDTH, UISCREEN_HEIGHT-TOP_Y-55);
        [self.dataArray removeAllObjects];
        [self setHeacView];
    
    }];
    
    _SearchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
#pragma mark --点击键盘搜索的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    _SearchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    self.searchString = searchBar.text ;
    if (_SearchBar.text.length>0) {
        self.searchString = searchBar.text;
         [self setSearchCircleData];
    }else{
        [self show:@"请输入关键字"time:1];
    
    }
   
    
    
}
#pragma mark --UItableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary  *dic = _dataArray[indexPath.row];
    NSString *post_content = dic[@"post_content"];
    CGFloat post_content_height = [post_content sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH - 24, MAXFLOAT)].height;
    
    if (post_content_height>51) {
        post_content_height = 51+10;
    }else{
        post_content_height +=5;
    }
    if ([dic[@"post_imgs"] count]>0) {
        return 70+(UISCREEN_WIDTH -16*3)/3*133/184+post_content_height;
    }
    return 70+post_content_height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary  *dic = _dataArray[indexPath.row];
    MBDetailsCircleTbaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBDetailsCircleTbaleViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBDetailsCircleTbaleViewCell"owner:nil options:nil]firstObject];
    }
    cell.array = dic[@"post_imgs"];
    cell.post_title.text = dic[@"post_title"];
    cell.post_time.text = dic[@"post_time"];
    cell.reply_cnt.text = dic[@"reply_cnt"];
    cell.author_name.text = dic[@"author_name"];
    cell.post_content.text = dic[@"post_content"];
    
    return cell;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
  
    
}


@end
