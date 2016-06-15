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
    
    self.tool_center.text = dataDic[@"toolkit_desc"];
    self.tool_title.text = dataDic[@"toolkit_name"];
}
@end
