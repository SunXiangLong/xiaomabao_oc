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
#import "MBCollectionPostController.h"
#import "MBPostReplyController.h"
#import "MBPostDetailsViewCell.h"
#import "MBPostDetailsFooterOne.h"
#import "MBPostDetailsFooterTwo.h"
@interface MBPostDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    
    BOOL _isRefresh;
   

}

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
   
    
    [self.tableView registerNib:    [UINib nibWithNibName:@"MBPostDetailsOneCell" bundle:nil] forCellReuseIdentifier:@"MBPostDetailsOneCell"];
    [self.tableView registerNib:    [UINib nibWithNibName:@"MBPostDetailsTwoCell" bundle:nil] forCellReuseIdentifier:@"MBPostDetailsTwoCell"];
    [self.tableView registerNib:    [UINib nibWithNibName:@"MBPostDetailsViewCell" bundle:nil] forCellReuseIdentifier:@"MBPostDetailsViewCell"];
    
    [self is_collectionData];
   [self setData];
    


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
     
        [self.commentsArray removeAllObjects];
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
    if (_isRefresh) {
      [_tableView.mj_footer endRefreshingWithNoMoreData];
        _isRefresh  = NO;
        return;
    }
    [self show];
    NSString *page = s_Integer(_page);
      NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",BASE_URL_root,@"/circle/get_post_detail",self.post_id,page,_isImage,_poster];
    if (self.comment_id) {
        url = [NSString stringWithFormat:@"%@/%@",url,self.comment_id];
    }
  

    [MBNetworking newGET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        [self dismiss];
        //        MMLog(@"%@",responseObject);
        [_tableView.mj_footer endRefreshing];
        if (responseObject) {
            
            if (_isDismiass) {
              
                    NSDictionary *dataDic = [[responseObject valueForKeyPath:@"comments"] lastObject];
                
                
                    NSDictionary *dic = _commentsArray.lastObject;
                
                if (!dataDic&&[dic[@"comment_id"]isEqualToString:dataDic[@"comment_id"]]) {
                     _isDismiass = !_isDismiass;
                    return ;
                }
                    [_commentsArray addObject:dataDic];
                
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.commentsArray.count-1];
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    _isRefresh =YES;
                    _isDismiass = !_isDismiass;
                   return ;
                
            }
           
            if (_page ==1) {

                [self.commentsArray addObject:[responseObject valueForKeyPath:@"post_detail"]];
                [self.commentsArray addObjectsFromArray:[responseObject valueForKeyPath:@"comments"]];
                
                
                [self.tableView reloadData];
                _page++;
                
           
                
            }else{
                
                if ([[responseObject valueForKeyPath:@"data"] count]>0) {
                    
                    NSArray *dataArr = [responseObject valueForKeyPath:@"comments"];
                    [_commentsArray addObjectsFromArray:dataArr];
                    
                    _page++;
                    [self.tableView reloadData];
                    
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
                
                
            }
            
            
            return ;
        }
        
        [self show:@"没有相关数据" time:1];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        MMLog(@"%@",error);
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
        MMLog(@"%@",error);
    }];
    
}
- (void)collectionData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    if (!sid) {
        [self  loginClicksss:@"mabao"];
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
        MMLog(@"%@",error);
    }];
    
}

