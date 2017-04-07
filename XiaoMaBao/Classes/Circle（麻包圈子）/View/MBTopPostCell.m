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
    self.user_name.displaysAsynchronously = true;
    self.circle_name.displaysAsynchronously = true;
    self.post_title.displaysAsynchronously = true;
    self.post_content.displaysAsynchronously = true;
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
    CGFloat height = [dataDic[@"post_content"] sizeWithFont:SYSTEMFONT(14) withMaxSize:CGSizeMake(UISCREEN_WIDTH - 20, MAXFLOAT)].height;
    MMLog(@"%f",height);
    if (height > 54) {
        height = 54;
    }
    _post_contentheight.constant = height;

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
    self.imageHeight.constant = (UISCREEN_WIDTH - 36)/3*133/184;
    if (array.count == 0) {
        self.imageHeight.constant = 0;
        return;
    }
    if (array.count>3) {
        num = 3;
    }
    
    
    for (NSInteger i = 0; i<num; i++) {
        UIImageView *imageView = self.imageArray[i];
        imageView .contentMode =  UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[UIImage imageNamed:@"placeholder_num1"]];
    }
    
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += 40;
    totalHeight += [self.post_title sizeThatFits:size].height;
    totalHeight += 35;
    
    totalHeight += _post_contentheight.constant;
    if (self.imageHeight.constant != 0) {
        totalHeight += self.imageHeight.constant;
       totalHeight += 10;
    }
   
    return CGSizeMake(size.width, totalHeight);
}
@end
