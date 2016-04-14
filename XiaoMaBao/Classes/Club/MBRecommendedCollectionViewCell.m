//
//  MBRecommendedCollectionViewCell.m
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "MBRecommendedCollectionViewCell.h"
#import "MBPersonalCanulaCircleViewController.h"
@implementation MBRecommendedCollectionViewCell

- (void)awakeFromNib {
    self.userImage.userInteractionEnabled = YES;
    [self.userImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)]];
    self.showImage .contentMode =  UIViewContentModeScaleAspectFill;
    self.showImage .autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.showImage .clipsToBounds  = YES;
    
}
- (void)backView{
    MBPersonalCanulaCircleViewController *VC = [[MBPersonalCanulaCircleViewController alloc] init];
    VC.user_id = self.user_id;
    [self.VC.navigationController pushViewController:VC animated:YES];
    
}

@end
