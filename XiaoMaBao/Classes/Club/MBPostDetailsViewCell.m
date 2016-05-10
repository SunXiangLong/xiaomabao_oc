//
//  MBPostDetailsViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBPostDetailsViewCell.h"

@implementation MBPostDetailsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImageUrlStr:(NSString *)imageUrlStr{
      @weakify(self);
   [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"img_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
       
       NSNumber *number = @((UISCREEN_WIDTH-20)*image.size.height/image.size.width);
        [self.myCircleViewSubject  sendNext:@[number,_indexPath]];
   }];
  
}
- (RACSubject *)myCircleViewSubject {
    
    if (!_myCircleViewSubject) {
        
        _myCircleViewSubject = [RACSubject subject];
    }
    
    return _myCircleViewSubject;
}
@end