-(NSString *)rightImage{
    
    return @"dian_image";
}
-(void)rightTitleClick{
    
    [self share];
}
-(void)share{
     NSDictionary *dic = _commentsArray[0];
     NSString *post_content = dic[@"post_content"];
    if (post_content.length>50) {
        post_content = [post_content substringToIndex:50];
    }
    //1、创建分享参数
    NSArray* imageArray = @[@"http://www.xiaomabao.com/static1/images/app_icon.png"];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.xiaomabao.com/circle/post/%@",self.post_id]];
    
    
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:post_content
                                         images:imageArray
                                            url:url
                                          title:dic[@"post_title"]
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
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    if (!sid) {
        [self  loginClicksss:@"mabao"];
        return;
    }
    
    self.collectionButton.enabled = NO;
    [self  collectionData];
}
#pragma mark -- 评论;
- (IBAction)comments:(id)sender {
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    
    if (!sid) {
        [self  loginClicksss:@"mabao"];
        return;
    }
    _isDismiass = YES;
    MBPostReplyController *VC = [[MBPostReplyController alloc] init];
    
    VC.title   = [NSString stringWithFormat:@"回复%@:",@"楼主"];
    VC.post_id = self.post_id;
    VC.comment_reply_id  = @"0";
    WS(weakSelf)
    VC.successEvaluation = ^(){
        
        if (weakSelf.isDismiass) {
            
            if (weakSelf.commentsArray.count<20) {
                weakSelf.page =1;
            }
            weakSelf.poster =  @"1";
            weakSelf.isImage = @"1";
            [weakSelf setData];
            
        }
    
    };
    [self pushViewController:VC Animated:YES];
   
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    NSDictionary *dic = _commentsArray[indexPath.section];
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            MBPostDetailsOneCell *detailsOneCell = (MBPostDetailsOneCell *)cell;
            detailsOneCell.dataDic =  dic;
        }else{
            MBPostDetailsViewCell *DetailsViewCell = (MBPostDetailsViewCell *)cell;
            DetailsViewCell.imageUrl = dic[@"post_imgs"][indexPath.row -1];
            DetailsViewCell.num = [dic[@"post_imgs_scale"][indexPath.row -1 ] floatValue];
            
        }
    }else{
        
        if (indexPath.row ==0 ) {
            MBPostDetailsTwoCell *DetailsTwoCell = (MBPostDetailsTwoCell *)cell;
            DetailsTwoCell.dataDic =  dic;
            //            DetailsTwoCell.indexPath = indexPath;
                    }else{
            MBPostDetailsViewCell *DetailsViewCell = (MBPostDetailsViewCell *)cell;
            DetailsViewCell.imageUrl = dic[@"comment_imgs"][indexPath.row -1 ];
            DetailsViewCell.num = [dic[@"comment_imgs_scale"][indexPath.row - 1] floatValue];
            
        }
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentsArray.count;
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        if (indexPath.section ==0) {
            if (indexPath.row ==0) {
                return [tableView fd_heightForCellWithIdentifier:@"MBPostDetailsOneCell" cacheByIndexPath:indexPath configuration:^(MBPostDetailsOneCell *cell) {
                    [self configureCell:cell atIndexPath:indexPath];
                    
                }];

            }
            
            return [tableView fd_heightForCellWithIdentifier:@"MBPostDetailsViewCell" cacheByIndexPath:indexPath configuration:^(MBPostDetailsViewCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
                
            }];
        }
  
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"MBPostDetailsTwoCell" cacheByIndexPath:indexPath configuration:^(MBPostDetailsTwoCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
                
            }];
       
    }
    return [tableView fd_heightForCellWithIdentifier:@"MBPostDetailsViewCell" cacheByIndexPath:indexPath configuration:^(MBPostDetailsViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 40)];
    footerView.backgroundColor = UIcolor(@"eaeaea");
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 30, UISCREEN_WIDTH, 10)];
    [footerView addSubview:view];
    if (section == 0) {
        MBPostDetailsFooterOne *Footer = [MBPostDetailsFooterOne instanceView];
        Footer.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 30);
        [footerView addSubview:Footer];
        Footer.user_cnt.text = _commentsArray[section][@"reply_cnt"];
        Footer.user_name.text = _commentsArray[section][@"circle_name"];
        
    }else{
    
       MBPostDetailsFooterTwo *Footer = [MBPostDetailsFooterTwo instanceView];
        Footer.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 30);
        Footer.indexPath =  [NSIndexPath indexPathForRow:section inSection:0];
        [footerView addSubview:Footer];
        @weakify(self);
        [[Footer.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {

            @strongify(self);
            NSDictionary *dic = self.commentsArray[indexPath.row];
            NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;

            if (!sid) {
                [self  loginClicksss:@"mabao"];
                return;
            }
            MBPostReplyController *VC = [[MBPostReplyController alloc] init];
            self.isDismiass  = YES;
            VC.title   = [NSString stringWithFormat:@"回复%@:",dic[@"user_name"]];
            VC.post_id =self.post_id;
            VC.comment_reply_id  = dic[@"comment_id"];

            [self pushViewController:VC Animated:YES];
        }];

        
    }
    
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            
            MBPostDetailsOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsOneCell"];
            [self configureCell:cell atIndexPath:indexPath];

             return cell;
            
        }
       MBPostDetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsViewCell"];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
    if (indexPath.row == 0) {
        
        MBPostDetailsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsTwoCell"];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    MBPostDetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsViewCell"];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
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
