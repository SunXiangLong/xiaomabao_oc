//
//  MBNewBabyFourTableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyFourTableCell.h"
#import "MBGoodsDetailsViewController.h"
#import "MBActivityViewController.h"
@implementation MBNewBabyFourTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)dianji:(UITapGestureRecognizer *)sender {

    NSDictionary *dic = _dataArr[sender.view.tag];
    [MobClick event:@"Mengbao7"];
    if (sender.view.tag>1) {
        MBGoodsDetailsViewController *VC = [[MBGoodsDetailsViewController alloc] init];
        VC.GoodsId =  dic[@"goods_id"];
        [self.VC pushViewController:VC Animated:YES];
        
    }else{
    
        MBActivityViewController *VC = [[MBActivityViewController alloc] init];
        VC.act_id = dic[@"act_id"];
        VC.title = dic[@"ad_name"];
        [self.VC pushViewController:VC Animated:YES];
    }
   
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    NSArray *arr = @[_image0,_image1,_image2,_image3,_image4,_image5];
    NSArray *goods_name_arr = @[@1,@2,_goods_name0,_goods_name1,_goods_name2,_goods_name3];
    NSArray *goods_price_arr= @[@1,@2,_goods_price0,_goods_price1,_goods_price2,_goods_price3];
    NSArray *market_price_arr = @[@1,@2,_market_price0,_market_price1,_market_price2,_market_price3];
    for (NSInteger i = 0; i<dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        UIImageView *imageView = arr[i];
        
        if (i>1) {
            UILabel *goods_name_label = goods_name_arr[i];
            UILabel *goods_price_label = goods_price_arr[i];
            UILabel *market_price_label = market_price_arr[i];
            [imageView sd_setImageWithURL:URL(dic[@"goods_thumb"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
            goods_name_label.text = dic[@"goods_name"];
            goods_price_label.text = string(@"¥", dic[@"goods_price"]);
            market_price_label.text = string(@"¥", dic[@"market_price"]);
        }else{
        
        [imageView sd_setImageWithURL:URL(dic[@"ad_img"]) placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
        }
       
    
    }

}
@end
