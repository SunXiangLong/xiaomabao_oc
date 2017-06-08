//
//  MBBabyToolCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyToolCell.h"
#import "MBLovelyBabyModel.h"
@implementation MBBabyToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setModel:(MBMyToolModel *)model{
    _model = model;
    [self.tool_image sd_setImageWithURL:model.toolkit_icon placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];
    self.tool_title.text = model.toolkit_name;
    _toolkit_remind_time.text = model.toolkit_remind_time;
    self.lableWidth.constant =0;
    if (model.toolkit_detail.count > 0) {
        [self.tool_center removeFromSuperview];
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
        self.tool_center.text = model.toolkit_desc;
    }
    
}
@end
