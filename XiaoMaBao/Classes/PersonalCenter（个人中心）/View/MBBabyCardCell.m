//
//  MBBabyCardCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyCardCell.h"
@interface MBBabyCardCell()
@property (weak, nonatomic) IBOutlet UILabel *babyCard;
@property (weak, nonatomic) IBOutlet UILabel *babyCardPrice;
@property (weak, nonatomic) IBOutlet UILabel *babyCardDate;
@property (weak, nonatomic) IBOutlet UIButton *seleButton;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@end
@implementation MBBabyCardCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)choose:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    _model.isSelected = sender.selected;
}
-(void)setModel:(MaBaoCardModel *)model{
    _model = model;
    _babyCard.text = string(@"卡号：", model.card_no);
    _babyCardPrice.text = string(@"抵用金额：", model.card_surplus_money);
    _babyCardDate.text = string(@"有效期：", model.use_end_time);;
     self.showImage.hidden = !model.over_date;
   
    _seleButton.enabled = !model.over_date;
    _seleButton.selected = _model.isSelected;
    _seleButton.hidden = _isJustLookAt;
    if (_isJustLookAt) {
        _top.constant = 70;
    }
    
}

@end
