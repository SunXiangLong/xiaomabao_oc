//
//  MBBabyStateViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/11/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyStateViewController.h"
#import "MBNewBabyOneTableCell.h"
#import "MBBabyDueDateController.h"
@interface MBBabyStateViewController ()
{
 

}
@property (nonatomic,copy) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MBBabyStateViewController
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"我在怀孕中",@"summary":@"怀胎十月，关爱母婴健康",@"icon": [UIImage imageNamed:@"babyUnborn"]},
                     @{@"title":@"宝宝以出生",@"summary":@"产后调养与恢复，和宝宝共同健康成长",@"icon": [UIImage imageNamed:@"babyBorn"]}
                     ];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [[UIView alloc] init];
    
}
-(NSString *)titleStr{
return @"宝宝状态";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark ---UITableViewDelagate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    MBNewBabyOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyOneTableCell"owner:nil options:nil]firstObject];
    }
    cell.dataDic = _dataArr[indexPath.row];
    [cell uiedgeInsetsZero];
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        MBBabyDueDateController *VC = [[MBBabyDueDateController alloc] init];
        
        [self pushViewController:VC Animated:YES];
    }else{
        
        [self performSegueWithIdentifier:@"sunxianglong" sender:nil];
    }
}
@end
