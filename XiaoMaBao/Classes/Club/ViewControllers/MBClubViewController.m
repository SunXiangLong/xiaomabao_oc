//
//  MBClubViewController.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/13.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBClubViewController.h"
#import "MBClubTableViewCell.h"
#import "MBClub.h"
#import "MBClubFrame.h"
#import "MBClubCommon.h"
#import "MBClubActivityFrame.h"

#import "MBClubFollowerViewController.h"
#import "MBClubStartsViewController.h"
#import "MBClubUserViewController.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
#import "MobClick.h"
#import "MBLoginViewController.h"
#import "CameraViewController.h"
@interface MBClubViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UIView *menuLineView;
@property (weak,nonatomic) UIButton *lastClickMenuButton;
@property (strong,nonatomic) NSMutableArray *lists;
@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *cellIdentifers;
@property (assign,nonatomic)NSInteger page;
@property (strong,nonatomic)NSArray *TieZiListArray;
@property (strong,nonatomic)NSArray *ActivityArray;
@property (strong,nonatomic)NSDictionary *CurentInfostatistics;
@end

@implementation MBClubViewController

- (NSArray *)cellIdentifers{
    if (!_cellIdentifers) {
        _cellIdentifers = @[
                            @"MBClubTableViewCell",
                            @"MBClubTableViewCell",
                            @"MBClubTableViewCell",
                            @"MBActivityTableViewCell"
                            ];
    }
    return _cellIdentifers;
}

- (void)getList{
    MBClubFrame *frame2 = [[MBClubFrame alloc] init];
    MBClub *club2 = [[MBClub alloc] init];
    club2.content = @"         对于大多数父母来说，掌握好如何照顾好孩子的技巧并非一件容易的事，因为每个孩子的脾气秉性都是不同的，孩子的需求也是在不断地变化的。那么，应该如何选择最佳的育儿方式呢？在这篇文章中，就为大家列举一些实用的育儿小技巧。";
    club2.title = @"#这些育儿技巧你知道吗？# 值得收藏！";
    
    MBClubCommon *common = [[MBClubCommon alloc] init];
    common.userName = @"玛丽恭祝";
    common.content = @"我也好想要一个~，分享到朋友圈吧~";
    common.headProfile = @"麻麻特别宅”";
    common.time = @"2013-12-12";
    frame2.club = club2;
    
    _lists = [NSMutableArray arrayWithArray:@[frame2]];
}

