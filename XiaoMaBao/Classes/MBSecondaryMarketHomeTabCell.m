//
//  MBSecondaryMarketHomeTabCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/28.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSecondaryMarketHomeTabCell.h"
#import "MBSecondaryMarketModel.h"
@interface MBSecondaryMarketHomeTabCell()
{
    NSArray *_imageArr;

}
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage1;

@property (weak, nonatomic) IBOutlet UIImageView *centerImage2;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage3;
@property (weak, nonatomic) IBOutlet YYLabel *centerText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerTextHight;
@property (weak, nonatomic) IBOutlet YYLabel *price;
@property (weak, nonatomic) IBOutlet YYLabel *OriginalPrice;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;

@end
@implementation MBSecondaryMarketHomeTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageArr = @[_centerImage1,_centerImage2,_centerImage3];
}
-(void)setModel:(secondaryMarketGoodsListModel *)model{
    _model = model;
    [_headImage sd_setImageWithURL:model.uinfo.header_img placeholderImage:PLACEHOLDER_DEFAULT_IMG];
    _name.text = model.uinfo.user_name;
    
    _centerText.text = model.brief;
    _price.text = string(@"￥", model.price)  ;
    _OriginalPrice.text = string(@"原价：￥",  model.original_price);
    
    if (model.is_praise) {
        _praiseButton.selected = true;
    }else{
        _praiseButton.selected = false;
    }
   
    for (NSInteger i = 0; i< 3 ; i++) {
        UIImageView *imageView = _imageArr[i];
        
        if ( model.gallery.count > i  ) {
            [imageView sd_setImageWithURL:model.gallery[i].thumb_img placeholderImage:PLACEHOLDER_DEFAULT_IMG];
           
           
        }else{
             imageView.image = nil;
        }
    }

}
- (IBAction)btnAction:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
