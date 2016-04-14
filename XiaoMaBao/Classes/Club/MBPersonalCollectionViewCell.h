//
//  MBPersonalCollectionViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPersonalCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@property (weak, nonatomic) IBOutlet UILabel *praise;

@end
