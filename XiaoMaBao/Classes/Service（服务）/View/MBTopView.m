//
//  MBTopView.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/1/5.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBTopView.h"
@interface MBTopView()
{
    NSArray *_meunArray;
    UIButton *_lastBtn;
    NSString *_sort;
    
}

@end
@implementation MBTopView
-(NSMutableArray<ServiceProductsModel *> *)productModelArray{
    if (!_productModelArray) {
        _productModelArray = [NSMutableArray array];
    }
    return _productModelArray;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.serviceViewNull.backgroundColor = [UIColor whiteColor];
    _lastBtn = _defaultBtn;
    _meunArray = @[@"normal",@"new",@"hot"];
    _sort = _meunArray.firstObject;
}

+ (instancetype )instanceView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"MBTopView" owner:nil options:nil] lastObject];
}
- (IBAction)btn:(UIButton *)sender {
    if ([_lastBtn isEqual:sender]) {
        return;
    }
    sender.selected = true;
    if (_lastBtn) {
        _lastBtn.selected = false;
    }
    _lastBtn = sender;
    self.block(_meunArray[sender.tag]);
    
}
- (IBAction)back:(id)sender {
    self.block(@"back");
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.productModelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBServiceSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBServiceSearchCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBServiceSearchCell" owner:nil options:nil]firstObject];
    }
    cell.model = _productModelArray[indexPath.row];
    [cell removeUIEdgeInsetsZero];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.block(_productModelArray[indexPath.row]);
    
}

@end
