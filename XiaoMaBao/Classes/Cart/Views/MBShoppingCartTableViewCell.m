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
@interface MBShoppingCartTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew4;
@property (weak, nonatomic) IBOutlet UIImageView *Carimageview;
@property (weak, nonatomic) IBOutlet UILabel *GoodsDescribe;
@property (weak, nonatomic) IBOutlet UILabel *Goods_price;
@property (weak, nonatomic) IBOutlet UILabel *Market_Price;
@property (weak, nonatomic) IBOutlet UILabel *goods_number;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageview;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (nonatomic,strong) NSArray *imageArray;
@property(strong,nonatomic)NSString * isSelect;
@end
@implementation MBShoppingCartTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
}
-(void)tap:(UITapGestureRecognizer *)gesture{
    
     [MobClick event:@"ShoppingCart0"];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(click:)]) {
        [self.delegate click:self.row];
    }
    
    
    
}
-(void)setModel:(MBGood_ListModel *)model{
    _model = model;
    self.Goods_price.text = model.goods_price_formatted;
    self.Market_Price.text = model.market_price_formatted;
    self.goods_number.text = model.goods_number;
    self.GoodsDescribe.text = model.goods_name;
    if ([_model.flow_order integerValue] == 1) {
        self.isSelect = @"1";
        self.selectImageview.image = [UIImage imageNamed:@"icon_true"];
    }else{
        self.isSelect = @"0";
        self.selectImageview.image = [UIImage imageNamed:@"pitch_no"];
    
    }
    NSMutableArray *array = [NSMutableArray array];
    
    if ([model.is_third integerValue] == 1) {
        [array addObject:[UIImage imageNamed:@"thrid_goods_icon"]];
    }
    if ([model.coupon_disable integerValue] == 1) {
        [array addObject:[UIImage imageNamed:@"coupon_disable"]];
    }
    if ([model.is_cross_border integerValue] == 1) {
        [array addObject:[UIImage imageNamed:@"icon_cross_g"]];
        
    }
    if ([model.is_group integerValue] == 1) {
        [array addObject:[UIImage imageNamed:@"icon_group_g"]];
        
    }
    
    self.imageArray = array;
    
    
    
    [self.Carimageview sd_setImageWithURL:model.goods_img placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];



}

//数量减1
- (IBAction)reduce:(id)sender {
    [MobClick event:@"ShoppingCart4"];
    NSString * selected = self.isSelect;
    
    //数量减1
    NSString *number = self.goods_number.text;
    NSInteger goodNumber = [number integerValue];
    goodNumber--;
    
    if([self.isSelect isEqualToString:@"0"]){
        self.goods_number.text = [NSString stringWithFormat:@"%ld",goodNumber];
    }
    
    //创建通知
    NSString * goods_number = [NSString stringWithFormat:@"%ld",goodNumber ];
    NSString * rec_id = _model.rec_id;
    NSString *row = [NSString stringWithFormat:@"%ld",self.row];
    NSDictionary *reduceNumber = [NSDictionary dictionaryWithObjectsAndKeys:goods_number,@"goods_number",rec_id,@"rec_id", selected,@"selected",row,@"row",nil];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(reduceShop:)]) {
        [self.delegate  reduceShop:reduceNumber];
    }
    
    
}
//数量加1
- (IBAction)Add:(id)sender {
     [MobClick event:@"ShoppingCart3"];
    
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
    NSString * rec_id = _model.rec_id;
    
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
- (CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(size.width, 62);
}
@end
