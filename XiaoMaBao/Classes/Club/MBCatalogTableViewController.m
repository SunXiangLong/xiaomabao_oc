//
//  MBCatalogTableViewController.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBCatalogTableViewController.h"

@interface MBCatalogTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bookIntroduction;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation MBCatalogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bookIntroduction.text = @"周末开会，表面看充满了一种只争朝夕、夙夜在公的‘工作干劲’，其实应该反过来想想：到底有多少真正要紧的事非得在周末兴师动众？”——北京某杂志社编辑陆晶陆晶在北京一家杂志社工作，谈起加班，她有很多话要说：“我的生活都被加班挤占了，不是在开会，就是在出差；\n不是在采访，就是在赶稿。”陆晶坦承，最初加班是自己拖沓造成的：“我刚开始做记者时，写稿精力不集中，不时聊聊天、看看手机，上班时没效率，只好晚上加班接着干。”“但很多时候，连续加班是单位对工作安排不合理造成的，这其实是对职工休息权的漠视。”陆晶说，“我还曾经参加过一个采访团，连续出差两周，周末也在工作。组织者压根儿就没有考虑过周末需要休息，反而认为周末采访是‘敬业’。”\n陆晶认为，很多在休息时间安排的加班完全可以避免，“有一个周末，我正陪父母逛街，突然接到同事电话，说有急事要集体到单位加班。我连忙赶到办公室，原来，是主编认为一篇稿子的结构有问题，要集体讨论修改。其实，稿子的出版日期排在了下个月，完全可以等第二天上班再说。”";
    
    _headView.mj_h = 400;
   self.title = @"图书";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBCatalogTableViewCell" forIndexPath:indexPath];
    [self setRemoveUIEdgeInsetsZero:cell];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"第一章 选择狗带的前端程序员";
    lable.textColor = UIcolor(@"333333");
    lable.font = SYSTEMFONT(13);
    [view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(11);
    }];
    return view;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/**
 *  移除cell最下的线
 */
- (void)setRemoveUIEdgeInsetsZero:(UITableViewCell *)cell{
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    cell.layoutMargins = UIEdgeInsetsMake(0, 10000, 0, 0);
    
}



@end
