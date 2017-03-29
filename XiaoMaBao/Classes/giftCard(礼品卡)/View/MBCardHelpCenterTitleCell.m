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


@implementation MBElectronicCardOrderCell
-(void)awakeFromNib{
    [super awakeFromNib];
   
    self.tableView.tableFooterView = [[UIView alloc] init];

}
@end
