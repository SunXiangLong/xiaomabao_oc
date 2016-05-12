//
//  MBPostDetailsViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsViewController.h"
#import "MBPostDetailsOneCell.h"
#import "MBPostDetailsTwoCell.h"
#import "MBPostDetailsHeadView.h"
@interface MBPostDetailsViewController ()
{
   
    
    /**
     *  楼主信息的字典
     */
    NSDictionary *_post_detail;
    /**
     *  titltButton的飙升箭头
     */
    UIImageView *_imageView;
    /**
     *  筛选view
     */
    UIView *_topView;
    /**
     *  是否弹出筛选view
     */
    BOOL _isbool;
}
/**
 *  存放cell高度的数组
 */
@property (copy, nonatomic) NSMutableArray *cellHeightArray;
/**
 *  存放楼主cell高度
 */
@property (copy, nonatomic) NSMutableArray *headArray;
/**
 *   底层视图控件
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  存放跟帖用户的相关信息
 */
@property (copy, nonatomic) NSMutableArray *commentsArray;
/**
 *   楼主发布的全部图片的高度
 */
@property (assign, nonatomic)   CGFloat post_detail_cellheight;
/**
 *  页数
 */
@property (assign, nonatomic)   NSInteger page;
/**
 *  楼主id
 */
@property (copy, nonatomic) NSString *poster;
/**
 *  筛选帖子的条件 0是默认全部，1是只看楼主，2是只看图片
 */
@property (copy, nonatomic) NSString *isImage;
@end

