//
//  PhotoCollectionViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 15/12/1.
//  Copyright © 2015年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoCollectionViewCellDelegate <NSObject>
-(void)setDeletePicture:(NSIndexPath *)indexpate;
@end
@interface PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic,strong) NSIndexPath *indexpate;
@property (nonatomic,assign) id<PhotoCollectionViewCellDelegate>dalegate;

@end
