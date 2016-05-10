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
@property (copy, nonatomic) NSMutableArray *heightArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation MBPostDetailsTwoCell
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
-(NSMutableArray *)heightArray{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setImagUrlStrArray:(NSArray *)imagUrlStrArray{
    _imagUrlStrArray = imagUrlStrArray;
    for (NSInteger i= 0 ; i<imagUrlStrArray.count; i++) {
        [self.heightArray addObject:@((UISCREEN_WIDTH-20)*105/125)];
    }
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
    NSLog(@"%lu",_heightArray.count);
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
    cell.imageUrlStr = _imagUrlStrArray[indexPath.row];
    @weakify(self);
    [[cell.myCircleViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *arr) {
        @strongify(self);
        NSNumber *cellHeight = arr.firstObject;
        NSIndexPath *indexPath = arr.lastObject;
        _heightArray[indexPath.row] = cellHeight;
        [self.myCircleViewSubject  sendNext:@[cellHeight,_indexPath]];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        
    }];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
