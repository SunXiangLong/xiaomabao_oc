//
//  MBMessageViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMessageViewController.h"
#import "MBMessageTableViewCell.h"
#import "MBPraiseTableViewCell.h"
#import "MBcanulaCirclesViewController.h"
#import "MBCanulaCircleDetailsViewController.h"
#import "MBMessageViewController.h"
@interface MBMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    NSMutableArray *_praseArray;
    NSMutableArray *_readArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBMessageViewController
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBMessageViewController"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBMessageViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [[UIView alloc] init];
    _praseArray  = [NSMutableArray array];
    _readArray  = [NSMutableArray array];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _page = 1;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MBRefreshGifFooter *footer = [MBRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(setUserTell)];
    
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    
    // 设置footer
    self.tableView.mj_footer = footer;

    [self setUserTell];
}
- (void)clearData{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *urlStr = @"/communicate/clearct";
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,urlStr];
    if (! sid) {
        return;
    }

    [MBNetworking POST:url parameters:@{@"session":sessiondict}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
         
                
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       
                       
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
        
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
#pragma mark --获取消息数据
- (void)setUserTell{
    
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    NSString *uid = [MBSignaltonTool getCurrentUserInfo].uid;
    NSDictionary *sessiondict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",sid,@"sid",nil];
    
    NSString *urlStr = @"/communicate/newmessagetip";
    NSString *page = [NSString stringWithFormat:@"%ld",_page];
    
    NSString *url =[NSString stringWithFormat:@"%@%@",BASE_URL_root,urlStr];
    if (! sid) {
        return;
    }

    
    
    [MBNetworking POST:url parameters:@{@"session":sessiondict,@"page":page}
               success:^(AFHTTPRequestOperation *operation, MBModel *responseObject) {
                   
                   NSLog(@"%@ %@",[responseObject valueForKey:@"status"],responseObject.data);
                   [self dismiss];
                     [self.tableView .mj_footer endRefreshing];
                   if(1 == [[responseObject valueForKey:@"status"]  intValue]){
                       if (_page==1) {
                           
                           [_readArray addObjectsFromArray: responseObject.data[@"read"]];
                           if ([[responseObject valueForKey:@"data"][@"read"] count]>0) {
                               
                               [_praseArray addObjectsFromArray:[responseObject valueForKey:@"data"][@"unread"]];
                               [self.tableView reloadData];
                               
                               _page ++;
                               //                           if (!_praseArray.count > 0) {
                               //                               UILabel *label = [[UILabel alloc] init];
                               //                               label.textAlignment = 1;
                               //                               label.font = [UIFont systemFontOfSize:14];
                               //                               label.textColor = [UIColor colorR:146 colorG:147 colorB:148];
                               //
                               //                               label.text = @"暂时没有消息";
                               //
                               //                               [self.tableView addSubview:label];
                               //                               [label mas_makeConstraints:^(MASConstraintMaker *make) {
                               //                                   make.centerX.equalTo(self.tableView.mas_centerX);
                               //                                   make.centerY.equalTo(self.tableView.mas_centerY);
                               //                               }];
                               //                               
                               //                           }
                               
                               
                           }
                           
                       }else{
                           if ([[responseObject valueForKey:@"data"][@"read"] count]>0){
                                  [_readArray addObjectsFromArray: responseObject.data[@"read"]];
                                   _page++;
                                  [self.tableView reloadData];
                           
                           }else{
                               
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                               return;
                           }
                  
                       
                       }
                       
                     
                       
                   

                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [self.tableView .mj_footer endRefreshing];
                   [self show:@"请求失败 " time:1];
                   NSLog(@"%@",error);
                   
               }
     ];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)titleStr{
    
    return @"消息";
}
-(NSString *)rightStr{
    
   return @"清空";
    
}
-(void)rightTitleClick{
    [self clearData];
    [_praseArray removeAllObjects];
    [_readArray removeAllObjects];
    [self.tableView reloadData];
}
#pragma mark --tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_praseArray.count==0) {
        return 1;
    }
    return _praseArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_praseArray.count == 0) {
        
        static NSString  *str = @"indenfier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            
        }
        cell.textLabel.textColor = [UIColor colorWithHexString:@"575c65"];
        cell.textLabel.text = @"当前没有消息，点击查看以前消息" ;
        cell.textLabel.textAlignment = 1;
        cell.textLabel.font  = [UIFont systemFontOfSize:14];
   
        
        
        return cell;
        
    }
    NSDictionary *dic =_praseArray [indexPath.row];
    if ([dic[@"type" ]isEqualToString:@"praise"]) {
        MBPraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPraiseTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPraiseTableViewCell" owner:nil options:nil]firstObject];
        }
        cell.userName.text = dic[@"user_name"];
        cell.usertime.text = dic[@"time"];
        [cell.userImageView  sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
       
        return cell;
    }else{
        MBMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBMessageTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBMessageTableViewCell" owner:nil options:nil]firstObject];
        }
        cell.userName.text = dic[@"user_name"];
         cell.userCenter.text = dic[@"content"];
        cell.usertime.text = dic[@"time"];
        [cell.userImageView  sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        
        return cell;
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (_praseArray.count == 0) {
    
        [_praseArray addObjectsFromArray:_readArray];
        [self.tableView  reloadData];
    }else{
        
    NSDictionary *dic =_praseArray [indexPath.row];
    if ([dic[@"type" ]isEqualToString:@"praise"]) {
    
        MBCanulaCircleDetailsViewController *VC = [[MBCanulaCircleDetailsViewController   alloc] init];
        VC.tid = dic[@"talk_id"];
        
        [self pushViewController:VC Animated:YES];
    }else{
    
        MBcanulaCirclesViewController *VC = [[MBcanulaCirclesViewController   alloc] init];
        VC.talk_id = dic[@"talk_id"];
        VC.comment_id = dic[@"comment_id"];
        VC.pusMessages = @"yes";
        VC.title = @"回复评论";
        [self pushViewController:VC Animated:YES];
    }
    }
}
@end
