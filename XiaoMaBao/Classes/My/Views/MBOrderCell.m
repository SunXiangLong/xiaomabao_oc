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
#import "MBShopingViewController.h"
@implementation MBOrderCell

- (void)awakeFromNib {
    // Initialization code
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.userInteractionEnabled = YES;
    _orderTableView.scrollEnabled = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBAfterServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBAfterServiceTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MBAfterServiceTableViewCell" owner:nil options:nil]firstObject];
    }

        //第几组对应的goods_list
    NSDictionary *dict = _array[indexPath.row];
    NSString *urlstr ;
    for (NSDictionary *dic in _imageUrlArray) {
        NSString *good_id = dic[@"goods_id"];
        NSString *good_ID = dict[@"goods_id"];
        
        
        
        if ([good_ID isEqualToString:good_id]) {
            urlstr = dic[@"img"];
            dict = dic;
        }
    }
    
   
    
        NSURL *url = [NSURL URLWithString:urlstr];
        [cell.showImageview sd_setImageWithURL:url];
 
    //名字描述
    NSString *name1 = [dict valueForKeyPath:@"name"];
    cell.describe.text = name1;
    //数量以及价格
    NSString *goods_number = [dict valueForKeyPath:@"goods_number"];
    NSString *formated_shop_price = [dict valueForKeyPath:@"shop_price_formatted"];
    
    cell.priceAndNumber.text = [NSString stringWithFormat:@"%@ X %@",formated_shop_price,goods_number];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    
    
   
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBShopingViewController *VC = [[MBShopingViewController alloc] init];
    VC.GoodsId = _array[indexPath.row][@"goods_id"];
    [self.VC pushViewController:VC Animated:YES];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, self.ml_width, 20);
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *section_order_sn = [[UILabel alloc] init];
    section_order_sn.textColor = [UIColor blackColor];
    section_order_sn.text = [NSString stringWithFormat:@"子订单号：%@",_order_sn];
    section_order_sn.frame = CGRectMake(55, 0, self.ml_width - 100, sectionView.ml_height);
    section_order_sn.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:section_order_sn];
    [self.VC addBottomLineView:sectionView];
    return sectionView;
}

@end
