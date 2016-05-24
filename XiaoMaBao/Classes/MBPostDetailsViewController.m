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
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MBLoginViewController.h"
#import "MBCollectionPostController.h"
#import "MBPostReplyController.h"
#import "MBPostDetailsViewCell.h"
#import "LWImageBrowser.h"

@interface MBPostDetailsViewController ()<SDPhotoBrowserDelegate>
{
    
    
    
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
    /**
     *  是否被收藏
     */
    BOOL _isCollection;
   
    NSIndexPath *_dianjiIndexPath;
   

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
 *  收藏button
 */
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
/**
 *   底层视图控件
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  存放跟帖用户的相关信息
 */
@property (copy, nonatomic) NSMutableArray *commentsArray;
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
/**
 *   是否是下个界面返回
 */

@property (nonatomic,assign) BOOL isDismiass;
@end

@implementation MBPostDetailsViewController
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"MBPostDetailsViewController"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"MBPostDetailsViewController"];
    if (_isDismiass) {
         [self setData];
    }
   
    
}
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
   
    [self is_collectionData];
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
   
        /**
         *  只有当下载完成图片长度和预设的图片长度不一致才刷新
         */
        if ([_cellHeightArray[indexPath.section][indexPath.row-1] floatValue] != [num floatValue]) {
            _cellHeightArray[indexPath.section][indexPath.row-1] = num;
    
             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        
        @strongify(self);
        self.isImage = s_str(number);
        self.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self.headArray removeAllObjects];
        [self.commentsArray removeAllObjects];
        [self.cellHeightArray removeAllObjects];
        [self setData];
        [self showTopView];
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
    if (self.comment_id) {
        url = [NSString stringWithFormat:@"%@/%@",url,self.comment_id];
    }
  
     __unsafe_unretained __typeof(self) weakSelf = self;
    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        //        NSLog(@"%@",responseObject);
        
        if (responseObject) {
            
            
            if (_isDismiass) {
                
                if ([[responseObject valueForKeyPath:@"comments"] count]>_commentsArray.count-1) {
                    NSDictionary *dataDic = [[responseObject valueForKeyPath:@"comments"] lastObject];
                    [_commentsArray addObject:dataDic];
                    
                    
                    NSMutableArray *cellHeight = [NSMutableArray array];
                    
                    NSArray *arr = dataDic[@"comment_imgs"];

      
                    for (NSString *imageUrl in arr) {
                        [cellHeight addObject:@((UISCREEN_WIDTH-20)*105/125)];
                    }

                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.commentsArray.count-1 inSection:1];
                    
                    [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [weakSelf.tableView scrollToRowAtIndexPath:indexPath
                                              atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    _isDismiass = !_isDismiass;
                    
                    return ;

                }
                
            }
            if (_page ==1) {

                [weakSelf.commentsArray addObject:[responseObject valueForKeyPath:@"post_detail"]];
                [weakSelf.commentsArray addObjectsFromArray:[responseObject valueForKeyPath:@"comments"]];
                
                for (NSInteger i = 0 ; i<self.commentsArray.count; i++) {
                    NSDictionary *dic = self.commentsArray[i];
                    NSMutableArray *cellHeight = [NSMutableArray array];
                    if (i == 0) {
                        NSArray *arr = dic[@"post_imgs"];
                        for (NSString *imageUrl in arr) {
                            [cellHeight addObject:@((UISCREEN_WIDTH-20)*105/125)];
                        }
                    }else{
                    NSArray *arr = dic[@"comment_imgs"];
                        for (NSString *imageUrl in arr) {
                            [cellHeight addObject:@((UISCREEN_WIDTH-20)*105/125)];
                        }
                    }
                    [weakSelf.cellHeightArray addObject:cellHeight];
                }
                
                
                
             
            [weakSelf.tableView reloadData];
                _page++;
                
            }else{
                
                if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                    
                    NSArray *dataArr = [responseObject valueForKeyPath:@"comments"];
                    [_commentsArray addObjectsFromArray:dataArr];
                    for (NSInteger i = 0 ; i<dataArr.count; i++) {
                        NSDictionary *dic = self.commentsArray[i];
                        NSMutableArray *cellHeight = [NSMutableArray array];
                        
                            NSArray *arr = dic[@"comment_imgs"];
                            for (NSString *imageUrl in arr) {
                                [cellHeight addObject:@((UISCREEN_WIDTH-20)*105/125)];
                            }
                      
                        [weakSelf.cellHeightArray addObject:cellHeight];
                    }
                    
                    _page++;
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView .mj_footer endRefreshing];
                    
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                
                
            }
            
            
            return ;
        }
        
        [self show:@"没有相关数据" time:1];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        [self show:@"请求失败" time:1];
    }];
    
    
}
#pragma mark -- 检查是否收藏
- (void)is_collectionData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        return;
    }
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/check_is_collect"];
    NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [MBNetworking   POSTOrigin:str parameters:@{@"session":sessiondict,@"post_id":self.post_id} success:^(id responseObject) {
        
        NSString *status = s_str([responseObject valueForKeyPath:@"status"]);
        
        if ([status isEqualToString:@"1"]) {
            self.collectionButton.selected = YES;
        }else{
            self.collectionButton.selected = NO;
        }
        
        self.collectionButton.enabled = YES;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self show:@"请求失败 " time:1];
        NSLog(@"%@",error);
    }];
    
}
- (void)collectionData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        [self loginClicksss];
        return;
    }
    [self show];
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/UserCircle/collect_post"];
    NSString *str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [MBNetworking   POSTOrigin:str parameters:@{@"session":sessiondict,@"post_id":self.post_id} success:^(id responseObject) {
        
        NSString *status = s_str([responseObject valueForKeyPath:@"info"]);
        [self dismiss];
        
        if ([status isEqualToString:@"收藏成功"]) {
            self.collectionButton.selected = YES;
        }else{
            self.collectionButton.selected = NO;
        }
        
        self.collectionButton.enabled = YES;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
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
-(NSString *)rightImage{
    
    return @"dian_image";
}
-(void)rightTitleClick{
    
    [self share];
}
-(void)share{
    
    //1、创建分享参数
    NSArray* imageArray = @[@"http://www.xiaomabao.com/static1/images/app_icon.png"];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.xiaomabao.com/circle/post/%@",self.post_id]];
    
    
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"小麻包帖子"
                                         images:imageArray
                                            url:url
                                          title:@"小麻包帖子分享"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
    }
    
    
}
#pragma mark --收藏
- (IBAction)collection:(id)sender {
    
    
    self.collectionButton.enabled = NO;
    [self  collectionData];
}
#pragma mark -- 评论;
- (IBAction)comments:(id)sender {
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    if (!sid) {
        [self loginClicksss];
        return;
    }
    _isDismiass = YES;
    MBPostReplyController *VC = [[MBPostReplyController alloc] init];
    
    VC.title   = [NSString stringWithFormat:@"回复%@:",@"楼主"];
    VC.post_id = self.post_id;
    VC.comment_reply_id  = @"0";
    
    [self pushViewController:VC Animated:YES];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentsArray.count;
//    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      NSDictionary *dic = _commentsArray[section];
    if (section ==0) {
        if ([dic[@"post_imgs"] count]>0 ) {
            return [dic[@"post_imgs"] count]+1;
        }
        return 1;
    }
    if ([dic[@"comment_imgs"] count]>0 ) {
        return [dic[@"comment_imgs"] count]+1;
    }
    return 1;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
        NSDictionary *dic = _commentsArray[indexPath.section];

        if (indexPath.section ==0) {
            if (indexPath.row ==0) {
                NSString *post_content = dic[@"post_content"];
                NSString *post_title = dic[@"post_title"];
                CGFloat post_title_height = [post_title sizeWithFont:SYSTEMFONT(16) lineSpacing:2 withMax:UISCREEN_WIDTH-20];
                CGFloat post_content_height = [post_content sizeWithFont:SYSTEMFONT(16) lineSpacing:6 withMax:UISCREEN_WIDTH-20];

                return 108 +post_content_height+post_title_height;
            }
            
            return [self.cellHeightArray[indexPath.section][indexPath.row-1] floatValue];
        }
  
        if (indexPath.row == 0) {
            NSString *comment_content = dic[@"comment_content"];
              CGFloat cellHeight = 0;
            if (dic[@"comment_reply"]) {
                NSString *comment_reply_comment_content =  dic[@"comment_reply"][@"comment_content"];
                CGFloat comment_reply_user_name_height =  [comment_reply_comment_content sizeWithFont: SYSTEMFONT(12) lineSpacing:2 withMax:UISCREEN_WIDTH -70];
                if (comment_reply_user_name_height>35) {
                    cellHeight = comment_reply_user_name_height+45+cellHeight;
                }else{
                    cellHeight = comment_reply_user_name_height+30+cellHeight;
                }
            
        }
        return cellHeight+105+ [comment_content sizeWithFont:SYSTEMFONT(16) lineSpacing:6 withMax:UISCREEN_WIDTH-20];
       
    }
     return [self.cellHeightArray[indexPath.section][indexPath.row-1] floatValue];
        
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSDictionary *dic = _commentsArray[indexPath.section];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
           
            MBPostDetailsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsOneCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsOneCell"owner:nil options:nil]firstObject];
            }
            

            
            cell.post_content.text = dic[@"post_content"];
            cell.post_title.text = dic[@"post_title"];
            cell.circle_name.text = dic[@"circle_name"];
            cell.author_name.text = dic[@"author_name"];
            cell.reply_cnt.text = dic[@"reply_cnt"];
            [cell.author_userhead  sd_setImageWithURL:URL(dic[@"author_userhead"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];            
            [cell.post_content rowSpace:6];
            [cell.post_title rowSpace:2];
            
            return cell;

        }
        
        
        MBPostDetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsViewCell"owner:nil options:nil]firstObject];
        }
        cell.indexPath = indexPath;
        if (indexPath.row-1<[dic[@"post_imgs"] count]) {
            
            cell.imageUrlStr =  dic[@"post_imgs"][indexPath.row-1];
            
 
        }
        
        return cell;
    
    }
    
    if (indexPath.row == 0) {
        
        MBPostDetailsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsTwoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsTwoCell"owner:nil options:nil]firstObject];
        }
        cell.comment_time.text = dic[@"comment_time"];
        cell.comment_floor.text = dic[@"comment_floor"];
        cell.comment_content.text = dic[@"comment_content"];
        cell.user_name.text = dic[@"user_name"];
        [cell.user_head sd_setImageWithURL:URL(dic[@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        cell.indexPath = indexPath;
        [cell.comment_content rowSpace:6];
        [cell.comment_content columnSpace:1];
        if (dic[@"comment_reply"]) {
            
            NSString *comment_reply_comment_content =  dic[@"comment_reply"][@"comment_content"];
            CGFloat comment_reply_user_name_height =  [comment_reply_comment_content sizeWithFont: SYSTEMFONT(12) lineSpacing:2 withMax:UISCREEN_WIDTH -70];
            cell.comment_reply_user_name.text = dic[@"comment_reply"][@"user_name"];
            cell.comment_reply_comment_content.text = dic[@"comment_reply"][@"comment_content"];
            [cell.user_head_user_head sd_setImageWithURL:URL(dic[@"comment_reply"][@"user_head"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
            cell.comment_reply_height.constant  = comment_reply_user_name_height+30;
            cell.commentView.hidden = NO;
            [cell.comment_reply_comment_content rowSpace:2];
            [cell.comment_reply_comment_content columnSpace:1];
        }else{
            cell.comment_reply_height.constant  = 0;
            cell.commentView.hidden = YES;
        }
        @weakify(self);
        [[cell.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
            
            @strongify(self);
            NSDictionary *dic = self.commentsArray[indexPath.section];
            NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
            
            if (!sid) {
                [self loginClicksss];
                return;
            }
            MBPostReplyController *VC = [[MBPostReplyController alloc] init];
            self.isDismiass  = YES;
            VC.title   = [NSString stringWithFormat:@"回复%@:",dic[@"user_name"]];
            VC.post_id =self.post_id;
            VC.comment_reply_id  = dic[@"comment_id"];
            
            [self pushViewController:VC Animated:YES];
        }];
        
        return cell;
    }
   
    
    MBPostDetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsViewCell"owner:nil options:nil]firstObject];
    }
    cell.indexPath = indexPath;
    
  
    if (indexPath.row-1<[dic[@"comment_imgs"] count]) {
        
        cell.imageUrlStr =  dic[@"comment_imgs"][indexPath.row-1];
        
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    _dianjiIndexPath = indexPat;
    NSDictionary *dic = _commentsArray[indexPat.section];
      SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
    if (indexPat.section == 0) {
        photoBrowser.imageCount =  [dic[@"post_imgs"] count];
    }else{
        photoBrowser.imageCount =  [dic[@"comment_imgs"] count];
    }
    if (!(photoBrowser.imageCount > 0)) {
        return;
    }
    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPat];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPat.row -1;
    photoBrowser.sourceImagesContainerView = cell;
    [photoBrowser show];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _commentsArray = nil;
    _cellHeightArray = nil;

 
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
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName;
    if (_dianjiIndexPath.section == 0) {
      
        imageName  = _commentsArray[_dianjiIndexPath.section][@"post_imgs"][index];
        
    }else{
        
     imageName =  _commentsArray[_dianjiIndexPath.section][@"comment_imgs"][index];
        
    }
    
    NSURL *url = URL(imageName);
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
  
    
    return [UIImage imageNamed:@"img_default"];
}
@end
