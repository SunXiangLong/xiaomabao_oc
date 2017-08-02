//
//  MBMBSMCategoryOneVC.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSMCategoryOneVC.h"
#import "MBSMCategoryCell.h"
#import "MBSMCategoryModel.h"
@interface MBSMCategoryOneVC ()
{
    NSInteger _row;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MBSMCategoryOneVC
-(void)setModel:(MBSMCategoryDataModel *)model{
    _model = model;
    [self.tableView reloadData];
    [self.tableView  selectRowAtIndexPath:[NSIndexPath indexPathForRow:_row inSection:0] animated:true scrollPosition:UITableViewScrollPositionTop];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
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
    return _model.data.count;
    
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
    
    MBSMCategoryOneTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBSMCategoryOneTabCell" forIndexPath:indexPath];
    cell.model = _model.data[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_row != indexPath.row) {
        _row = indexPath.row;
        _selectRow(_model.data[indexPath.row].cat_lists);
        
    }
}
@end
