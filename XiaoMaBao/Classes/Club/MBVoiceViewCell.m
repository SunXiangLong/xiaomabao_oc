//
//  MBVoiceViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBVoiceViewCell.h"

@implementation MBVoiceViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.view_height.constant = (UISCREEN_WIDTH - 42)/3;
}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _post_title.text    = _dataDic[@"title"];
    _post_center.text = _dataDic[@"abstract_text"];
    [_post_center rowSpace:5];
    _user_title.text = string(@"作者 ：", _dataDic[@"author"]);
    _atype.text = _dataDic[@"atype"];
    if ([_atype.text isEqualToString: @"图书"]) {
        _atype.layer.borderColor = UIcolor(@"81c762").CGColor;
        _atype.textColor = UIcolor(@"81c762");
    }
    NSArray *imageArr = @[_post_image1,_post_image2,_post_image3];
    NSInteger num = 0;
    if ([_dataDic[@"imgs"] count] == 0) {
        self.view_height.constant = 0;
    }else if([_dataDic[@"imgs"] count] >3){
        num = 3;
    }else{
        num = [_dataDic[@"imgs"] count];
    }
    
    for (NSInteger i = 0; i<num; i++) {
        UIImageView *imageView = imageArr[i];
        [imageView   sd_setImageWithURL:URL(_dataDic[@"imgs"][i])];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.post_title sizeThatFits:size].height;
    totalHeight += [self.post_center sizeThatFits:size].height;
    totalHeight += [_dataDic[@"imgs"] count]>0?(UISCREEN_WIDTH - 42)/3:0;
    totalHeight += [self.user_title sizeThatFits:size].height;
    
    totalHeight += [_dataDic[@"imgs"] count]>0?69:58;
    
    return CGSizeMake(size.width, totalHeight);
}
@end
