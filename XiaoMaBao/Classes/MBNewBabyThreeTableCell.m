//
//  MBNewBabyThreeTableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyThreeTableCell.h"

@implementation MBNewBabyThreeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _showImage.contentMode = UIViewContentModeScaleAspectFill;
    _showImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [_showImage sd_setImageWithURL:URL([_dataDic[@"post_imgs"] firstObject]) placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
    _post_title.text = _dataDic[@"post_title"];
    _post_content.text = _dataDic[@"post_content"];
    _view_cnt.text = _dataDic[@"view_cnt"];
    _reply_cnt.text = _dataDic[@"reply_cnt"];

}
@end
