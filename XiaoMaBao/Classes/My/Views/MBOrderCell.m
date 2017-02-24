//
//  MBOrderCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/17.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "MBOrderCell.h"
#import "MBAfterServiceTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBGoodsDetailsViewController.h"
#import "MBOrderModel.h"
@implementation MBOrderCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.userInteractionEnabled = YES;
    _orderTableView.scrollEnabled = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goods_listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MBGoodListModel *model = _goods_listArray[indexPath.row];
    MBAfterServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAfterServiceTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBAfterServiceTableViewCell" owner:nil options:nil]firstObject];
    }
    
    [cell.showImageview sd_setImageWithURL:model.goods_img];
    
    //名字描述
    cell.describe.text = model.name;
    //数量以及价格
    NSString *goods_number = model.goods_number;
    NSString *formated_shop_price = model.shop_price_formatted;
    
    cell.priceAndNumber.text = [NSString stringWithFormat:@"%@ X %@",formated_shop_price,goods_number];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBGoodsDetailsViewController *VC = [[MBGoodsDetailsViewController alloc] init];
    VC.GoodsId = [_goods_listArray[indexPath.row] goods_id];
    [self.VC pushViewController:VC Animated:YES];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, self.ml_width, 30);
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *section_order_sn = [[UILabel alloc] init];
    section_order_sn.textColor = UIcolor(@"2c2c2c");
    section_order_sn.text = [NSString stringWithFormat:@"子订单号：%@",_order_sn];
    section_order_sn.frame = CGRectMake(10, 0, self.ml_width - 100, sectionView.ml_height);
    section_order_sn.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:section_order_sn];
    
    //订单状态
    UILabel *order_status = [[UILabel alloc] init];
    order_status.textColor = UIcolor(@"d66263");
    order_status.textAlignment=1;
    
    order_status.text = _order_status;
    order_status.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:order_status];

    [order_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        
    }];
    [section_order_sn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        
    }];
    
    return sectionView;
}
@end
