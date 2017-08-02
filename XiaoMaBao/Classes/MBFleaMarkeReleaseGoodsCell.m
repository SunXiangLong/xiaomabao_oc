//
//  MBFleaMarkeReleaseGoodsCell.m
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/3.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "MBFleaMarkeReleaseGoodsCell.h"
@interface MBFleaMarkeReleaseGoodsCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIButton *goodsDelete;
@property (weak, nonatomic) IBOutlet UIImageView *goodsRootImage;

@end
@implementation MBFleaMarkeReleaseGoodsCell
- (IBAction)delete:(UIButton *)sender {

}

-(void)setImage:(UIImage *)image{
    _image = image;
    _goodsImage.image = image;

}
-(void)awakeFromNib{
    [super awakeFromNib];
}
@end
