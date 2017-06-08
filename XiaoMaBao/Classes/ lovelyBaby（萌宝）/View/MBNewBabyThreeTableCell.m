//
//  MBNewBabyThreeTableCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBNewBabyThreeTableCell.h"
#import "MBLovelyBabyModel.h"
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
-(void)setModel:(MBRecommendPostsModel *)model{
    _model = model;
    
    [_showImage sd_setImageWithURL:URL([model.post_imgs firstObject]) placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
    _post_title.text = model.post_title;
    _post_content.text = model.post_content;
    _view_cnt.text = model.view_cnt;
    _reply_cnt.text = model.reply_cnt;
}

@end
