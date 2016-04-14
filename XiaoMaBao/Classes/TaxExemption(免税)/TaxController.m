//
//  TaxController.m
//  XiaoMaBao
//
//  Created by 朱理哲 on 15/8/28.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "TaxController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "iCarousel.h"
#import "MBMallItemCategoryTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface TaxController()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
}

@property(weak,nonatomic)UITableView* tableView ;
@property(strong,nonatomic)NSMutableArray* TeMaiArarry ;
@end

@implementation TaxController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self generateView];
    [self requestData];
}

-(NSMutableArray *)TeMaiArarry{
    if (_TeMaiArarry==nil) {
        _TeMaiArarry = [NSMutableArray array];
    }
    return _TeMaiArarry  ;
}

-(void)generateView{
    UITableView* tableView = [[UITableView alloc]init];
    [tableView registerNib:[UINib nibWithNibName:@"MBMallItemCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"MBMallItemCategoryTableViewCell"];
    tableView.dataSource = self ;
    tableView.delegate = self ;
    tableView.frame = CGRectMake(0,TOP_Y, self.view.ml_width, self.view.ml_height - TOP_Y - 44 - 44) ;

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView = tableView ;
    [self.view addSubview:self.tableView];
}

//获取数据
-(void)requestData
{
    NSDictionary *pagination = @{@"page":@"1", @"count":@"100",@"menu_id":self.menu_id};
    [MBNetworking POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"home/getFavourableList"] parameters:pagination success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _TeMaiArarry = [responseObject valueForKeyPath:@"data"];
        [self animateReload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

-(void)animateReload{
    [UIView transitionWithView:self.tableView duration:.2 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        
    }];
}


#pragma ark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _TeMaiArarry.count ;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBMallItemCategoryTableViewCell *cell  = (MBMallItemCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MBMallItemCategoryTableViewCell" forIndexPath:indexPath];
    cell.decribe.text = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_name"];
    cell.zheKou.text = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"favourable_name"];
    NSString *urlstr = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"act_img"];
    NSString *endStr = [[_TeMaiArarry objectAtIndex:indexPath.row] valueForKeyPath:@"active_remainder_time"];
    NSString *timeStr = [NSDate deltaTimeFrom:nil end:endStr];
    cell.LeavesTime.text = timeStr;
    NSURL *url = [NSURL URLWithString:urlstr];
    [cell.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
    cell.startTimerLabel.hidden = YES;
    return cell ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"敬请期待！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"illustration_big_3"];
}

@end
