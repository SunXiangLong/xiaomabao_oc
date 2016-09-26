//
//  MBPostDetailsOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsOneCell.h"

@interface MBPostDetailsOneCell ()
@property (weak, nonatomic) IBOutlet UILabel *post_title;
@property (weak, nonatomic) IBOutlet UILabel *author_name;
@property (weak, nonatomic) IBOutlet UILabel *reply_cnt;
@property (weak, nonatomic) IBOutlet UILabel *circle_name;
@property (weak, nonatomic) IBOutlet UIImageView *author_userhead;
@property (weak, nonatomic) IBOutlet UILabel *post_content;
@property (strong, nonatomic)   UIImageView *oldimageView;
@end
@implementation MBPostDetailsOneCell


- (void)awakeFromNib {
    [super awakeFromNib];
   self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    self.post_content.text = dataDic[@"post_content"];
    self.post_title.text = dataDic[@"post_title"];
    self.author_name.text = dataDic[@"author_name"];
//    self.reply_cnt.text = dataDic[@"reply_cnt"];
//    self.circle_name.text = dataDic[@"circle_name"];
    [self.author_userhead  sd_setImageWithURL:URL(dataDic[@"author_userhead"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    [self.post_content rowSpace:6];
    [self.post_title rowSpace:2];
    
    
    
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight+= [self.post_title sizeThatFits:size].height;
    totalHeight+= [self.author_name sizeThatFits:size].height;
    totalHeight+= [self.dataDic[@"post_content"] sizeWithFont:SYSTEMFONT(16) lineSpacing:6 withMax:UISCREEN_WIDTH-20];
    totalHeight+=65;
    return CGSizeMake(size.width, totalHeight);
}
@end
