//
//  MBRecommendedCollectionViewCell.h
//  XiaoMaBao
//
//  Created by liulianqi on 16/3/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCollectionViewController.h"
@interface MBRecommendedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *neirongLable;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (nonatomic,strong) XBCollectionViewController *VC;
@property (nonatomic,strong) NSString *user_id;



@end
