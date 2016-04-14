//
//  MBPersonalCanulaCircleViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/4.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPersonalCanulaCircleViewController.h"

#import "MBcheshiCollectionViewCell.h"
#import "MBCanulaCircleDetailsViewController.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "MBPersonalCollectionViewCell.h"
#import "MBAttentionOrFansViewController.h"
#import "MBMessageViewController.h"
#import "APService.h"
#import "MBCanulcircleHomeViewController.h"
@interface MBPersonalCanulaCircleViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_dataArray;
    NSInteger _page;
    BOOL _isRefresh;
    UILabel *_promptLable;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuLable;
@property (weak, nonatomic) IBOutlet UILabel *fensiLableNum;
@property (weak, nonatomic) IBOutlet UILabel *tiezhiLableNum;
@property (weak, nonatomic) IBOutlet UICollectionView *conllectionView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (nonatomic,copy)      NSMutableArray *dataArray;
@end

@implementation MBPersonalCanulaCircleViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBPersonalCanulaCircleViewController"];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBPersonalCanulaCircleViewController"];
    
    NSString *messageNumber = [User_Defaults objectForKey:@"messageNumber"];
    if (messageNumber&&[messageNumber intValue]>0 ) {
        [self.messageBadge autoBadgeSizeWithString:messageNumber];
        self.messageBadge.hidden = NO;
    }else{
        self.messageBadge.hidden = YES;
    }
    
    if (_isRefresh) {
        [self setUpdateUserData];
    }

    [self setUnreadMessages];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.top.constant = TOP_Y+5;
    [self setHeadUserData];
    _dataArray = [NSMutableArray array];
    _page = 1;
    self.headView.hidden = YES;
    JCCollectionViewWaterfallLayout *layout = [[JCCollectionViewWaterfallLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10 ;
    layout.sectionInset = UIEdgeInsetsMake(10, 8, 10, 8);
    self.conllectionView.collectionViewLayout = layout;
    self.conllectionView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    [self.conllectionView  registerNib:[UINib nibWithNibName:@"MBPersonalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MBPersonalCollectionViewCell"];
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setUserTell)];
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
//    footer.automaticallyRefresh = YES;
    // 隐藏刷新状态的文字
   footer.refreshingTitleHidden = YES;
    
    // 设置footer
    self.conllectionView.mj_footer = footer;
    
  

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBadge:) name:@"messageBadge" object:nil];
    
}

