//
//  MBPostDetailsViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsViewCell.h"
@interface MBPostDetailsViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
@implementation MBPostDetailsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
     [_image  sd_setImageWithURL:URL(imageUrl)];

}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 5;
    totalHeight+=(UISCREEN_WIDTH - 20)/self.num;
    return CGSizeMake(size.width, totalHeight);
}

@end
