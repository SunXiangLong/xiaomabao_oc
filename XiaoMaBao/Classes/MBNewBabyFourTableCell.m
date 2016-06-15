//
//  MBNewBabyFourTableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyFourTableCell.h"
#import "MBShopingViewController.h"
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
    
    if (sender.view.tag>1) {
        MBShopingViewController *VC = [[MBShopingViewController alloc] init];
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
    
    for (NSInteger i = 0; i<dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        UIImageView *imageView = arr[i];
        if (i>1) {
            [imageView sd_setImageWithURL:URL(dic[@"goods_img"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
        }else{
        
        [imageView sd_setImageWithURL:URL(dic[@"ad_img"]) placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
        }
    
    }

}
@end
