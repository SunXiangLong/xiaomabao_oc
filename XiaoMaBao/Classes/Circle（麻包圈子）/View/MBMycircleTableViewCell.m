//
//  MBMycircleTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/4/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBMycircleTableViewCell.h"


@implementation MBMycircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSString *sid = [MBSignaltonTool getCurrentUserInfo].sid;
    if (sid&&_indexPath.section == 0 ) {
        self.user_button.selected = YES;
    }else{
        self.user_button.selected = NO;
    }
    self.user_name.text = dataDic[@"circle_name"];
    self.user_center.text = dataDic[@"circle_desc"];
    [self.user_image sd_setImageWithURL:[NSURL URLWithString:dataDic[@"circle_logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}
- (IBAction)touch:(id)sender {
    
    
    self.buttonClick(_indexPath);
   
}
-(void)cellButtonClick:(void (^)(NSIndexPath *))index{

    index(_indexPath);
}
- (CGSize)sizeThatFits:(CGSize)size {
  
    return CGSizeMake(size.width, 64);
}
@end
