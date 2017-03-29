//
//  MBCardHelpCenterTitleCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/3/22.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBCardHelpCenterTitleCell.h"

@implementation MBCardHelpCenterTitleCell
-(void)awakeFromNib{
    [super awakeFromNib];
    
}
@end


@implementation MBCardHelpCenterCenterCell
-(void)awakeFromNib{
    [super awakeFromNib];
    _centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 0)];
    [self.scrollew addSubview:_centerImage];
    


}

-(void)setImage:(UIImage *)image{

    _centerImage.image = image;
    _centerImage.mj_h = UISCREEN_WIDTH*image.size.height/image.size.width;
    _scrollew.contentSize = CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*image.size.height/image.size.width);

}

@end

@interface MBElectronicCardInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *card_name;
@property (weak, nonatomic) IBOutlet UILabel *card_num;
@property (weak, nonatomic) IBOutlet UILabel *card_password;

@end
@implementation MBElectronicCardInfoCell
-(void)awakeFromNib{
    [super awakeFromNib];
    
}

-(void)setModel:(virtualModel *)model{
    _model = model;
    _card_name.text = model.card_name;
    _card_num.text = model.card_no;
    _card_password.text = model.card_pass;
}
@end
@interface MBElectronicCardOrderCell()
@property (strong, nonatomic) UILabel *promptLable;
@end
@implementation MBElectronicCardOrderCell
-(void)setIsDataNull:(BOOL)isDataNull{
    _isDataNull = isDataNull;
    if (isDataNull) {
        _promptLable = [[UILabel alloc] init];
        _promptLable.textAlignment = 1;
        _promptLable.font = [UIFont systemFontOfSize:14];
        _promptLable.textColor = [UIColor colorR:146 colorG:147 colorB:148];
        [self.tableView addSubview:_promptLable];
        [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.tableView.mas_centerX);
            make.centerY.equalTo(self.tableView.mas_centerY);
        }];
        self.promptLable.text = @"暂时没有相关数据！";
    }
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.tableFooterView = [[UIView alloc] init];

}
@end
