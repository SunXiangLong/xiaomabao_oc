//
//  MBTopPostCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBTopPostCell.h"
@interface MBTopPostCell ()
{


}
@end
@implementation MBTopPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageHeight.constant = (UISCREEN_WIDTH - 36)/3*133/184;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.array = dataDic[@"post_imgs"];
    [self.user_image sd_setImageWithURL:[NSURL URLWithString:dataDic[@"author_userhead"]] placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    self.user_name.text = dataDic[@"author_name"];
    self.circle_name.text = dataDic[@"circle_name"];
    self.post_title.text = dataDic[@"post_title"];
    self.post_content.text = dataDic[@"post_content"];
    

    self.post_content.rowspace   = 6;

}
-(NSArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = @[_image1,_image2,_image3];
    }
    
    return _imageArray;
}
-(void)setArray:(NSArray *)array{
    _array = array;
    NSInteger num = array.count;
    
    if (array.count>3) {
        num = 3;
    }
    
    
    for (NSInteger i = 0; i<num; i++) {
        UIImageView *imageView = self.imageArray[i];
        imageView .contentMode =  UIViewContentModeScaleAspectFill;
        imageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds  = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
    }
    
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += 40;
    totalHeight += [self.post_title sizeThatFits:size].height;
    totalHeight += [self.post_content sizeThatFits:size].height;
    totalHeight += 36;
    if (self.imageHeight.constant != 0) {
        totalHeight += self.imageHeight.constant;
       totalHeight += 10;
    }
   
    return CGSizeMake(size.width, totalHeight);
}
@end
