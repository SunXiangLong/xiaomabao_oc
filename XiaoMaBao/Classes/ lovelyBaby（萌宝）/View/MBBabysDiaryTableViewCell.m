//
//  MBBabysDiaryTableViewCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/6/8.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBBabysDiaryTableViewCell.h"
#import "MBBabysDiaryModel.h"
@interface MBBabysDiaryTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *monthYear;
@property (weak, nonatomic) IBOutlet UILabel *weekAddtime;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet YYLabel *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerHeight;
@end
@implementation MBBabysDiaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _content.displaysAsynchronously = true;
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
-(void)setModel:(Result *)model{
    _model = model;
    _image2.hidden = false;
    _day.text = model.day;
    _monthYear.text = [NSString stringWithFormat:@"%@.%@",model.year,model.month];
    _weekAddtime.text = [NSString stringWithFormat:@"%@  %@",model.week,model.addtime];
    _position.text = model.position;
   
    
    YYTextContainer  *titleContarer = [YYTextContainer new];
    //限制宽度
    titleContarer.size             = CGSizeMake(UISCREEN_WIDTH - 30,CGFLOAT_MAX);
    NSMutableAttributedString  *titleAttr = [self getAttr:model.content];
    YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:titleContarer text:titleAttr];
    CGFloat titleLabelHeight = titleLayout.textBoundingSize.height;
    _centerHeight.constant = titleLabelHeight;
    
     _content.attributedText = titleAttr;
    if (model.photo.count == 0 ) {
        self.imageWidth.constant = self.imageHeight.constant = 0;
        _image1.image = nil;
        _image2.image = nil;
    }else if(model.photo.count > 1){
        self.imageWidth.constant = self.imageHeight.constant = (UISCREEN_WIDTH  - 50) * 0.5;
        [_image1 sd_setImageWithURL:URL(_model.photo.firstObject) placeholderImage:V_IMAGE(@"placeholder_num1")];
        [_image2 sd_setImageWithURL:URL(_model.photo[1]) placeholderImage:V_IMAGE(@"placeholder_num1")];
    }else{
    
        self.imageWidth.constant = UISCREEN_WIDTH - 40;
        self.imageHeight.constant = (UISCREEN_WIDTH - 40) * 0.5;
         [_image1 sd_setImageWithURL:URL(_model.photo.firstObject) placeholderImage:V_IMAGE(@"placeholder_num1")];
        _image2.hidden = true;
    }
    [self layoutIfNeeded];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (CGSize)sizeThatFits:(CGSize)size {

    
    return CGSizeMake(size.width, _position.ml_maxY +15);
}
@end