@implementation MBPostDetailsViewController
- (NSMutableArray *)headArray{
    if (!_headArray) {
        _headArray = [NSMutableArray array];
    }
    return _headArray;
}
- (NSMutableArray *)cellHeightArray{
    if (!_cellHeightArray) {
        _cellHeightArray = [NSMutableArray array];
    }
    return _cellHeightArray;
}
- (NSMutableArray *)commentsArray{
    if (!_commentsArray) {
        _commentsArray = [NSMutableArray array];
    }
    return _commentsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle];
    _page =1;
    _poster =  @"1";
    _isImage = @"1";
    
    [self setData];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setData)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
    

   //图片下载完成回调
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"MBPostDetailsViewNOtifition" object:nil];

}
#pragma mark -- 图片下载监听通知
-(void)reload:(NSNotification *)notif
{
    NSDictionary *dic = [notif userInfo];
    NSNumber *num  = dic[@"number"];
    NSIndexPath *indexPath = dic[@"indexPath"];
    NSIndexPath *rootIndexPath = dic[@"rootIndexPath"];
    
    NSLog(@"%@ %ld %@",_headArray,indexPath.row,_post_detail[@"circle_id"]);
    if (!_headArray) {
        
    }
    
    
    if (rootIndexPath.section == 0) {
        /**
         *  只有当下载完成图片长度和预设的图片长度不一致才刷新
         */
        if ([self.headArray[indexPath.row] floatValue] != [num floatValue]) {
            _post_detail_cellheight +=  [num floatValue] - (UISCREEN_WIDTH-20)*105/125;
            self.headArray[indexPath.row] = num;
                        [self.tableView reloadData];
                    }
     
    }else{
        /**
         *  只有当下载完成图片长度和预设的图片长度不一致才刷新
         */
        NSLog(@"%ld %ld",[_cellHeightArray[rootIndexPath.row][indexPath.row] count],indexPath.row);
        if ([_cellHeightArray[rootIndexPath.row][indexPath.row] floatValue] != [num floatValue]) {
            _cellHeightArray[rootIndexPath.row][indexPath.row] = num;
                [self.tableView reloadData];

        }
    
    }
   

    
 
}
#pragma mark -- tittButton和帖子筛选分类的View的Ui布局
- (void)setTitle{
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:18];
    lable.text = @"全部" ;
    lable.textColor= [UIColor whiteColor];
    [self.navBar addSubview:lable];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"arrow"];
    [self.navBar addSubview:_imageView = imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(showTopView) forControlEvents:UIControlEventTouchUpInside]
    ;
    [self.navBar addSubview:button];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navBar.mas_centerX);
        make.centerY.equalTo(self.navBar.mas_centerY).offset(10);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar.mas_centerY).offset(10);
        make.left.equalTo(lable.mas_right).offset(5);
        make.height.mas_equalTo(6);
        make.width.mas_equalTo(12);
    }];
    
    [button  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navBar.mas_centerX);
        make.centerY.equalTo(self.navBar.mas_centerY).offset(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(100);
    }];
    
    
    _topView = [[UIView alloc] init];
    _topView.frame = CGRectMake(UISCREEN_WIDTH, TOP_Y, UISCREEN_WIDTH, 85);
    
    [self.view addSubview:_topView];
    MBPostDetailsHeadView  *topView = [MBPostDetailsHeadView instanceView];
    topView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 85);
  
    [_topView addSubview:topView];
    @weakify(self);
    [[topView.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *number) {
        NSLog(@"%ld",[number integerValue]);
        
        @strongify(self);
        self.isImage = s_str(number);
        self.page = 1;
        self.post_detail_cellheight = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self.headArray removeAllObjects];
        [self.commentsArray removeAllObjects];
        [self.cellHeightArray removeAllObjects];
   
        [self showTopView];
        [self setData];
        
    }];
    
}
#pragma mark -- 帖子筛选view
- (void)showTopView {
    
    if (!_isbool) {
        [UIView animateWithDuration:.5f animations:^{
            _imageView.transform = CGAffineTransformMakeRotation(M_PI);
            _topView.frame = CGRectMake(0, 64, UISCREEN_WIDTH, 85);
        }];
        
    }else{
        [UIView animateWithDuration:.5f animations:^{
            _imageView.transform = CGAffineTransformMakeRotation(0);
            _topView.frame = CGRectMake(UISCREEN_WIDTH, 64, UISCREEN_WIDTH, 85);

        }];
            }
   
    _isbool = !_isbool;
   
}
#pragma mark -- 帖子数据
- (void)setData{
    [self show];
    NSString *page = s_Integer(_page);
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",BASE_URL_root,@"/circle/get_post_detail",self.post_id,page,_isImage,_poster];
    
    [MBNetworking newGET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismiss];
//        NSLog(@"%@",responseObject);
        
        if (responseObject) {
            if (_page ==1) {
                _post_detail = [responseObject valueForKeyPath:@"post_detail"];
              
                for (NSInteger i= 0 ; i<[_post_detail[@"post_imgs"] count]; i++) {
                    _post_detail_cellheight += (UISCREEN_WIDTH-20)*105/125;
                    [self.headArray addObject:@((UISCREEN_WIDTH-20)*105/125)];
                }
                
                [self.commentsArray addObjectsFromArray:[responseObject valueForKeyPath:@"comments"]];
                for (NSDictionary *dic in self.commentsArray) {
                    NSArray *arr = dic[@"comment_imgs"];
                    NSMutableArray *array = [NSMutableArray array];
                    for (NSInteger i = 0; i < arr.count; i++) {
                        [array addObject:@((UISCREEN_WIDTH-20)*105/125)];
                    }
                    [self.cellHeightArray addObject:array];
                }
          
                 [_tableView reloadData];
                _page++;
                
            }else{
                
                if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                     [_commentsArray addObjectsFromArray:[responseObject valueForKeyPath:@"comments"]];
                    _page++;
                    [_tableView reloadData];
                    [self.tableView .mj_footer endRefreshing];
                    
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }

            
            }
          
        
            return ;
        }
        
        [self show:@"没有相关数据" time:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.commentsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *post_content = _post_detail[@"post_content"];
        
        if ([_post_detail[@"post_imgs"] count]>0) {
            CGFloat height =  _post_detail_cellheight+145+[post_content sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height;
            
            return height;
          
        }
        
        
         return _post_detail_cellheight+135+[post_content sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height;
       
    }
    NSDictionary *dic = _commentsArray[indexPath.row];

    
    NSString *comment_content = dic[@"comment_content"];
    CGFloat cellHeight = 0;
    for (NSNumber *number in self.cellHeightArray[indexPath.row]) {
        cellHeight += [number floatValue];
    }
    if (dic[@"comment_reply"]) {
        
        cellHeight+=40;
    }
    return cellHeight+104+[comment_content sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH-20, MAXFLOAT)].height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        MBPostDetailsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsOneCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsOneCell"owner:nil options:nil]firstObject];
        }
   
         cell.rootIndexPath = indexPath;
         cell.heightArray = _headArray;
     
        cell.post_content.text = _post_detail[@"post_content"];
        cell.post_title.text = _post_detail[@"post_title"];
        cell.circle_name.text = _post_detail[@"circle_name"];
        cell.author_name.text = _post_detail[@"author_name"];
        cell.reply_cnt.text = _post_detail[@"reply_cnt"];
        [cell.author_userhead  sd_setImageWithURL:URL(_post_detail[@"author_userhead"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
          cell.imagUrlStrArray = _post_detail[@"post_imgs"];
      

        
        return cell;
    }
    NSDictionary *dic = _commentsArray[indexPath.row];
    MBPostDetailsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsTwoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsTwoCell"owner:nil options:nil]firstObject];
    }
  
    cell.rootIndexPath = indexPath;
    cell.heightArray =  _cellHeightArray[indexPath.row];
    cell.comment_time.text = dic[@"comment_time"];
    cell.comment_floor.text = dic[@"comment_floor"];
    cell.comment_content.text = dic[@"comment_content"];
    cell.user_name.text = dic[@"user_name"];
    [cell.user_head sd_setImageWithURL:URL(dic[@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    
    if (dic[@"comment_reply"]) {
        cell.comment_reply_user_name.text = dic[@"comment_reply"][@"user_name"];
        cell.comment_reply_comment_content.text = dic[@"comment_reply"][@"comment_content"];
        [cell.user_head_user_head sd_setImageWithURL:URL(dic[@"comment_reply"][@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.comment_reply_height.constant  = 40;
        cell.commentView.hidden = NO;
    }else{
        
        cell.comment_reply_height.constant  = 0;
        cell.commentView.hidden = YES;
    }
    cell.imagUrlStrArray = dic[@"comment_imgs"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)dealloc{

[[NSNotificationCenter defaultCenter] removeObserver:self];
    _commentsArray = nil;
    _cellHeightArray = nil;
    _post_detail_cellheight = 0;
    _post_detail = nil;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (_isbool) {
        
        
        [UIView animateWithDuration:.3f animations:^{
            _imageView.transform = CGAffineTransformMakeRotation(0);
            _topView.frame = CGRectMake(UISCREEN_WIDTH, 64, UISCREEN_WIDTH, 85);
            _isbool = !_isbool;

        }];
            }

}
@end
