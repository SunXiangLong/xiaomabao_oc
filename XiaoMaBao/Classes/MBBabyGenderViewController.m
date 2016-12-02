//
//  MBBabyGenderViewController.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2016/12/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyGenderViewController.h"
#import "MBSetBabyInformationController.h"
#import "MBNewBabyOneTableCell.h"
@interface MBBabyGenderViewController ()
@property (nonatomic,copy) NSArray *datArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MBBabyGenderViewController
-(NSArray *)datArr{
    if (!_datArr) {
        _datArr = @[@{@"title":@"小公主",@"summary":@"让她感到一种发展内心的安全感",@"icon": [UIImage imageNamed:@"babyGirl"]},
                    @{@"title":@"小王子",@"summary":@"让他养成男子豁达大度的个性",@"icon": [UIImage imageNamed:@"babyBoy"]}
                    ];
    }
    return _datArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [[UIView alloc] init];
}
- (IBAction)btn:(UIButton *)sender {
    NSString *babyGender = @"1";//代表男
    if (sender.tag == 0) {
       babyGender = @"0";
    }
    
}
-(NSString *)titleStr{
    return @"宝宝性别";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datArr.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 75;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        MBNewBabyOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBNewBabyOneTableCell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MBNewBabyOneTableCell"owner:nil options:nil]firstObject];
        }
        cell.dataDic = _datArr[indexPath.row];
        [cell uiedgeInsetsZero];
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *babyGender = @"1";//代表男
    if (indexPath.row == 0) {
        babyGender = @"0";
    }
    
    [self performSegueWithIdentifier:@"BabyInformationController" sender:babyGender];


}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MBSetBabyInformationController *VC = (MBSetBabyInformationController *)segue.destinationViewController;
    VC.babyGender = sender;
}


@end
