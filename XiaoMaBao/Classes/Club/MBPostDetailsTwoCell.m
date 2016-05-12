//
//  MBPostDetailsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsTwoCell.h"
#import "MBPostDetailsViewCell.h"
@interface MBPostDetailsTwoCell ()<UITableViewDelegate,UITableViewDataSource>
{
}
/**
 *  存放cell高度的数组
 */

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation MBPostDetailsTwoCell

- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setImagUrlStrArray:(NSArray *)imagUrlStrArray{
    _imagUrlStrArray = imagUrlStrArray;
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled  = NO;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _heightArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_heightArray[indexPath.row] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBPostDetailsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBPostDetailsViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBPostDetailsViewCell"owner:nil options:nil]firstObject];
    }
    cell.indexPath = indexPath;
     cell.rootIndexPath = self.rootIndexPath;
    cell.imageUrlStr = _imagUrlStrArray[indexPath.row];
   
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
