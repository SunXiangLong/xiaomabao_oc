//
//  PhotoCollectionViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/1.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
@interface PhotoCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
@implementation PhotoCollectionViewCell

-(void)setImg:(UIImage *)img{
    _img = img;
    _image.image = img;
    
}
-(void)setUrlImg:(NSURL *)urlImg{
    _urlImg = urlImg;
     [_image sd_setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"icon_nav03"]];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    longPress.minimumPressDuration = 0.8;
    [self.image addGestureRecognizer:longPress];
}
-(void)handleLongPress{
   
    self.deleteTheImage(_img);
}
@end
