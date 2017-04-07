//
//  MBArticleViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBArticleViewCell.h"
#import "MBAudioPlayerHelper.h"
#import "XHMessageVoiceFactory.h"
@interface MBArticleViewCell()<MBSTKDataSourceDelegate>
{
    
}
@end
@implementation MBArticleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [XHMessageVoiceFactory messageVoiceAnimationImageView: self.showImageView ];
    

    
    
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.post_text.text = dataDic[@"abstract_text"];
    [self.post_text rowSpace:5];
    self.user_text.text =  string(@"作者:", dataDic[@"author"]) ;
    self.click_cnt.text = string(@"听过:", dataDic[@"click_cnt"]);
    [self.user_image sd_setImageWithURL:URL(dataDic[@"head_img"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
}
- (IBAction)voicePlay:(UIButton *)sender {
    // 创建FSAudioStream对象
    [self.showImageView startAnimating];
    [[MBAudioPlayerHelper shareInstance] setDelegate:self];
    [[MBAudioPlayerHelper shareInstance] managerAudioWithFileName:_dataDic[@"voice_file"] toID:_dataDic[@"id"]];
    
        
}
- (void)didAudioPlayerPausePlay:(STKAudioPlayer*)audioPlayer{

 [self.showImageView stopAnimating];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.post_text sizeThatFits:size].height;
    totalHeight += [self.user_text sizeThatFits:size].height;
    totalHeight += 50;
    totalHeight +=45;
    return CGSizeMake(size.width, totalHeight);
}
@end
