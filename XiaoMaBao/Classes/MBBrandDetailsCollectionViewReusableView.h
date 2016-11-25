//
//  MBBrandDetailsCollectionViewReusableView.h
//  XiaoMaBao
//
//  Created by xiaomabao on 16/9/19.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBBrandDetailModel.h"
@interface MBBrandDetailsCollectionViewReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *brand_logo;
@property (weak, nonatomic) IBOutlet YYLabel *brand_name;
@property (weak, nonatomic) IBOutlet YYLabel *brand_desc;
@property(copy,nonatomic)BrandModel *model;
@end
