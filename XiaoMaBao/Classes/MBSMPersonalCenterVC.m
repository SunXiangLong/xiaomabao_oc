//
//  MBSMPersonalCenterVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSMPersonalCenterVC.h"
#import "MBSMCategoryCell.h"
@interface MBSMPersonalCenterVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) NSArray *dataArr;
@end

@implementation MBSMPersonalCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [UIView new];
 
    _dataArr = @[
                @{@"image":V_IMAGE(@"myRelease"),@"title":@"我发布的",@"number":@"10"},
                @{@"image":V_IMAGE(@"mySell"),@"title":@"我卖出的",@"number":@"10"},
                @{@"image":V_IMAGE(@"myBuy"),@"title":@"我买到的",@"number":@"10"},
                @{@"image":V_IMAGE(@"thumbUp"),@"title":@"被点赞的",@"number":@"10"},
                @{@"image":V_IMAGE(@"myBill"),@"title":@"我的账单",@"number":@"10"}
                ];
    [self.tableView reloadData];
     MBUserDataSingalTon *userInfo = [MBSignaltonTool getCurrentUserInfo];
    [_headImage sd_setImageWithURL:URL(userInfo.header_img) placeholderImage:[UIImage imageNamed:@"headPortrait"]];
    _name.text = userInfo.nick_name;
    // Do any additional setup after loading the view.
}
-(NSString *)titleStr{
    return  @"个人中心";
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
#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return  45;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return  0.001;
//
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    return UISCREEN_WIDTH * 35/75 + 170;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBSMPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBSMPersonalCenterCell" forIndexPath:indexPath];
    cell.dataDic = _dataArr[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:[self performSegueWithIdentifier:@"fleaMarketMyReleaseVC" sender:nil];break;
        case 1:[self performSegueWithIdentifier:@"fleaMarketBuyVC" sender:nil];break;
        case 2:[self performSegueWithIdentifier:@"fleaMarketSellingVC" sender:nil];break;
//        case 3:[self performSegueWithIdentifier:@"fleaMarketPraiseVC" sender:nil];break;
        case 4:[self performSegueWithIdentifier:@"fleaMarketBillVC" sender:nil];break;
        default:
            break;
    }
    
    
}
@end
