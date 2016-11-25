//
//  MBTableViewRmbCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBTableViewRmbCell.h"

@implementation MBTableViewRmbCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.showImageView .contentMode =  UIViewContentModeScaleAspectFill;
//    self.showImageView .autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.showImageView .clipsToBounds  = YES;
}
-(void)setImageUrl:(NSString *)str{
    __unsafe_unretained __typeof(self) weakSelf = self;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_num3"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSNotification *notification =[NSNotification notificationWithName:@"rmbTable_image_heght" object:nil userInfo:@{@"indexPath":weakSelf.indexPath,@"image_height":[NSString stringWithFormat:@"%f",UISCREEN_WIDTH*image.size.height/image.size.width]}];
        //通过通知中心发送通知
        if ([weakSelf.image_height floatValue]!=UISCREEN_WIDTH*image.size.height/image.size.width) {
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
        
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
