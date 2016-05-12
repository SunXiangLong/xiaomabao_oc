//
//  MBPostDetailsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsOneCell.h"
#import "MBPostDetailsViewCell.h"
@interface MBPostDetailsOneCell ()<UITableViewDelegate,UITableViewDataSource>
{
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation MBPostDetailsOneCell


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
    }else
    {
        for (UIView *sub in cell.contentView.subviews) {
            if ([sub isKindOfClass:[UIImageView class]]) {
                UIImageView *tempImageView= (UIImageView *)sub;
                tempImageView.image=nil;
            }
           
            
        }
    }
    cell.indexPath = indexPath;
    cell.rootIndexPath = self.rootIndexPath;
    cell.imageUrlStr =  self.imagUrlStrArray[indexPath.row];

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
