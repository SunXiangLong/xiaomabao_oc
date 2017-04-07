//
//  MBImageTableViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/1/4.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBImageTableViewCell.h"
@interface MBImageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@end
@implementation MBImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setUrl:(NSString *)url{
    _url = url;
    NSURL* URL = nil;
    if([url isKindOfClass:[NSURL class]]){
        URL = (NSURL *)url;
    }
    if([url isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:url];
    }
    [self.showImageView sd_setImageWithURL:URL placeholderImage:nil];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
