//
//  MBBrandDetailsCollectionViewReusableView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBBrandDetailsCollectionViewReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *brand_logo;
@property (weak, nonatomic) IBOutlet UILabel *brand_name;
@property (weak, nonatomic) IBOutlet UILabel *brand_desc;
@property(copy,nonatomic)NSDictionary *dataDic;
@end
