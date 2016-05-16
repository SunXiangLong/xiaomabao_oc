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
     __unsafe_unretained __typeof(self) weakSelf = self;
   [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"img_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
       NSNumber *number = @((UISCREEN_WIDTH-20)*image.size.height/image.size.width);
        NSNotification *notification =[NSNotification notificationWithName:@"MBPostDetailsViewNOtifition" object:nil userInfo:@{@"number":number,@"indexPath":weakSelf.indexPath,@"rootIndexPath":weakSelf.rootIndexPath}];
       [[NSNotificationCenter defaultCenter] postNotification:notification];
   }];
  
}

@end
