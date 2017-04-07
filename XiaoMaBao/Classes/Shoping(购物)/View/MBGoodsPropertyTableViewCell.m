//
//  MBGoodsPropertyTableViewCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/2/23.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBGoodsPropertyTableViewCell.h"
@interface MBGoodsPropertyTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *nullData;
@property (weak, nonatomic) IBOutlet UILabel *GoodsProperty;

@end
@implementation MBGoodsPropertyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
-(void)setIsShowImage:(BOOL)isShowImage{
    _isShowImage = isShowImage;
    _nullData.hidden = !isShowImage;
}
-(void)setModel:(MBGoodsPropertyModel *)model{
    _model = model;
    _nullData.hidden = true;
    _GoodsProperty.text =  [NSString stringWithFormat:@"%@: %@",_model.name,_model.value];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGSize)sizeThatFits:(CGSize)size {
    
    if (_isShowImage) {
        return  CGSizeMake(size.width, UISCREEN_WIDTH *16/75);
    }
    CGFloat totalHeight = 0;
    totalHeight += [self.GoodsProperty sizeThatFits:size].height;
    totalHeight +=20;
    return  CGSizeMake(size.width, totalHeight);
}
@end
