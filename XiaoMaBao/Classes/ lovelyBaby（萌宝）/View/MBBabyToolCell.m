//
//  MBBabyToolCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyToolCell.h"
#import "MBLovelyBabyModel.h"

@interface MBBabyToolCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tool_image;
@property (weak, nonatomic) IBOutlet UILabel *tool_center;
@property (weak, nonatomic) IBOutlet UILabel *tool_title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableWidth;
@property (weak, nonatomic) IBOutlet UILabel *toolkit_remind_time;
@end
@implementation MBBabyToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self uiedgeInsetsZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setModel:(MBMyToolModel *)model{
    _model = model;
    [self.tool_image sd_setImageWithURL:model.toolkit_icon placeholderImage:[UIImage imageNamed:@"placeholder_num2"] options:SDWebImageAllowInvalidSSLCertificates];
    
    self.tool_title.text = model.toolkit_name;
    _toolkit_remind_time.text = model.toolkit_remind_time;
    self.lableWidth.constant =0;
    if (model.toolkit_detail.count > 0) {
        self.tool_center.hidden = true;
        NSString *str =  model.toolkit_remind_time;
        CGFloat widths = [str sizeWithFont:SYSTEMFONT(12) withMaxSize:CGSizeMake(MAXFLOAT, 15)].width;
        self.lableWidth.constant = widths + 8;
        NSArray *array ;
        if (model.toolkit_detail.count >3) {
            array = @[model.toolkit_detail[0],model.toolkit_detail[1],model.toolkit_detail[2]];
        }else{
            array = model.toolkit_detail;
        }
        CGFloat width = (UISCREEN_WIDTH -71)/2;
        CGFloat height = 20 ;
        for (NSInteger i = 0; i<array.count; i++) {
            [self.contentView  addSubview:({
                UILabel *t1 = [[UILabel alloc] init];
                t1.font = SYSTEMFONT(12);
                t1.textColor = UIcolor(@"8f9091");
                t1.text = model.toolkit_detail[i].t1;
                t1.frame = CGRectMake(45+13, 35+20*i,width , height);
                t1;
            })];
            
            [self.contentView  addSubview:({
                UILabel *t2 = [[UILabel alloc] init];
                t2.textAlignment = 2;
                t2.font = SYSTEMFONT(12);
                t2.textColor = UIcolor(@"8f9091");
                t2.text = model.toolkit_detail[i].t2;
                t2.frame = CGRectMake(45+13+width, 35+20*i,width , height);
                t2;
            })];
            
            
        }
    }else{
        for (UIView *view in self.contentView.subviews) {
            if ([view isKindOfClass:[UILabel class]]&&![view isEqual:_tool_center]&&![view isEqual:_tool_title]&&![view isEqual:_toolkit_remind_time]) {
                [view removeFromSuperview];
                
            }
        }
        self.tool_center.hidden = false;
        self.tool_center.text = model.toolkit_desc;
    }
    
}
@end
