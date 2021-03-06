//
//  MBNewBabyFourTableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyFourTableCell.h"
#import "MBLovelyBabyModel.h"
@interface MBNewBabyFourTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *image0;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *goods_name0;
@property (weak, nonatomic) IBOutlet UILabel *goods_name1;
@property (weak, nonatomic) IBOutlet UILabel *goods_name2;
@property (weak, nonatomic) IBOutlet UILabel *goods_name3;
@property (weak, nonatomic) IBOutlet UILabel *goods_price0;
@property (weak, nonatomic) IBOutlet UILabel *goods_price1;
@property (weak, nonatomic) IBOutlet UILabel *goods_price2;
@property (weak, nonatomic) IBOutlet UILabel *goods_price3;
@property (weak, nonatomic) IBOutlet UILabel *market_price0;
@property (weak, nonatomic) IBOutlet UILabel *market_price1;
@property (weak, nonatomic) IBOutlet UILabel *market_price3;
@property (weak, nonatomic) IBOutlet UILabel *market_price2;
@end
@implementation MBNewBabyFourTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self uiedgeInsetsZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)dianji:(UITapGestureRecognizer *)sender {


    [MobClick event:@"Mengbao7"];
    if (sender.view.tag > 1) {
        
         self.recommendCommodities(sender.view.tag, true);
        
    }else{
        self.recommendCommodities(sender.view.tag, false);
        
    }
    
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    NSArray *arr = @[_image0,_image1,_image2,_image3,_image4,_image5];
    NSArray *goods_name_arr = @[@1,@2,_goods_name0,_goods_name1,_goods_name2,_goods_name3];
    NSArray *goods_price_arr= @[@1,@2,_goods_price0,_goods_price1,_goods_price2,_goods_price3];
    NSArray *market_price_arr = @[@1,@2,_market_price0,_market_price1,_market_price2,_market_price3];
    for (NSInteger i = 0; i<dataArr.count; i++) {
       
        UIImageView *imageView = arr[i];
        
        if (i>1) {
             MBRecommend_goodsModel *model  = dataArr[i];
            UILabel *goods_name_label = goods_name_arr[i];
            UILabel *goods_price_label = goods_price_arr[i];
            UILabel *market_price_label = market_price_arr[i];
            [imageView sd_setImageWithURL:model.goods_thumb placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
            goods_name_label.text = model.goods_name;;
            goods_price_label.text = string(@"¥", model.goods_price);
            market_price_label.text = string(@"¥", model.market_price);
        }else{
         MBRecommendTopicsModel *model  = dataArr[i];
        [imageView sd_setImageWithURL:model.ad_img placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
        }
       
    
    }

}
@end
