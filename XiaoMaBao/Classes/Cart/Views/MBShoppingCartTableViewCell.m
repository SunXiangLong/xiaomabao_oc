//
//  MBShoppingCartTableViewCell.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/6/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "MBShoppingCartTableViewCell.h"
#import "MBNetworking.h"
#import "MBSignaltonTool.h"
@implementation MBShoppingCartTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(size.width, 62);
}
-(void)tap:(UITapGestureRecognizer *)gesture{
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(click:)]) {
        [self.delegate click:self.row];
    }
    
    
    
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.Goods_price.text = dataDic[@"goods_price_formatted"];
    self.Market_Price.text = dataDic[@"market_price_formatted"];
    self.goods_number.text = dataDic[@"goods_number"];
    self.GoodsDescribe.text = dataDic[@"goods_name"];
    self.goodID = dataDic[@"goods_id"];
    self.rec_id = dataDic[@"rec_id"];
    
    NSInteger flow_order = [dataDic[@"flow_order"] integerValue];
    if (flow_order == 1) {
        self.isSelect = @"1";
        self.selectImageview.image = [UIImage imageNamed:@"icon_true"];
        
    }else{
        self.isSelect = @"0";
        self.selectImageview.image = [UIImage imageNamed:@"pitch_no"];
        
        
    }
    NSMutableArray *array = [NSMutableArray array];
    
    if ([dataDic[@"is_third"] isEqualToString:@"1"]) {
        [array addObject:[UIImage imageNamed:@"thrid_goods_icon"]];
    }
    if ([dataDic[@"coupon_disable"]isEqualToString:@"1"]) {
        [array addObject:[UIImage imageNamed:@"coupon_disable"]];
    }
    if ([dataDic[@"is_cross_border"]isEqualToString:@"1"]) {
        [array addObject:[UIImage imageNamed:@"icon_cross_g"]];
        
    }
    if ([dataDic[@"is_group"]isEqualToString:@"1"]) {
        [array addObject:[UIImage imageNamed:@"icon_group_g"]];
        
    }
    
    self.imageArray = array;
    
    NSURL *url = [NSURL URLWithString:dataDic[@"goods_img"]];
    
    [self.Carimageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}

//数量减1
- (IBAction)reduce:(id)sender {
    
    NSString * selected = self.isSelect;
    
    //数量减1
    NSString *number = self.goods_number.text;
    NSInteger goodNumber = [number integerValue];
    goodNumber--;
    if (goodNumber <= 0) {
        [self.viewController  show:@"商品件数最少为1" time:1];
        return;
    }
    if([self.isSelect isEqualToString:@"0"]){
        self.goods_number.text = [NSString stringWithFormat:@"%ld",goodNumber];
    }
    
    //创建通知
    NSString * goods_number = [NSString stringWithFormat:@"%ld",goodNumber ];
    NSString * rec_id = self.rec_id;
    NSString *row = [NSString stringWithFormat:@"%ld",self.row];
    NSDictionary *reduceNumber = [NSDictionary dictionaryWithObjectsAndKeys:goods_number,@"goods_number",rec_id,@"rec_id", selected,@"selected",row,@"row",nil];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(reduceShop:)]) {
        [self.delegate  reduceShop:reduceNumber];
    }
    
    
}
//数量加1
- (IBAction)Add:(id)sender {
    
    
    NSString * selected = self.isSelect;
    //数量加1
    NSString *number = self.goods_number.text;
    NSInteger goodNumber = [number integerValue];
    goodNumber++;
    
    if([self.isSelect isEqualToString:@"0"]){
        self.goods_number.text = [NSString stringWithFormat:@"%ld",goodNumber];
    }
    
    //创建通知
    NSString * goods_number = [NSString stringWithFormat:@"%ld",goodNumber];
    NSString * rec_id = self.rec_id;
    
    NSString *row = [NSString stringWithFormat:@"%ld",self.row];
    
    NSDictionary *reduceNumber = [NSDictionary dictionaryWithObjectsAndKeys:goods_number,@"goods_number",rec_id,@"rec_id", selected,@"selected",row,@"row", nil];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(addShop:)]) {
        [self.delegate  addShop:reduceNumber];
    }
    
    
}

-(NSString *)subwitstring:(NSString *)str
{
    NSString *subtotal1 = [str substringFromIndex:1];
    NSString *subtotal2 = [subtotal1 substringToIndex:subtotal1.length-1];
    return subtotal2;
}

-(void)setImageArray:(NSArray *)imageArray{
    
     self.imageView1.image = nil;
     self.imageView2.image = nil;
     self.imageView3.image = nil;
     self.imageVIew4.image = nil;
    _imageArray = imageArray;
    switch (imageArray.count) {
        case 0:            break;
        case 1:   self.imageView1.image = imageArray[0];         break;
        case 2:   self.imageView1.image= imageArray[0];self.imageView2.image =imageArray[1];       break;
        case 3: self.imageView1.image= imageArray[0];self.imageView2.image =imageArray[1];
            self.imageView3.image=imageArray[2]; break;
        default:self.imageView1.image= imageArray[0];self.imageView2.image =imageArray[1];
            self.imageView3.image=imageArray[2]; self.imageVIew4.image = imageArray[3];
            break;
    }
}

@end
