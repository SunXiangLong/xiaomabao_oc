//
//  MBabyRecordOneCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/6/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBabyRecordOneCell.h"


@interface MBabyRecordOneCell ()
{
    
}

@end
@implementation MBabyRecordOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touch:(UITapGestureRecognizer *)sender {
    
    
    [self.myCircleViewSubject sendNext:@(sender.view.tag)];
    
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    NSArray *imageArr = @[self.image0,self.image1,self.image2,self.image3,self.image4];
    for (id object in _dataArr) {
        
         UIImageView *imageView = imageArr[[_dataArr indexOfObject:object]];
        if ([object isKindOfClass:[NSString class]]) {
          
            
            [imageView sd_setImageWithURL:URL(object) placeholderImage:[UIImage imageNamed:@"amengBaoLeft"]];
            
        }else if([object isKindOfClass:[UIImage class ]]){
            
            
            imageView.image = object;
        }
        
    }
   
}


@end
