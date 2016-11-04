//
//  MBDetailsCircleTbaleViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBDetailsCircleTbaleViewCell.h"

@interface MBDetailsCircleTbaleViewCell()
@property (weak, nonatomic) IBOutlet UILabel *post_title;
@property (weak, nonatomic) IBOutlet UILabel *post_time;
@property (weak, nonatomic) IBOutlet UILabel *reply_cnt;
@property (weak, nonatomic) IBOutlet UILabel *author_name;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *post_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic,strong) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@end

@implementation MBDetailsCircleTbaleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = @[_image1,_image2,_image3];
    }
    
    return _imageArray;
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.post_content.text = dataDic[@"post_content"];
    self.post_title.text = dataDic[@"post_title"];
    self.post_time.text = dataDic[@"post_time"];
    self.reply_cnt.text = dataDic[@"reply_cnt"];
    self.author_name.text = dataDic[@"author_name"];
    self.post_content.rowspace = 3;
    NSArray *array =  dataDic[@"post_imgs"];
    
    
    
    NSInteger num = array.count;
        if (array.count>0) {
            self.imageHeight.constant = (UISCREEN_WIDTH -50)/3*133/184;
            self.topHeight.constant = 10;
        }else{
            self.imageHeight.constant = 0;
            self.topHeight.constant = 0;
        }
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
    totalHeight += [self.post_title sizeThatFits:size].height;
    totalHeight += [self.post_content sizeThatFits:size].height;
    totalHeight += self.imageHeight.constant;
    totalHeight += self.topHeight.constant;
    totalHeight += 50;
    MMLog(@"%f---%f",self.topHeight.constant,self.imageHeight.constant);
    return CGSizeMake(size.width, totalHeight);
}

@end