- (NSMutableArray *)lists{
    if (!_lists) {
        _lists = [NSMutableArray arrayWithCapacity:_TieZiListArray.count];
        for (NSDictionary *dict in _TieZiListArray) {
            MBClubFrame *frame1 = [[MBClubFrame alloc] init];
            MBClub *club = [[MBClub alloc] init];
            club.title = [dict valueForKeyPath:@"title"];
            club.pic = [dict valueForKeyPath:@"header_img"];
            club.content = [dict valueForKeyPath:@"content"];
            club.praise_num = [dict valueForKeyPath:@"praise_num"];
            club.comment_num = [dict valueForKeyPath:@"comment_num"];
            club.nick_name = [dict valueForKeyPath:@"nick_name"];
            club.Bigpic = [dict valueForKeyPath:@"imgs"];
            club.post_id = [dict valueForKeyPath:@"post_id"];
            club.follow_id = [dict valueForKeyPath:@"user_id"];
            
            frame1.club = club;
            [_lists addObject:frame1];
            
            MBClubCommon *common = [[MBClubCommon alloc] init];
            common.userName = @"玛丽恭祝";
            common.content = @"我也好想要一个~，分享到朋友圈吧~";
            common.headProfile = @"麻麻特别宅”";
            common.time = @"2013-12-12";
            club.common = common;
            frame1.club = club;
        }
}
    return _lists;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MBClubViewController"];
    [self GetCurrentInfostatistics];
    [self getTieZiList:@"0"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MBClubViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self banduan];
    
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 400)];
//    label.text = @"努力开发中，稍后开放...";
//    
//    [self.view addSubview:label];
    

    
}
- (void)banduan{

    MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    if (userInfo.uid == nil) {
        MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
        if (userInfo.uid == nil) {
            //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            //由storyboard根据myView的storyBoardID来获取我们要切换的视图
            MBLoginViewController *myViewVc = [story instantiateViewControllerWithIdentifier:@"MBLoginViewController"];
            //由navigationController推向我们要推向的view
            myViewVc.vcType = @"shop";
            [self.navigationController pushViewController:myViewVc animated:YES];
            return ;
        }
        
    }else{
        [self GetCurrentInfostatistics];
        [self getTieZiList:@"0"];
       
    }


}
#pragma -mark 创建TableView
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView registerClass:[MBClubTableViewCell class] forCellReuseIdentifier:@"MBClubTableViewCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = CGRectMake(0, TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - self.tabBarController.tabBar.ml_height);
    tableView.tableHeaderView = [self headerView];
    tableView.dataSource = self, tableView.delegate = self;
    [self.view addSubview:_tableView = tableView];

}
#pragma -mark 获取圈子当前用户统计信息
-(void)GetCurrentInfostatistics
{
    MBUserDataSingalTon *info = [MBSignaltonTool getCurrentUserInfo];
    NSString *user_id = info.uid;
    if (!user_id) {
        return;
    }
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_QUANZI,@"/mbqz/total&"] parameters:@{@"user_id":user_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        
        _CurentInfostatistics = [responseObject valueForKeyPath:@"data"];
        [self createTableView];
        NSLog(@"获取圈子当前用户统计信息---%@",_CurentInfostatistics);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
        [self createTableView];
    }];

}
#pragma mark 提子列表
-(void)getTieZiList:(NSString *)type
{
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    MBUserDataSingalTon *info = [MBSignaltonTool getCurrentUserInfo];
    NSString *user_id = info.uid;
    if (!user_id) {
        return;
    }
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_QUANZI,@"/mbqz/post/list&"] parameters:@{@"page":page,@"count":@"10",@"type":type,@"user_id":user_id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        
        _TieZiListArray = [responseObject valueForKeyPath:@"data"];
        [self.tableView reloadData];
        NSLog(@"圈子信息帖子列表---%@",_TieZiListArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
- (UIView *)headerView{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, self.view.ml_width, 85);
    
    UIView *peopleView = [[UIView alloc] init];
    peopleView.frame = CGRectMake(0, 0, headerView.ml_width, 50);
   

    [headerView addSubview:peopleView];
    
    UIButton *headPbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     headPbtn.backgroundColor = [UIColor blueColor];
    
    headPbtn.frame = CGRectMake(24, (peopleView.ml_height - 36) * 0.5, 36, 36);
    headPbtn.layer.cornerRadius = 18;
    headPbtn.layer.borderColor = [UIColor colorWithHexString:@"63a3c6"].CGColor;
    headPbtn.layer.borderWidth = 1;
    [peopleView addSubview:headPbtn];
    
    NSArray *topTitles = @[
                           @"关注",
                           @"粉丝",
                           @"帖子"
                           ];
    
    NSMutableArray *numberTitles = [NSMutableArray arrayWithCapacity:3];
    if (_CurentInfostatistics) {
        NSString *follow_count = [_CurentInfostatistics valueForKeyPath:@"follow_count"];
        NSString *follow_me_count = [_CurentInfostatistics valueForKeyPath:@"follow_me_count"];
        NSString *post_count = [_CurentInfostatistics valueForKeyPath:@"post_count"];
        [numberTitles addObject:follow_count];
        [numberTitles addObject:follow_me_count];
        [numberTitles addObject:post_count];
    }else
    {
        [numberTitles addObject:@"0"];
        [numberTitles addObject:@"0"];
        [numberTitles addObject:@"0"];
    }
    
    for (NSInteger i = 0; i < topTitles.count; i++) {
        
        UIButton *numberLbl = [UIButton buttonWithType:UIButtonTypeCustom];
        numberLbl.titleLabel.textAlignment = NSTextAlignmentCenter;
        [numberLbl setTitle:numberTitles[i] forState:UIControlStateNormal];
        [numberLbl setTitleColor:[UIColor colorWithHexString:@"63a3c6"] forState:UIControlStateNormal];
        numberLbl.titleLabel.font = [UIFont systemFontOfSize:18];
        numberLbl.frame = CGRectMake(CGRectGetMaxX(headPbtn.frame) + MARGIN_20 + i * 60, 10, 55, 15);
        [peopleView addSubview:numberLbl];
        numberLbl.tag = i;
        
        [numberLbl addTarget:self action:@selector(headerViewGoToFollowerVc:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *titleLbl = [UIButton buttonWithType:UIButtonTypeCustom];
        titleLbl.tag = i;
        titleLbl.titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLbl setTitle:topTitles[i] forState:UIControlStateNormal];
        [titleLbl setTitleColor:[UIColor colorWithHexString:@"63a3c6"] forState:UIControlStateNormal];
        titleLbl.titleLabel.font = [UIFont systemFontOfSize:12];
        titleLbl.frame = CGRectMake(numberLbl.ml_x, 25, 60, 15);
        [peopleView addSubview:titleLbl];
        
        [titleLbl addTarget:self action:@selector(headerViewGoToFollowerVc:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i != topTitles.count - 1) {            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorWithHexString:@"63a3c6"];
            lineView.frame = CGRectMake(CGRectGetMaxX(titleLbl.frame), MARGIN_10, PX_ONE, peopleView.ml_height - MARGIN_20);
            [peopleView addSubview:lineView];
        }
    }
    
    UIButton *accessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    accessBtn.frame = CGRectMake(peopleView.ml_width - 28 - 16, (peopleView.ml_height - 16) * 0.5, 16, 16);
    [accessBtn addTarget:self action:@selector(goUserVc:) forControlEvents:UIControlEventTouchUpInside];
    [peopleView addSubview:accessBtn];
    
    [self addBottomLineView:peopleView];
    
    UIView *menuView = [[UIView alloc] init];
    menuView.frame = CGRectMake(0, peopleView.ml_height, headerView.ml_width, 35);
    [headerView addSubview:menuView];
    
    NSArray *titles = @[
                        @"推荐",
                        @"关注",
                        @"育儿心经",
                        //@"活动"
                        ];
    
    
    CGFloat width = self.view.ml_width / titles.count;
    self.menuLineView = [[UIView alloc] init];
    self.menuLineView.backgroundColor = [UIColor colorWithHexString:@"63a3c6"];
    self.menuLineView.frame = CGRectMake(0, menuView.ml_height - self.menuLineView.ml_height, width, 2);
    [menuView addSubview:self.menuLineView];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * width, 0, width, menuView.ml_height);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = i;
        [menuView addSubview:btn];
        
        [btn addTarget:self action:@selector(selectedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [self selectedMenuButton:btn];
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"b2b1b2"];
        lineView.frame = CGRectMake(CGRectGetMaxX(btn.frame) - PX_ONE, 0, PX_ONE, menuView.ml_height);
        [menuView addSubview:lineView];
    }
    
    [self addBottomLineView:menuView];
    
    return headerView;
}

- (void)goUserVc:(UIButton *)btn{
    MBClubUserViewController *userVc = [[MBClubUserViewController alloc] init];
    [self.navigationController pushViewController:userVc animated:YES];
}

- (void)headerViewGoToFollowerVc:(UIButton *)btn{
    
    if (btn.tag == 0) {
        MBClubStartsViewController *startVc = [[MBClubStartsViewController alloc] init];
        [self.navigationController pushViewController:startVc animated:YES];
    }else if (btn.tag == 1) {
        MBClubFollowerViewController *followerVc = [[MBClubFollowerViewController alloc] init];
        [self.navigationController pushViewController:followerVc animated:YES];
    }
}
#pragma -mark 获取活动
-(void)getActivity
{
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL_QUANZI,@"/mbqz/act/list&"] parameters:@{@"page":page,@"count":@"10"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功");
        
        _ActivityArray = [responseObject valueForKeyPath:@"data"];
        [_lists removeAllObjects];
        _lists = [NSMutableArray arrayWithCapacity:_ActivityArray.count];
        for (NSDictionary *dict in _ActivityArray) {
            MBClubActivityFrame *frame = [[MBClubActivityFrame alloc] init];
            MBClubActivity *activity = [[MBClubActivity alloc] init];
            activity.act_name = [dict valueForKeyPath:@"act_name"];
            activity.act_imgs = [dict valueForKeyPath:@"act_imgs"];
            activity.act_content = [dict valueForKeyPath:@"act_content"];
            activity.act_link = [dict valueForKeyPath:@"act_link"];
            activity.publish_time = [dict valueForKeyPath:@"publish_time"];
            activity.act_id = [dict valueForKeyPath:@"act_id"];
            activity.post_id = [dict valueForKeyPath:@"post_id"];
            frame.activity = activity;
            [_lists addObject:frame];
            
}
        [self.tableView reloadData];
        NSLog(@"圈子活动列表---%@",_ActivityArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];

}
- (void)selectedMenuButton:(UIButton *)btn{
    
    [self.lastClickMenuButton setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    
    if (btn.tag == 3) {
        
        [_lists removeAllObjects];
        [self getActivity];
        MBClubActivityFrame *frame = [[MBClubActivityFrame alloc] init];
        MBClubActivity *activity = [[MBClubActivity alloc] init];
//        activity.title = @"#双十一你准备好了吗？# ";
//        activity.content = @"         对于大多数父母来说，掌握好如何照顾好孩子的技巧并非一件容易的事，因为每个孩子的脾气秉性都是不同的，孩子的需求也是在不断地变化的。那么，应该如何选择最佳的育儿方式呢？在这篇文章中，就为大家列举一些实用的育儿小技巧。";
        frame.activity = activity;
        
        _lists = [NSMutableArray arrayWithArray:@[
                                                  frame
                                                  ]];
    }else if (btn.tag == 0 || btn.tag == 1 || btn.tag == 2){
        if (btn.tag == 2) {
            [self getList];
        }else{
            _lists = nil;
        }
        [self.tableView reloadData];
    }
    [self.tableView registerClass:[NSClassFromString(self.cellIdentifers[btn.tag]) class]forCellReuseIdentifier:self.cellIdentifers[btn.tag]];
    [btn setTitleColor:[UIColor colorWithHexString:@"63a3c6"] forState:UIControlStateNormal];
    
    self.lastClickMenuButton = btn;
    
    [UIView animateWithDuration:.25 animations:^{
        self.menuLineView.ml_x = btn.tag * btn.ml_width;
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger mycount = 0;
    if (self.lastClickMenuButton.tag == 0 || self.lastClickMenuButton.tag == 1 || self.lastClickMenuButton.tag == 2 ) {
        mycount =  _TieZiListArray.count;
    }else if (self.lastClickMenuButton.tag == 3){
        mycount =  _ActivityArray.count;
    }

    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBClubTableViewCell *cell = (MBClubTableViewCell *)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifers[self.lastClickMenuButton.tag]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.lastClickMenuButton.tag == 0 || self.lastClickMenuButton.tag == 1 || self.lastClickMenuButton.tag == 2) {
        if (self.lastClickMenuButton.tag <= 1) {
//            cell.clubFrame = self.lists[indexPath.row];
        }else{
            cell.clubFrame = nil;
        }
    }else if (self.lastClickMenuButton.tag == 3){
        [cell setValue:self.lists[indexPath.row] forKeyPath:@"activityFrame"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.lastClickMenuButton.tag == 0 || self.lastClickMenuButton.tag == 1 || self.lastClickMenuButton.tag == 2 ) {
//        if (self.lists.count > indexPath.row) {
////            MBClubFrame *frame = self.lists[indexPath.row];
//            return 45;
//        }
//    }else if (self.lastClickMenuButton.tag == 3){
//        if (self.lists.count > indexPath.row) {
////            MBClubActivityFrame *activity = self.lists[indexPath.row];
//            return 45;
//        }
//    }
    
    return 45;
}

- (NSString *)titleImage{
    return @"logo";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void )rightTitleClick{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:self];
    CameraViewController *view = [[CameraViewController alloc] init];
    [self presentViewController:view animated:YES completion:nil];
    
    
}
- (NSString *) rightImage{
return @"service";
}
@end
