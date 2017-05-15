//
//  MBSearchPostCVCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/5/10.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBSearchPostCVCell.h"
@interface MBSearchPostCVCell()
@property (weak, nonatomic) IBOutlet YYLabel *post_title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerHeight;
@property (weak, nonatomic) IBOutlet YYLabel *reply_cnt;
@property (weak, nonatomic) IBOutlet YYLabel *author_name;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet YYLabel *post_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic,strong) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@end
@implementation MBSearchPostCVCell
-(NSArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = @[_image1,_image2,_image3];
    }
    
    return _imageArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.post_title.displaysAsynchronously     = true;
    self.post_content.displaysAsynchronously   = true;
    self.author_name.displaysAsynchronously    = true;
    self.reply_cnt.displaysAsynchronously      = true;
}
- (NSMutableAttributedString*)getAttr:(NSString*)attributedString {
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:attributedString];
    
    //对齐方式 这里是 两边对齐
    resultAttr.yy_alignment = NSTextAlignmentLeft;
    //设置行间距
    resultAttr.yy_lineSpacing = 1;
    //设置字体大小
    resultAttr.yy_font = YC_YAHEI_FONT(13);
    resultAttr.yy_color = UIcolor(@"575757");
    //可以设置某段字体的大小
    //[resultAttr yy_setFont:[UIFont boldSystemFontOfSize:CONTENT_FONT_SIZE] range:NSMakeRange(0, 3)];
    //设置字间距
    resultAttr.yy_kern = [NSNumber numberWithFloat:1.0];
    
    return resultAttr;
    
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    YYTextContainer  *titleContarer = [YYTextContainer new];
    //限制宽度
    titleContarer.size             = CGSizeMake(UISCREEN_WIDTH - 30,CGFLOAT_MAX);
    NSMutableAttributedString  *titleAttr = [self getAttr:dataDic[@"post_content"]];
    YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:titleContarer text:titleAttr];
    CGFloat titleLabelHeight = titleLayout.textBoundingSize.height;
    _centerHeight.constant = titleLabelHeight;

    self.post_content.attributedText = titleAttr;
    self.post_title.text =   dataDic[@"post_title"];
    self.reply_cnt.text =    dataDic[@"reply_cnt"];
    self.author_name.text =  dataDic[@"author_name"];
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

@end