- (void)messageBadge:(NSNotification *)notificat{
    NSString *badgeValue =  [User_Defaults objectForKey:@"messageNumber"];
 
    if (badgeValue&&[badgeValue integerValue]>0) {
        [ self.messageBadge autoBadgeSizeWithString:badgeValue];
         self.messageBadge.hidden = NO;
    }else{
         self.messageBadge.hidden = YES;
    }
}
#pragma mark --更新用户信息
- (void)setUpdateUserData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/getusermbqinfo"];
    if (! sid) {
        return;
    }

    NSDictionary *parameters;
    if (self.user_id) {
        parameters = @{@"user_id": self.user_id};
    }else{
        parameters= @{@"session":sessiondict};
    }
    [MBNetworking POST:url parameters: parameters
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       
                       self.guanzhuLable.text = responseObject.data[@"attentions"];
                       self.fensiLableNum.text = responseObject.data[@"fans"];
                       self.tiezhiLableNum.text = responseObject.data[@"article"];
                       self.titleStr = responseObject.data[@"username"];
                
                       
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
#pragma mark --获取用户信息
- (void)setHeadUserData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/getusermbqinfo"];
    if (! sid) {
        return;
    }
    [self show];
    NSDictionary *parameters;
    
    
    if (self.user_id) {
        parameters = @{@"session":sessiondict,@"user_id": self.user_id};
    }else{
        parameters= @{@"session":sessiondict};
    }
    [MBNetworking POST:url parameters: parameters
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
//                  NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
       
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                      
                       static dispatch_once_t pred;
                       dispatch_once(&pred, ^{
                           NSSet *sets = [NSSet setWithObject:responseObject.data[@"user_id"]];
                           [APService setTags:sets alias:@"sunxianglong" callbackSelector:nil object:self];
                     
                       });
                       
                      
    
                       
                       [self.touxiangImageView sd_setImageWithURL:[NSURL URLWithString:responseObject.data[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
                       
                       self.guanzhuLable.text = responseObject.data[@"attentions"];
                       self.fensiLableNum.text = responseObject.data[@"fans"];
                       self.tiezhiLableNum.text = responseObject.data[@"article"];
                       self.titleStr = responseObject.data[@"username"];
                       [self setUserTell];
                       
                   }else{
                       [self dismiss];
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
#pragma mark --获取未读消息数
- (void)setUnreadMessages{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/usertips"];
    if (! sid) {
        return;
    }
  
    NSDictionary *parameters = @{@"session":sessiondict};
   
    [MBNetworking POST:url parameters: parameters
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       NSString *mess =  [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"data"]];
                       if ([mess intValue]>0 ) {
                           [self.messageBadge autoBadgeSizeWithString:mess];
                           self.messageBadge.hidden = NO;
                       }else{
                           self.messageBadge.hidden = YES;
                       }
                                              
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
#pragma mark --获取用户说说列表
- (void)setUserTell{
    
  
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,@"/communicate/talklist"];
    if (! sid) {
        return;
    }if (_page>1) {
           [self show];
    }
     NSDictionary *parameters;
    if (self.user_id) {
        parameters = @{@"session":sessiondict,@"user_id": self.user_id,@"page":page};
    }else{
        parameters= @{@"session":sessiondict,@"page":page};
    }

    [MBNetworking POST:url parameters:parameters
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
            NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   
                   [self dismiss];
                   
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       self.headView.hidden = NO;
                    
                       if (_page==1) {
                           if ([responseObject.data[@"data"] count] ==0) {
                               _promptLable = [[UILabel alloc] init];
                               _promptLable.text =  @"暂时没有发表的帖子数据";
                               _promptLable.textAlignment = 1;
                               _promptLable.font = [UIFont systemFontOfSize:14];
                               _promptLable.textColor = [UIColor colorR:146 colorG:147 colorB:148];
                               [self.view addSubview:_promptLable];
                               [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
                                   make.centerX.equalTo(self.view.mas_centerX);
                                   make.centerY.equalTo(self.view.mas_centerY).offset(80);
                               }];
                           }else{
                               [_dataArray addObjectsFromArray:responseObject.data[@"data"]];
                               self.conllectionView.delegate =self;
                               self.conllectionView.dataSource = self;
                               _page++;
                           }
                          
                       }else{
                           if (_page >[responseObject.data[@"max_page"] integerValue]) {
                               
                               [self.conllectionView.mj_footer endRefreshingWithNoMoreData];
                               return ;

                           }else{
                               [_dataArray addObjectsFromArray:responseObject.data[@"data"]];
                               _page++;
                               [self.conllectionView reloadData];
                           }
                       
                       }
           
                       
                       
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}

#pragma mark--关注
- (IBAction)attentionButton:(UIButton *)sender {
    _isRefresh =    YES;
    MBAttentionOrFansViewController *VC = [[MBAttentionOrFansViewController alloc] init];
    VC.type = MBAttentionType;
    if (self.user_id) {
        VC.user_id = self.user_id;
    }
    [self pushViewController:VC Animated:YES];
}
#pragma mark--粉丝
- (IBAction)fansButton:(UIButton *)sender {
    _isRefresh = YES;
    MBAttentionOrFansViewController *VC = [[MBAttentionOrFansViewController alloc] init];
    VC.type = MBFansType;
    if (self.user_id) {
        VC.user_id = self.user_id;
    }
    [self pushViewController:VC Animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSInteger image_w =200;
    NSInteger image_h =500 ;
    if ([_dataArray[indexPath.item][@"imglist"] count]<1  ) {
        
        image_w = 1;
        image_h = 0;
    }else{
        NSString *str1 = _dataArray[indexPath.item][@"imglist"][0][@"ori_width"];
        NSString *str2 = _dataArray[indexPath.item][@"imglist"][0][@"ori_heigth"];
        
      
        image_w = [str1 integerValue];
        image_h = [str2 integerValue];
        
        
    }
    
    NSInteger width = (UISCREEN_WIDTH-16-10)/2;
    
    
    return CGSizeMake(width, 30+width*image_h/image_w);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBPersonalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MBPersonalCollectionViewCell" forIndexPath:indexPath];
    if ([_dataArray[indexPath.item][@"imglist"] count]>0) {
          [cell.showImage sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.item][@"imglist"][0][@"origin"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    }else{
        cell.showImage.image = nil;
    }

    cell.comment.text = _dataArray[indexPath.item][@"comment"];
    cell.praise.text = _dataArray[indexPath.item][@"praise"];
    cell.time.text = _dataArray[indexPath.item][@"addtime"];
    cell.showImage .contentMode =  UIViewContentModeScaleAspectFill;
    cell.showImage .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.showImage .clipsToBounds  = YES;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _isRefresh = YES;
    MBCanulaCircleDetailsViewController *VC = [[MBCanulaCircleDetailsViewController alloc] init];
    if (!self.user_id) {
        VC.isdelete = YES;
 
    }
    VC.tid = _dataArray[indexPath.item][@"tid"];
    VC.indexPath = indexPath;
        __unsafe_unretained __typeof(self) weakSelf = self;
    VC.block = ^(NSIndexPath *indexPath){
        [weakSelf.dataArray removeObjectAtIndex:indexPath.item];
        [weakSelf.conllectionView deleteItemsAtIndexPaths:@[indexPath]];
    };

    [self pushViewController:VC   Animated:YES];
}
-(NSString *)rightStr{
   return @"消息";
}
-(void)rightTitleClick{
    _isRefresh = NO;
    [User_Defaults setObject:nil forKey:@"messageNumber"];
    MBMessageViewController *VC = [[MBMessageViewController alloc] init];
    [self pushViewController:VC Animated:YES];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    if (self.popHome) {

        
        for (BkBaseViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[MBCanulcircleHomeViewController class]]) {
        [self.navigationController popToViewController:VC animated:YES];
                
         NSNotification *notification =[NSNotification notificationWithName:@"HYTPopViewControllerNotification" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
   
            }
        }

        return nil;
        
    }
    NSNotification *notification =[NSNotification notificationWithName:@"HYTPopViewControllerNotification" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return    [self.navigationController popViewControllerAnimated:animated];
    
    
}

@end
