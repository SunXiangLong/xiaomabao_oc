//
//  MBBabyToolCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBBabyToolCell.h"

@implementation MBBabyToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic ;
    [self.tool_image sd_setImageWithURL:URL(dataDic[@"toolkit_icon"]) placeholderImage:[UIImage imageNamed:@"placeholder_num2"]];

    self.tool_title.text = dataDic[@"toolkit_name"];
    self.toolkit_remind_time.text = dataDic[@"toolkit_remind_time"];
    self.lableWidth.constant =0;
    NSArray *arr = dataDic[@"toolkit_detail"];
    
    if (arr&&arr.count>0) {
        [self.tool_center removeFromSuperview];
        NSString *str =  dataDic[@"toolkit_remind_time"];
        CGFloat widths = [str sizeWithFont:SYSTEMFONT(12) withMaxSize:CGSizeMake(MAXFLOAT, 15)].width;
        self.lableWidth.constant = widths + 8;
        NSArray *array ;
        if (arr.count >3) {
            array = @[arr[0],arr[1],arr[2]];
        }else{
            array = arr;
        }
        CGFloat width = (UISCREEN_WIDTH -71)/2;
        CGFloat height = 20 ;
        for (NSInteger i = 0; i<array.count; i++) {
            [self.contentView  addSubview:({
                UILabel *t1 = [[UILabel alloc] init];
                t1.font = SYSTEMFONT(12);
                t1.textColor = UIcolor(@"8f9091");
                t1.text = arr[i][@"t1"];
                t1.frame = CGRectMake(45+13, 35+20*i,width , height);
                t1;
            })];
            
            [self.contentView  addSubview:({
                UILabel *t2 = [[UILabel alloc] init];
                t2.textAlignment = 2;
                t2.font = SYSTEMFONT(12);
                t2.textColor = UIcolor(@"8f9091");
                t2.text = arr[i][@"t2"];
                t2.frame = CGRectMake(45+13+width, 35+20*i,width , height);
                t2;
            })];
        
            
        }
    }else{
     self.tool_center.text = dataDic[@"toolkit_desc"];
    }
}
@end
