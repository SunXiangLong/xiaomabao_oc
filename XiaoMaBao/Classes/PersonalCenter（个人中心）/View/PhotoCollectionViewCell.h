//
//  PhotoCollectionViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/1.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)UIImage *img;
@property(strong,nonatomic)NSURL *urlImg;
@property (nonatomic,copy)  void (^deleteTheImage)(UIImage *image);

@end
